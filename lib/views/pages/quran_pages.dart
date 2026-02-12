import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/views/template/surah_template.dart';

class QuranPages extends StatelessWidget {
  final PageController pageController;
  final void Function(int)? togglePages;
  final List<QuranPage> pages;
  const QuranPages({
    super.key,
    required this.pageController,
    this.togglePages,
    required this.pages,
  }) : _pageController = pageController,
       _togglePages = togglePages;

  final PageController _pageController;
  final void Function(int)? _togglePages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _togglePages,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          final ayahs = page.ayahs.toList();
          return SurahTemplate(
            ayahs: ayahs,
            pageNumber: page.pageNumber,
            fontFamily: "Quran",
            fontSize: 23.2.sp,
            height: 1.4.h,
          );
        },
      ),
    );
  }
}
