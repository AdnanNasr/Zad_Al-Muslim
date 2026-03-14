import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/quran/presentation/widgets/qurah_page_bottom_navigation_bar.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_page_app_bar.dart';
import 'package:qcf_quran/qcf_quran.dart';

class QuranPages extends StatefulWidget {
  final int? surahNumber;
  const QuranPages({super.key, this.surahNumber});

  @override
  State<QuranPages> createState() => _QuranPagesState();
}

class _QuranPagesState extends State<QuranPages> {
  bool _showAppAndBottomBar = false;

  void _toggleShowAppBar() {
    _showAppAndBottomBar = !_showAppAndBottomBar;
    setState(() {});
  }

  void _hideAppBar() {
    _showAppAndBottomBar = false;
    setState(() {});
  }

  int _surahNumber = 0;
  int _verseNumber = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GestureDetector(
        onTap: () => _toggleShowAppBar(),
        child: SafeArea(
          child: Stack(
            children: [
              PageviewQuran(
                theme: QcfThemeData(verseNumberHeight: 2.h, verseHeight: 2.h),
                sp: 1.sp,
                h: 1.27.h,
                initialPageNumber: widget.surahNumber ?? 0,
                verseBackgroundColor: (surahNumber, verseNumber) {
                  if (surahNumber == _surahNumber &&
                      verseNumber == _verseNumber) {
                    return context.color.primary.withValues(alpha: 0.25);
                  }
                  return null;
                },
                onLongPress: (surahNumber, verseNumber) async {
                  _surahNumber = surahNumber;
                  _verseNumber = verseNumber;
                  setState(() {});

                  await Future.delayed(Duration(seconds: 10));

                  print("رقم السورة: $surahNumber");
                },
                onPageChanged: (_) => _hideAppBar(),
              ),

              if (_showAppAndBottomBar)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  // TODO: change params
                  child: QuranPageAppBar(surahName: "الفاتحة", juzzNumber: 1,),
                ),

              if (_showAppAndBottomBar)
                Positioned(
                  bottom: kBottomNavigationBarHeight / 2,
                  left: 0,
                  right: 0,
                  child: QurahPageBottomNavigationBar(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
