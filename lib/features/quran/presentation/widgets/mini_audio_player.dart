import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/presentation/pages/full_audio_player_page.dart';
import 'package:noor_quran/features/quran/presentation/providers/audio_player_provider.dart';

class MiniAudioPlayer extends ConsumerWidget {
  const MiniAudioPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAyah = ref.watch(currentPlayingAyahProvider);
    final audioPlayer = ref.watch(audioPlayerProvider);

    // إذا لم يكن هنالك تلاوة تعمل أو محددة، أخفِ المشغل
    if (currentAyah == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        // فتح المشغل الكامل كـ BottomSheet بحجم كامل الشاشة
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withValues(alpha: .7),
          builder: (context) => const FullAudioPlayerPage(),
        );
      },
      child: Container(
        height: 65.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            // شريط التقدم الخطي البسيط في الأعلى
            StreamBuilder<PositionData>(
              stream: ref.watch(audioPositionStreamProvider),
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final duration = positionData?.duration ?? Duration.zero;
                final position = positionData?.position ?? Duration.zero;

                double progress = 0.0;
                if (duration.inMilliseconds > 0) {
                  progress = position.inMilliseconds / duration.inMilliseconds;
                }

                return ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: context.color.primary.withValues(
                      alpha: .2,
                    ),
                    valueColor: AlwaysStoppedAnimation(context.color.primary),
                    minHeight: 2.h,
                  ),
                );
              },
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    // صورة تعبيرية (Iconography)
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: context.color.primary.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.audiotrack_rounded,
                        color: context.color.primary,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // بيانات الآية (Surah & Ayah)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "سورة ${currentAyah.surahName}",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: context.color.onSurface,
                            ),
                          ),
                          Text(
                            "الآية ${currentAyah.ayahNumber} - مشاري العفاسي",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 11.sp,
                              color: context.color.onSurface.withValues(
                                alpha: .6,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // زر التشغيل والإيقاف المصغر
                    StreamBuilder<PlayerState>(
                      stream: audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;

                        // إظهار تحميل إذا كان قيد المعالجة
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return Container(
                            margin: EdgeInsets.all(8.h),
                            width: 24.sp,
                            height: 24.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.color.primary,
                            ),
                          );
                        }

                        // إظهار زر الإيقاف إذا كان يعمل
                        if (playing != true) {
                          return IconButton(
                            icon: Icon(Icons.play_arrow_rounded, size: 28.sp),
                            color: context.color.primary,
                            onPressed: audioPlayer.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return IconButton(
                            icon: Icon(Icons.pause_rounded, size: 28.sp),
                            color: context.color.primary,
                            onPressed: audioPlayer.pause,
                          );
                        } else {
                          // إظهار زر التخطي أو إعادة التشغيل عند الانتهاء
                          return IconButton(
                            icon: Icon(Icons.replay_rounded, size: 24.sp),
                            color: context.color.primary,
                            onPressed: () => audioPlayer.seek(Duration.zero),
                          );
                        }
                      },
                    ),

                    // زر الإغلاق
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 24.sp),
                      color: context.color.onSurface.withValues(alpha: .5),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        await audioPlayer.stop();
                        ref.read(currentPlayingAyahProvider.notifier).state =
                            null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
