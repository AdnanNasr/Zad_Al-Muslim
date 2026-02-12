import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
import 'package:noor_quran/utils/reverse_arabic_numbers.dart';
import 'animated_quran_overlay.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/views/widgets/quran_selecet_menu.dart';

class QuranOverlayManager {
  OverlayEntry? _overlayEntry;
  static bool isVisible = false;

  final GlobalKey<AnimatedQuranOverlayState> _overlayKey = GlobalKey();
  final PageController pageController;
  final List<QuranPage> pages;

  final Function(String) updateCurrentSurah;
  final Function(bool) setIsVisible;

  String localSelectedSurah;

  QuranOverlayManager({
    required this.pageController,
    required this.pages,
    required this.updateCurrentSurah,
    required this.localSelectedSurah,
    required this.setIsVisible,
  });

  void toggleOverly(BuildContext context) {
    if (isVisible) {
      removeOverly();
    } else {
      _showOverly(context);
    }
  }

  void _finalRemoveOverly() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    isVisible = false;
    setIsVisible(false);
  }

  void removeOverly() {
    if (_overlayEntry != null && isVisible) {
      _overlayKey.currentState?.dismiss();
      isVisible = false;
    }
  }

  void _showOverly(BuildContext context) {
    if (isVisible) return;

    final overlay = Overlay.of(context);
    final theme = Theme.of(context);
    final screenWidth = context.witdthScreen;
    final screenHeight = context.heightScreen;

    if (pageController.hasClients) {
      final currentIndex = pageController.page?.round() ?? 0;
      if (pages.isNotEmpty && currentIndex < pages.length) {
        final currentAyahs = pages[currentIndex].ayahs;
        if (currentAyahs.isNotEmpty) {
          localSelectedSurah = currentAyahs.first.surahName;
        }
      }
    }

    isVisible = true;
    setIsVisible(true);

    final List<String> surahNames = [];
    final Map<String, int> surahToPageIndex = {};
    final Set<String> seen = {};

    for (var pIndex = 0; pIndex < pages.length; pIndex++) {
      for (final ay in pages[pIndex].ayahs) {
        final name = ay.surahName.isNotEmpty ? ay.surahName : '..';
        if (!seen.contains(name)) {
          seen.add(name);
          surahNames.add(name);
          surahToPageIndex[name] = pIndex;
        }
      }
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: screenHeight * 0.08,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          child: AnimatedQuranOverlay(
            key: _overlayKey,
            animationDuration: const Duration(milliseconds: 350),
            onDismissed: _finalRemoveOverly,
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: StatefulBuilder(
                  builder: (context, setOverlayState) {
                    final pageIdx = pageController.hasClients
                        ? pageController.page?.round() ?? 0
                        : 0;
                    final currentPageNumber = pages.isEmpty
                        ? 1
                        : pages[pageIdx].pageNumber;

                    return Container(
                      color: theme.colorScheme.surface.withValues(alpha: 0.95),
                      padding: EdgeInsets.all(20.dg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.controll_panel,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              IconButton(
                                onPressed: removeOverly,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildNavigationButton(
                                context,
                                theme,
                                icon: Icons.arrow_back,
                                label: AppLocalizations.of(context)!.previous,
                                onPressed: () {
                                  final idx = surahNames.indexOf(
                                    localSelectedSurah,
                                  );
                                  if (idx > 0) {
                                    final prev = surahNames[idx - 1];
                                    _navigateToSurah(
                                      prev,
                                      surahToPageIndex[prev]!,
                                      setOverlayState,
                                    );
                                  }
                                },
                              ),
                              Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.current_surah,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "سورة $localSelectedSurah",
                                    style: TextStyle(
                                      fontFamily: 'Amiri',
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              _buildNavigationButton(
                                context,
                                theme,
                                icon: Icons.arrow_forward,
                                label: AppLocalizations.of(context)!.next,
                                onPressed: () {
                                  final idx = surahNames.indexOf(
                                    localSelectedSurah,
                                  );
                                  if (idx >= 0 && idx < surahNames.length - 1) {
                                    final next = surahNames[idx + 1];
                                    _navigateToSurah(
                                      next,
                                      surahToPageIndex[next]!,
                                      setOverlayState,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    removeOverly();

                                    await showDialog(
                                      context: context,
                                      useRootNavigator: true,
                                      builder: (ctx) => QuranSelectMenu(
                                        pageController: pageController,
                                        onSurahSelected: (surahName) {
                                          localSelectedSurah = surahName;
                                          updateCurrentSurah(surahName);
                                        },
                                      ),
                                    );

                                    if (context.mounted) {
                                      _showOverly(context);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: theme.colorScheme.outlineVariant,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          localSelectedSurah,
                                          style: TextStyle(
                                            fontFamily: "Amiri",
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              SizedBox(
                                width: 100.w,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "$currentPageNumber",
                                    labelText: AppLocalizations.of(
                                      context,
                                    )!.page_number,
                                    labelStyle: TextStyle(fontSize: 14.sp),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    final pageNumber = int.tryParse(
                                      ReverseArabicNumbers().convert(value),
                                    );
                                    if (pageNumber != null) {
                                      final targetIndex = pages.indexWhere(
                                        (p) => p.pageNumber == pageNumber,
                                      );
                                      if (targetIndex != -1) {
                                        pageController.animateToPage(
                                          targetIndex,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          curve: Curves.easeOutCubic,
                                        );
                                      }
                                    }
                                    removeOverly();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
    overlay.insert(_overlayEntry!);
  }

  void _navigateToSurah(String name, int pageIdx, StateSetter setOverlayState) {
    setOverlayState(() {
      localSelectedSurah = name;
    });

    updateCurrentSurah(name);
    pageController.animateToPage(
      pageIdx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon, size: 20.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, fontFamily: "Cairo"),
        ),
      ],
    );
  }
}
