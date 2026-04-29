import 'package:noor_quran/core/common/constants/surah_names.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';
import 'package:noor_quran/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';
import 'package:noor_quran/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/player_state_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/voice_ayah_by_ayah_provider.dart';
import 'package:qcf_quran/qcf_quran.dart';

class FullAudioPlayerPage extends ConsumerStatefulWidget {
  const FullAudioPlayerPage({super.key});

  @override
  ConsumerState<FullAudioPlayerPage> createState() =>
      _FullAudioPlayerPageState();
}

class _FullAudioPlayerPageState extends ConsumerState<FullAudioPlayerPage> {
  // حالة التحكم في التكرار (متغير محلي للصفحة)
  LoopMode _loopMode = LoopMode.off;

  @override
  void initState() {
    super.initState();
    // إعداد التكرار الحالي للمشغل
    final player = ref.read(audioPlayerProvider);
    _loopMode = player.loopMode;
  }

  void _playNextAyah() async {
    final currentAyah = ref.read(currentPlayingAyahProvider);
    if (currentAyah == null) return;

    int nextAyah = currentAyah.ayahNumber + 1;
    int nextSurah = currentAyah.surahNumber;

    // فحص إذا انتهت السورة
    final verseCount = getVerseCount(nextSurah);
    if (nextAyah > verseCount) {
      if (nextSurah == 114) {
        // وصلنا لآخر القرآن
        return;
      }
      nextSurah += 1;
      nextAyah = 1;
    }

    _loadAndPlay(nextSurah, nextAyah);
  }

  void _playPreviousAyah() async {
    final currentAyah = ref.read(currentPlayingAyahProvider);
    if (currentAyah == null) return;

    int prevAyah = currentAyah.ayahNumber - 1;
    int prevSurah = currentAyah.surahNumber;

    if (prevAyah < 1) {
      if (prevSurah == 1) return; // أول القرآن
      prevSurah -= 1;
      prevAyah = getVerseCount(prevSurah);
    }

    _loadAndPlay(prevSurah, prevAyah);
  }

  Future<void> _loadAndPlay(int surah, int ayah) async {
    final player = ref.read(audioPlayerProvider);
    await player.stop();

    // تحديث البيانات الحالية
    ref.read(currentPlayingAyahProvider.notifier).state = CurrentPlayingAyah(
      surahNumber: surah,
      ayahNumber: ayah,
      surahName: SurahNames.getFormattedName(surah),
    );

    // جلب الرابط والتحديث
    final selectedQari = ref.read(selectedQariProvider);
    final urlEither = ref.read(
      voiceAyahByAyahProvider(AyahVoiceParameter(surah, ayah, selectedQari)),
    );
    urlEither.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("فشل الحصول على رابط الآية")),
          );
        }
      },
      (url) async {
        try {
          await player.setAudioSource(
            AudioSource.uri(
              Uri.parse(url),
              tag: MediaItem(
                id: 'ayah_${surah}_$ayah',
                title: 'سورة ${SurahNames.getFormattedName(surah)}',
                artist: 'الآية $ayah',
                // artUri: Uri.parse(
                //   'asset:///assets/icons/moon.png',
                // ), // TODO: change app icon
              ),
            ),
          );
          await player.play();
        } on PlayerInterruptedException {
          AppLogger.logger.i("تم تخطي الآيات من خلال المستخدم");
        } catch (e) {
          AppLogger.logger.e("رسالة الخطأ: $e");
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تعذر التشغيل. لا يوجد اتصال.")),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(audioPlayerProvider);
    final currentAyah = ref.watch(currentPlayingAyahProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // مقبض الإغلاق (Handle)
          Container(
            margin: EdgeInsets.only(top: 15.h, bottom: 20.h),
            height: 5.h,
            width: 50.w,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          // أيقونة إغلاق
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down_rounded, size: 35.sp),
                color: context.color.onSurface,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // غلاف الألبوم (أو صورة القارئ/المصحف)
          Container(
            height: 260.w, // صورة مربعة
            width: 260.w,
            decoration: BoxDecoration(
              // TODO: change the cover for audio player
              color: context.color.primary.withValues(alpha: .05),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Icon(
              Icons.my_library_music_rounded,
              size: 100.sp,
              color: context.color.primary.withValues(alpha: .6),
            ),
          ),

          SizedBox(height: 40.h),

          // معلومات الآية
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                Text(
                  currentAyah != null
                      ? "سورة ${currentAyah.surahName}"
                      : "غير محدد",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: context.color.onSurface,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  currentAyah != null
                      ? "الآية ${currentAyah.ayahNumber} - بصوت ${ref.watch(selectedQariProvider).name}"
                      : "-",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 16.sp,
                    color: context.color.primary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h),

          // شريط التقدم (Progress Bar)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: StreamBuilder<PositionData>(
              stream: ref.watch(audioPositionStreamProvider),
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: player.seek,
                  progressBarColor: context.color.primary,
                  baseBarColor: context.color.primary.withValues(alpha: .15),
                  bufferedBarColor: context.color.primary.withValues(alpha: .3),
                  thumbColor: context.color.primary,
                  barHeight: 6.h,
                  thumbRadius: 8.r,
                  timeLabelTextStyle: TextStyle(
                    color: context.color.onSurface.withValues(alpha: .7),
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20.h),

          // أزرار التحكم الإضافية (Loop, Speed) وأزرار التشغيل
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // زر التكرار
                IconButton(
                  icon: Icon(
                    _loopMode == LoopMode.all
                        ? Icons.repeat_rounded
                        : _loopMode == LoopMode.one
                        ? Icons.repeat_one_rounded
                        : Icons.repeat_rounded,
                    color: _loopMode == LoopMode.off
                        ? context.color.onSurface.withValues(alpha: .4)
                        : context.color.primary,
                  ),
                  tooltip: 'تكرار',
                  onPressed: () {
                    setState(() {
                      if (_loopMode == LoopMode.off) {
                        _loopMode = LoopMode.all;
                      } else if (_loopMode == LoopMode.all) {
                        _loopMode = LoopMode.one;
                      } else {
                        _loopMode = LoopMode.off;
                      }
                      player.setLoopMode(_loopMode);
                    });
                  },
                ),

                // الآية السابقة
                IconButton(
                  icon: Icon(
                    Icons.skip_next_rounded,
                    size: 35.sp,
                  ), // معكوسة للعربية (اليمين سابق)
                  color: context.color.onSurface,
                  onPressed: _playPreviousAyah,
                ),

                // زر التشغيل المركزي
                StreamBuilder<PlayerState>(
                  stream: player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;

                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return Container(
                        width: 70.sp,
                        height: 70.sp,
                        decoration: BoxDecoration(
                          color: context.color.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: context.color.onPrimary,
                          ),
                        ),
                      );
                    } else if (playing != true) {
                      return InkWell(
                        onTap: player.play,
                        borderRadius: BorderRadius.circular(40.r),
                        child: Container(
                          width: 70.sp,
                          height: 70.sp,
                          decoration: BoxDecoration(
                            color: context.color.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: context.color.onPrimary,
                            size: 40.sp,
                          ),
                        ),
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return InkWell(
                        onTap: player.pause,
                        borderRadius: BorderRadius.circular(40.r),
                        child: Container(
                          width: 70.sp,
                          height: 70.sp,
                          decoration: BoxDecoration(
                            color: context.color.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.pause_rounded,
                            color: context.color.onPrimary,
                            size: 40.sp,
                          ),
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () => player.seek(Duration.zero),
                        borderRadius: BorderRadius.circular(40.r),
                        child: Container(
                          width: 70.sp,
                          height: 70.sp,
                          decoration: BoxDecoration(
                            color: context.color.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.replay_rounded,
                            color: context.color.onPrimary,
                            size: 40.sp,
                          ),
                        ),
                      );
                    }
                  },
                ),

                // الآية التالية
                IconButton(
                  icon: Icon(
                    Icons.skip_previous_rounded,
                    size: 35.sp,
                  ), // معكوسة للعربية (اليسار تالي)
                  color: context.color.onSurface,
                  onPressed: _playNextAyah,
                ),

                // زر السرعة
                StreamBuilder<double>(
                  stream: player.speedStream,
                  builder: (context, snapshot) {
                    final speed = snapshot.data ?? 1.0;
                    return PopupMenuButton<double>(
                      initialValue: speed,
                      tooltip: 'السرعة',
                      icon: Text(
                        "${speed}x",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Cairo",
                          color: context.color.primary,
                        ),
                      ),
                      onSelected: (newSpeed) {
                        player.setSpeed(newSpeed);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                        const PopupMenuItem(value: 0.75, child: Text('0.75x')),
                        const PopupMenuItem(
                          value: 1.0,
                          child: Text('1.0x (طبيعي)'),
                        ),
                        const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                        const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                        const PopupMenuItem(value: 2.0, child: Text('2.0x')),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
