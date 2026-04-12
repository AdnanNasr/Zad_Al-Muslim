import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:noor_quran/features/quran_moratal/presentation/providers/moratal_player_provider.dart';
import 'package:noor_quran/features/quran_moratal/presentation/providers/ayah_timing_provider.dart';
import 'package:qcf_quran/qcf_quran.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MINI PLAYER (shown at the bottom of the screen while audio is playing)
// ─────────────────────────────────────────────────────────────────────────────
class MoratalMiniPlayer extends ConsumerWidget {
  const MoratalMiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMoratalSurah = ref.watch(currentMoratalSurahProvider);
    final audioPlayer = ref.watch(audioPlayerProvider);

    if (currentMoratalSurah == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withValues(alpha: .7),
          builder: (_) => _MoratalFullPlayerSheet(surah: currentMoratalSurah),
        );
      },
      child: Container(
        height: 65.h,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            // thin progress bar at the top
            StreamBuilder<PositionData>(
              stream: ref.watch(audioPositionStreamProvider),
              builder: (context, snapshot) {
                final data = snapshot.data;
                final dur = data?.duration ?? Duration.zero;
                final pos = data?.position ?? Duration.zero;
                final progress = dur.inMilliseconds > 0
                    ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                    : 0.0;

                return ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: LinearProgressIndicator(
                    value: progress,
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
                    // icon
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

                    // surah & qari names
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'سورة ${currentMoratalSurah.surahName}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: context.color.onSurface,
                            ),
                          ),
                          Text(
                            currentMoratalSurah.qariName,
                            style: TextStyle(
                              fontFamily: 'Cairo',
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

                    // play / pause
                    StreamBuilder<PlayerState>(
                      stream: audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        final processing = state?.processingState;
                        final playing = state?.playing;

                        if (processing == ProcessingState.loading ||
                            processing == ProcessingState.buffering) {
                          return Padding(
                            padding: EdgeInsets.all(8.h),
                            child: SizedBox(
                              width: 24.sp,
                              height: 24.sp,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.color.primary,
                              ),
                            ),
                          );
                        }
                        if (playing != true) {
                          return IconButton(
                            icon: Icon(Icons.play_arrow_rounded, size: 28.sp),
                            color: context.color.primary,
                            onPressed: audioPlayer.play,
                          );
                        } else if (processing != ProcessingState.completed) {
                          return IconButton(
                            icon: Icon(Icons.pause_rounded, size: 28.sp),
                            color: context.color.primary,
                            onPressed: audioPlayer.pause,
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.replay_rounded, size: 24.sp),
                            color: context.color.primary,
                            onPressed: () {
                              audioPlayer.seek(Duration.zero);
                              audioPlayer.play();
                            },
                          );
                        }
                      },
                    ),

                    // close
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 24.sp),
                      color: context.color.onSurface.withValues(alpha: .5),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        await audioPlayer.stop();
                        ref.read(currentMoratalSurahProvider.notifier).state =
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

// ─────────────────────────────────────────────────────────────────────────────
// FULL PLAYER BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _MoratalFullPlayerSheet extends ConsumerStatefulWidget {
  final CurrentMoratalSurah surah;
  const _MoratalFullPlayerSheet({required this.surah});

  @override
  ConsumerState<_MoratalFullPlayerSheet> createState() =>
      _MoratalFullPlayerSheetState();
}

class _MoratalFullPlayerSheetState
    extends ConsumerState<_MoratalFullPlayerSheet> {
  LoopMode _loopMode = LoopMode.off;
  double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    final player = ref.read(audioPlayerProvider);
    _loopMode = player.loopMode;
    _speed = player.speed;
  }

  // ── Surah navigation ──────────────────────────────────────────────────────

  void _playNextSurah() {
    final current = ref.read(currentMoratalSurahProvider);
    if (current == null || current.surahNumber >= 114) return;
    final newSurah = current.copyWith(
      surahNumber: current.surahNumber + 1,
      surahName: getSurahNameArabic(current.surahNumber + 1),
    );
    ref.read(playMoratalSurahActionProvider)(newSurah);
  }

  void _playPrevSurah() {
    final current = ref.read(currentMoratalSurahProvider);
    if (current == null || current.surahNumber <= 1) return;
    final newSurah = current.copyWith(
      surahNumber: current.surahNumber - 1,
      surahName: getSurahNameArabic(current.surahNumber - 1),
    );
    ref.read(playMoratalSurahActionProvider)(newSurah);
  }

  // String _arabicName(int number) {
  //   try {
  //     return getSurahNameArabic(number);
  //   } catch (_) {
  //     return 'السورة $number';
  //   }
  // }

  // ── Loop ──────────────────────────────────────────────────────────────────

  void _cycleLoop() {
    final player = ref.read(audioPlayerProvider);
    setState(() {
      _loopMode = _loopMode == LoopMode.off
          ? LoopMode.one
          : _loopMode == LoopMode.one
          ? LoopMode.all
          : LoopMode.off;
      player.setLoopMode(_loopMode);
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(audioPlayerProvider);
    final currentSurah = ref.watch(currentMoratalSurahProvider) ?? widget.surah;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          // drag handle
          _handle(context),

          // collapse arrow
          _collapseButton(context),

          SizedBox(height: 8.h),

          // ── Ayah display (replaces album art) ──────────────────────────
          Expanded(child: _ayahDisplay(context, currentSurah, player)),

          SizedBox(height: 24.h),

          // surah + qari text
          _titles(context, currentSurah),

          SizedBox(height: 24.h),

          // _ayahDisplay(context, currentSurah, player),

          // progress bar
          _progressBar(context, player),

          SizedBox(height: 16.h),

          // secondary controls (loop + speed)
          _secondaryControls(context, player),

          SizedBox(height: 8.h),

          // main controls (prev | play/pause | next)
          _mainControls(context, player, currentSurah),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // ─── Sub-builder methods ──────────────────────────────────────────────────

  Widget _handle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
      height: 5.h,
      width: 50.w,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget _collapseButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: IconButton(
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 35.sp),
          color: context.color.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  // ── Ayah Display ───────────────────────────────────────────────────────────

  Widget _ayahDisplay(
    BuildContext context,
    CurrentMoratalSurah currentSurah,
    AudioPlayer player,
  ) {
    final timingParams = AyahTimingParams(
      surahNumber: currentSurah.surahNumber,
      qariId: currentSurah.qariId,
    );
    final timingAsync = ref.watch(ayahTimingProvider(timingParams));

    return timingAsync.when(
      loading: () => _ayahPlaceholder(context, isLoading: true),
      error: (_, __) => _ayahPlaceholder(context, isLoading: false),
      data: (timings) {
        if (timings.isEmpty) {
          return _ayahPlaceholder(context, isLoading: false);
        }

        // Static background layer that NEVER rebuilds on position changes
        return Container(
          width: double.infinity,
          // margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/night_clouds.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
          child: StreamBuilder<PositionData>(
            stream: ref.watch(audioPositionStreamProvider),
            builder: (context, snapshot) {
              final position = snapshot.data?.position ?? Duration.zero;
              final ayahNumber =
                  currentAyahFromTimings(timings, position) ??
                  timings.first.ayah;

              // Only the CONTENT of the verse animates, not the background
              return _ayahContent(
                context,
                currentSurah.surahNumber,
                ayahNumber,
                currentSurah,
              );
            },
          ),
        );
      },
    );
  }

  /// Fallback when no timing data is available
  Widget _ayahPlaceholder(BuildContext context, {required bool isLoading}) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage("assets/images/night_clouds.jpg"),
        //   fit: BoxFit.cover,
        //   colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        // ),
      ),
      child: Center(
        child: isLoading
            ? Skeletonizer(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      // Simulated Verse Text Box
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          // color: Colors.white.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 280.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .2),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              width: 220.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .2),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              width: 140.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .2),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(height: 12.h),
                      // Simulated Ayah Number Badge
                      Container(
                        width: 90.w,
                        height: 28.h,
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(24.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: context.color.onSurface.withValues(
                                alpha: 0.2,
                              ), // حدود زجاجية خفيفة
                              width: 1.5,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                context.color.onSurface.withValues(
                                  alpha: 0.1,
                                ), // لون شفاف من الأعلى
                                context.color.onSurface.withValues(
                                  alpha: 0.05,
                                ), // لون أكثر شفافية من الأسفل
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.color.onSurface.withValues(
                                  alpha: .07,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Icon(Icons.play_arrow, size: 50.sp),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _ayahContent(
    BuildContext context,
    int surahNumber,
    int ayahNumber,
    CurrentMoratalSurah currentSurah,
  ) {
    // Only the Text and Badge participate in the AnimatedSwitcher
    final ayahText = getVerse(
      surahNumber,
      ayahNumber == 0
          ? 1
          : int.parse(currentSurah.qariId) ==
                118 // المعرف الخاص بالحصري، لأن سورة الفاتحة في ملف التوقيت تنقص آية
          ? surahNumber == 1
                ? ayahNumber + 1
                : ayahNumber
          : ayahNumber,
      verseEndSymbol: false,
    );

    final ayahWords = ayahText.split(" ");

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  key: ValueKey('$surahNumber:$ayahNumber'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    // Verse text layer
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Text(
                            ayahText,
                            textAlign: ayahWords.length >= 25
                                ? TextAlign.justify
                                : TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Quran',
                              fontSize: 24.sp,
                              height: 1.7,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Spacer(),
                    SizedBox(height: 12.h),
                    // Ayah number badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 4.h,
                      ),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'الآية $ayahNumber',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _titles(BuildContext context, CurrentMoratalSurah currentSurah) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          Text(
            'سورة ${currentSurah.surahName}',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: context.color.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            currentSurah.qariName,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15.sp,
              color: context.color.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar(BuildContext context, AudioPlayer player) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: StreamBuilder<PositionData>(
        stream: ref.watch(audioPositionStreamProvider),
        builder: (context, snapshot) {
          final data = snapshot.data;
          return ProgressBar(
            progress: data?.position ?? Duration.zero,
            buffered: data?.bufferedPosition ?? Duration.zero,
            total: data?.duration ?? Duration.zero,
            onSeek: player.seek,
            progressBarColor: context.color.primary,
            baseBarColor: context.color.primary.withValues(alpha: .15),
            bufferedBarColor: context.color.primary.withValues(alpha: .3),
            thumbColor: context.color.primary,
            barHeight: 6.h,
            thumbRadius: 8.r,
            timeLabelTextStyle: TextStyle(
              color: context.color.onSurface.withValues(alpha: .7),
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          );
        },
      ),
    );
  }

  Widget _secondaryControls(BuildContext context, AudioPlayer player) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Loop button ──
          Tooltip(
            message: _loopMode == LoopMode.off
                ? 'تفعيل التكرار'
                : _loopMode == LoopMode.one
                ? 'تكرار الكل'
                : 'إيقاف التكرار',
            child: IconButton(
              icon: Icon(
                _loopMode == LoopMode.one
                    ? Icons.repeat_one_rounded
                    : Icons.repeat_rounded,
                size: 26.sp,
                color: _loopMode == LoopMode.off
                    ? context.color.onSurface.withValues(alpha: .35)
                    : context.color.primary,
              ),
              onPressed: _cycleLoop,
            ),
          ),

          // ── Speed picker ──
          StreamBuilder<double>(
            stream: player.speedStream,
            builder: (context, snapshot) {
              final speed = snapshot.data ?? _speed;
              final label = speed == speed.truncateToDouble()
                  ? '${speed.toInt()}x'
                  : '${speed.toStringAsFixed(2)}x';

              return PopupMenuButton<double>(
                tooltip: 'سرعة التشغيل',
                initialValue: speed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                icon: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: context.color.primary,
                    ),
                  ),
                ),
                onSelected: (v) {
                  setState(() => _speed = v);
                  player.setSpeed(v);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 0.5, child: Text('0.5x')),
                  PopupMenuItem(value: 0.75, child: Text('0.75x')),
                  PopupMenuItem(value: 1.0, child: Text('1.0x (طبيعي)')),
                  PopupMenuItem(value: 1.25, child: Text('1.25x')),
                  PopupMenuItem(value: 1.5, child: Text('1.5x')),
                  PopupMenuItem(value: 2.0, child: Text('2.0x')),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _mainControls(
    BuildContext context,
    AudioPlayer player,
    CurrentMoratalSurah currentSurah,
  ) {
    final canPrev = currentSurah.surahNumber > 1;
    final canNext = currentSurah.surahNumber < 114;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ── Previous surah ──
          IconButton(
            tooltip: 'السورة السابقة',
            iconSize: 38.sp,
            icon: Icon(
              Icons.skip_next_rounded,
              color: canPrev
                  ? context.color.onSurface
                  : context.color.onSurface.withValues(alpha: .25),
            ),
            onPressed: canPrev ? _playPrevSurah : null,
          ),

          // ── Rewind 10s ──
          IconButton(
            tooltip: 'تأخير 10 ثوانٍ',
            iconSize: 30.sp,
            icon: Icon(Icons.replay_10_rounded, color: context.color.onSurface),
            onPressed: () {
              final newPos = player.position - const Duration(seconds: 10);
              player.seek(newPos < Duration.zero ? Duration.zero : newPos);
            },
          ),

          // ── Play / Pause / Replay ──
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              final processing = state?.processingState;
              final playing = state?.playing;

              if (processing == ProcessingState.loading ||
                  processing == ProcessingState.buffering) {
                return _loadingCircle(context);
              } else if (playing != true) {
                return _playCircle(
                  context,
                  Icons.play_arrow_rounded,
                  player.play,
                );
              } else if (processing != ProcessingState.completed) {
                return _playCircle(context, Icons.pause_rounded, player.pause);
              } else {
                return _playCircle(
                  context,
                  Icons.replay_rounded,
                  () => player.seek(Duration.zero),
                );
              }
            },
          ),

          // ── Fast Forward 10s ──
          IconButton(
            tooltip: 'تقديم 10 ثوانٍ',
            iconSize: 30.sp,
            icon: Icon(
              Icons.forward_10_rounded,
              color: context.color.onSurface,
            ),
            onPressed: () {
              final duration = player.duration ?? Duration.zero;
              final newPos = player.position + const Duration(seconds: 10);
              player.seek(newPos > duration ? duration : newPos);
            },
          ),

          // ── Next surah ──
          IconButton(
            tooltip: 'السورة التالية',
            iconSize: 38.sp,
            icon: Icon(
              Icons.skip_previous_rounded,
              color: canNext
                  ? context.color.onSurface
                  : context.color.onSurface.withValues(alpha: .25),
            ),
            onPressed: canNext ? _playNextSurah : null,
          ),
        ],
      ),
    );
  }

  Widget _loadingCircle(BuildContext context) {
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
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _playCircle(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.sp,
        height: 70.sp,
        decoration: BoxDecoration(
          color: context.color.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: context.color.onPrimary, size: 40.sp),
      ),
    );
  }
}
