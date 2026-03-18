import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/screen_util_sizes.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/themes/theme_notifier.dart';
import 'package:noor_quran/features/quran/presentation/widgets/index_surah_menu.dart';
import 'package:noor_quran/features/quran/presentation/widgets/qurah_page_bottom_navigation_bar.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_page_app_bar.dart';
import 'package:qcf_quran/qcf_quran.dart' hide ScreenType;

class QuranPages extends ConsumerStatefulWidget {
  final int? pageNumber;
  const QuranPages({super.key, this.pageNumber});

  @override
  ConsumerState<QuranPages> createState() => _QuranPagesState();
}

class _QuranPagesState extends ConsumerState<QuranPages> {
  bool _showAppAndBottomBar = false;

  void _toggleShowAppBar() {
    _showAppAndBottomBar = !_showAppAndBottomBar;
    setState(() {});
  }

  void _hideAppBar() {
    _showAppAndBottomBar = false;
    setState(() {});
  }

  bool _highlightAyah = false;

  final double menuWidth = 250;
  bool isMenuOpen = false;

  void _toggleMenu() {
    isMenuOpen = !isMenuOpen;
    setState(() {});
  }

  void _closeMenu() {
    if (isMenuOpen) {
      isMenuOpen = false;
      setState(() {});
    }
  }

  void _toggleHighlightAyah(int surahNumber, int verseNumber) {
    _highlightAyah = !_highlightAyah;

    if (!surahNumber.isNaN && !verseNumber.isNaN) {
      _highlightAyah = true;
    } else {
      _highlightAyah = false;
    }
  }

  void _removeHighlightAyah() => _highlightAyah = false;

  int _surahNumber = 0;
  int _verseNumber = 0;
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.read(themeProvider);
    final themeColor = ref.read(userThemeProvider);
    return Scaffold(
      body: Stack(
        children: [
          // القائمة الجانبية تكون ثابتة في جهة اليمين في الخلف
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: context.mediaQueryWidth / 1.35,
              color: context.color.primaryFixedDim.withValues(
                alpha: .08,
              ), // لون خلفية القائمة
              child: IndexSurahMenu(),
            ),
          ),

          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            transform: Matrix4.translationValues(
              isMenuOpen ? -context.mediaQueryWidth / 1.35 : 0,
              0,
              0,
            ),
            child: _quranPages(context, themeMode, themeColor),
          ),
        ],
      ),
    );
  }

  Scaffold _quranPages(
    BuildContext context,
    ThemeMode themeMode,
    FlexScheme themeColor,
  ) {
    return Scaffold(
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          if (isMenuOpen) {
            _closeMenu();
            return;
          }

          if (_highlightAyah) {
            _highlightAyah = false;
            setState(() {});
          } else {
            _toggleShowAppBar();
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              PageviewQuran(
                theme: themeMode == ThemeMode.light
                    ? QcfThemeData(
                        verseNumberHeight: 2.h,
                        verseHeight: 2.h,
                        basmalaColor: context.color.primary,
                        customHeaderBuilder: (surahNumber) {
                          return customQuranPageHeader(
                            context,
                            surahNumber,
                            themeColor,
                            themeMode,
                          );
                        },
                      )
                    : QcfThemeData(
                        verseTextColor: Color(0xFFE0E0E0),
                        verseNumberColor: Colors.grey, // amber
                        basmalaColor: context.color.primary,
                        headerTextColor: Colors.white,
                        headerBackgroundColor: Colors.white,
                        pageBackgroundColor:
                            context.color.scrim, // Color(0xFF1E1E1E)
                        verseNumberHeight: 2.h,
                        verseHeight: 2.h,
                        customHeaderBuilder: (surahNumber) {
                          return customQuranPageHeader(
                            context,
                            surahNumber,
                            themeColor,
                            themeMode,
                          );
                        },
                      ),
                sp: context.large
                    ? context.mediaQueryWidth * 0.00255
                    : context.small
                    ? context.mediaQueryWidth * 0.002425
                    : 1.sp,
                // h: context.large ? 1.29.h : 0,
                initialPageNumber: widget.pageNumber ?? 0,
                verseBackgroundColor: (surahNumber, verseNumber) {
                  if (surahNumber == _surahNumber &&
                      verseNumber == _verseNumber &&
                      _highlightAyah) {
                    return context.color.primary.withValues(alpha: 0.25);
                  }
                  return null;
                },
                onLongPress: (surahNumber, verseNumber) async {
                  _surahNumber = surahNumber;
                  _verseNumber = verseNumber;
                  setState(() {});

                  _toggleHighlightAyah(_surahNumber, _verseNumber);
                },
                onPageChanged: (_) {
                  _hideAppBar();
                  _removeHighlightAyah();
                  _closeMenu();
                },
              ),

              if (_showAppAndBottomBar)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  // TODO: change params
                  child: QuranPageAppBar(surahName: "الفاتحة", juzzNumber: 1),
                ),

              if (_showAppAndBottomBar)
                Positioned(
                  bottom: kBottomNavigationBarHeight / 2,
                  left: 0,
                  right: 0,
                  child: QurahPageBottomNavigationBar(
                    onIndexPressed: _toggleMenu,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell customQuranPageHeader(
    BuildContext context,
    int surahNumber,
    FlexScheme themeColor,
    ThemeMode themeMode,
  ) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final effectiveTheme = QcfThemeData();
    return InkWell(
      borderRadius: BorderRadius.circular(effectiveTheme.headerBorderRadius),
      child: Container(
        decoration: BoxDecoration(color: effectiveTheme.headerBackgroundColor),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: themeColor == FlexScheme.money
                  ? const AssetImage("assets/images/green_bg_banner.jpg")
                  : themeColor == FlexScheme.brandBlue
                  ? const AssetImage("assets/images/blue_bg_banner.jpg")
                  : themeColor == FlexScheme.blueWhale
                  ? const AssetImage("assets/images/blue_bg_banner.jpg")
                  : themeColor == FlexScheme.gold
                  ? const AssetImage("assets/images/gold_bg_banner.jpg")
                  : themeColor == FlexScheme.vesuviusBurn
                  ? const AssetImage("assets/images/orange_bg_banner.jpg")
                  : themeColor == FlexScheme.sakura
                  ? const AssetImage("assets/images/rose_bg_banner.jpg")
                  : themeColor == FlexScheme.barossa
                  ? const AssetImage("assets/images/rose_bg_banner.jpg")
                  : themeColor == FlexScheme.shark
                  ? const AssetImage("assets/images/grey_bg_banner.jpg")
                  : const AssetImage(
                      "assets/mainframe.png",
                      package: 'qcf_quran',
                    ),
              width: isPortrait
                  // ignore: unrelated_type_equality_checks
                  ? getScreenType(context) == ScreenType(context).large
                        ? effectiveTheme.headerWidthLarge
                        : context.mediaQueryWidth / 1
                  : MediaQuery.of(context).size.width * 0.8,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "surah${surahNumber.toString().padLeft(3, '0')}",
                style: TextStyle(
                  fontFamily: SurahFontHelper.fontFamily,
                  package: 'qcf_quran',
                  fontSize: isPortrait
                      // ignore: unrelated_type_equality_checks
                      ? getScreenType(context) == ScreenType(context).large
                            ? effectiveTheme.headerFontSizeLarge
                            : effectiveTheme.headerFontSizeSmall
                      : MediaQuery.of(context).size.width * 0.05,
                  color: themeMode == ThemeMode.light
                      ? context.color.onSurface
                      : context.color.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
