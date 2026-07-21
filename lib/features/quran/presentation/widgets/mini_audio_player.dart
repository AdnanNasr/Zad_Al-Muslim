import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/full_audio_player_page.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/player_state_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/quran_settings_provider.dart';

class MiniAudioPlayer extends ConsumerWidget {
  const MiniAudioPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAyah = ref.watch(currentPlayingAyahProvider);
    final autoScrollWithAudio = ref
        .watch(quranSettingsProvider)
        .autoScrollWithAudio;
    final audioPlayer = ref.watch(audioPlayerProvider);

    if (currentAyah == null) {
      return const SizedBox.shrink();
    }

    final String title = "سورة ${currentAyah.surahName}";

    final String subtitle =
        "الآية ${currentAyah.ayahNumber} - ${ref.watch(selectedQariProvider).name}";

    return GestureDetector(
      onTap: () {
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
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: context.color.primary.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Image.asset(
                        "assets/icons/moon.png",
                        color: context.color.primary.withValues(alpha: .4),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: context.color.onSurface,
                            ),
                          ),
                          Text(
                            subtitle,
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

                    IconButton(
                      tooltip: autoScrollWithAudio
                          ? "الغاء التمرير التلقائي"
                          : "تفعيل التمرير التلقائي",
                      onPressed: () {
                        final notifier = ref.read(
                          quranSettingsProvider.notifier,
                        );
                        notifier.toggleAutoScrollWithAudio();

                        BotToast.cleanAll();
                        BotToast.showCustomNotification(
                          duration: const Duration(seconds: 4),
                          align: Alignment.topCenter,
                          toastBuilder: (cancelFunc) {
                            return Card(
                              margin: EdgeInsets.all(16.w),

                              color: autoScrollWithAudio
                                  ? const Color(0xFF424242)
                                  : const Color(0xFF1B8A5A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      autoScrollWithAudio
                                          ? Icons.info_outline_rounded
                                          : Icons.check_circle_outline_rounded,
                                      color: Colors.white,
                                      size: 22.r,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        autoScrollWithAudio
                                            ? "تم إلغاء تفعيل التمرير التلقائي للآيات"
                                            : "تم تفعيل التمرير التلقائي للآيات",
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },

                      icon: Icon(
                        Icons.auto_awesome_motion_rounded,
                        size: 24.sp,
                        color: autoScrollWithAudio
                            ? context.color.primary
                            : null,
                      ),
                    ),

                    StreamBuilder<PlayerState>(
                      stream: audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;

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

                        if (playing != true) {
                          return IconButton(
                            tooltip: "تشغيل",
                            icon: Icon(Icons.play_arrow_rounded, size: 28.sp),
                            color: context.color.primary,
                            onPressed: audioPlayer.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return IconButton(
                            tooltip: "إيقاف",
                            icon: Icon(Icons.pause_rounded, size: 28.sp),
                            color: context.color.primary,
                            onPressed: audioPlayer.pause,
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.replay_rounded, size: 24.sp),
                            color: context.color.primary,
                            onPressed: () => audioPlayer.seek(Duration.zero),
                          );
                        }
                      },
                    ),

                    IconButton(
                      tooltip: "إغلاق",
                      icon: Icon(Icons.close_rounded, size: 24.sp),
                      color: context.color.onSurface.withValues(alpha: .5),
                      // padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        await audioPlayer.stop();
                        ref.read(currentPlayingAyahProvider.notifier).state =
                            null;
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
