import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/screen_util_sizes.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/features/quran/presentation/widgets/index_surah_menu.dart';
import 'package:noor_quran/features/quran/presentation/widgets/qurah_page_bottom_navigation_bar.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_page_app_bar.dart';
import 'package:qcf_quran/qcf_quran.dart';

class QuranPages extends ConsumerStatefulWidget {
  final int? surahNumber;
  const QuranPages({super.key, this.surahNumber});

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
            child: _quranPages(context, themeMode),
          ),
        ],
      ),
    );
  }

  Scaffold _quranPages(BuildContext context, ThemeMode themeMode) {
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
                    ? QcfThemeData(verseNumberHeight: 2.h, verseHeight: 2.h)
                    : QcfThemeData(
                        verseTextColor: Color(0xFFE0E0E0),
                        verseNumberColor: Colors.grey, // amber
                        basmalaColor: Color(0xFFE0E0E0),
                        headerTextColor: Colors.black,
                        pageBackgroundColor:
                            context.color.scrim, // Color(0xFF1E1E1E)
                        verseNumberHeight: 2.h,
                        verseHeight: 2.h,
                      ),
                sp: context.isSmallMobile
                    ? context.mediaQueryWidth * 0.00255
                    : context.isMobile
                    ? context.mediaQueryWidth * 0.0022
                    : 1.sp,
                h: context.isSmallMobile ? 1.29.h : 0,
                initialPageNumber: widget.surahNumber ?? 0,
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
}
