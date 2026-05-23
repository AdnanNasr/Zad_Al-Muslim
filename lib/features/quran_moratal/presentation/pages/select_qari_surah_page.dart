import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/quran/domain/entities/surah_meta_entity.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/surahs_meta_provider.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/providers/moratal_player_provider.dart';
import 'package:zad_al_muslim/features/quran_moratal/presentation/widgets/moratal_mini_player.dart';

class SelectQariSurahPage extends ConsumerStatefulWidget {
  final Map<String, String> qariData;
  const SelectQariSurahPage({super.key, required this.qariData});

  @override
  ConsumerState<SelectQariSurahPage> createState() =>
      _SelectQariSurahPageState();
}

class _SelectQariSurahPageState extends ConsumerState<SelectQariSurahPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahsMeta = ref.watch(surahsMetaProvider);
    final ThemeMode themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: "سور القرآن - ${widget.qariData['name']}",
        center: true,
        themeMode: false,
      ),
      body: Stack(
        children: [
          surahsMeta.fold(
            (failure) => Center(
              child: Text(
                failure.message,
                style: const TextStyle(fontFamily: "Cairo", color: Colors.red),
              ),
            ),
            (surahs) => AnimationLimiter(
              child: Padding(
                padding: EdgeInsets.only(left: 4, top: 20.h),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  thickness: 5,
                  radius: const Radius.circular(24),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,

                      bottom: 100.h, // padding for mini player
                    ),
                    itemCount: surahs.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 700),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: _buildSurahItem(
                              context: context,
                              surah: surahs[index],
                              isDark: isDark,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: MoratalMiniPlayer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahItem({
    required BuildContext context,
    required SurahMetaEntity surah,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.color.primary.withValues(alpha: .2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () {
                final currentSurah = CurrentMoratalSurah(
                  surahNumber: surah.surahNumber,
                  surahName: surah.arabicName,
                  qariName: widget.qariData['name'] ?? "",
                  serverUrl: widget.qariData['server'] ?? "",
                  qariId: widget.qariData['id'] ?? "",
                );
                // Call the action provider
                ref.read(playMoratalSurahActionProvider)(currentSurah);
              },
              child: Padding(
                padding: EdgeInsets.all(12.dg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildNumberIndicator(
                      context: context,
                      number: surah.surahNumber,
                      isDark: isDark,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'surah${surah.surahNumber.toString().padLeft(3, '0')}',
                            style: TextStyle(
                              fontFamily: 'surahname',
                              package: 'qcf_quran',
                              fontSize: 38.sp,
                              color: context.color.onSurface.withValues(
                                alpha: .8,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                surah.englishName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Naskh",
                                  color: context.color.onSurface.withValues(
                                    alpha: .7,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  _buildInfoChip(
                                    Icons.menu_book_rounded,
                                    surah.verseCount >= 10
                                        ? "${surah.verseCount} آية"
                                        : "${surah.verseCount} آيات",
                                    context,
                                  ),
                                  SizedBox(width: 12.w),
                                  _buildInfoChip(
                                    Icons.grid_view_rounded,
                                    "الجزء ${surah.juzzNumber}",
                                    context,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 35.sp,
                      color: context.color.primary.withValues(alpha: .8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberIndicator({
    required BuildContext context,
    required int number,
    required bool isDark,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: 0.8,
          child: Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: isDark
                  ? context.color.primary.withValues(alpha: .8)
                  : context.color.primary.withValues(alpha: .25),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? context.color.onSurface : context.color.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13.sp, color: context.color.primary),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5.sp,
            color: context.color.onSurface,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
          ),
        ),
      ],
    );
  }
}
