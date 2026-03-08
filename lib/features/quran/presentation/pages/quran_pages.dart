import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/features/quran/data/models/quran_models.dart';
import 'package:noor_quran/features/quran/presentation/pages/surah_template.dart';

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
            fontSize: context.mediaQueryWidth < 360
            ? 18
            : context.mediaQueryWidth <= 410
            ? 24
            : 25,
            height: context.mediaQueryWidth < 360
            ? 1.7.h
            : context.mediaQueryWidth <= 410
            ? 1.7.h
            : 1.7.h
          );
        },
      ),
    );
  }
}