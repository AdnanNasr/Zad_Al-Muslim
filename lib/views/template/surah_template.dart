import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/utils/arabic_numbers.dart';
import 'package:noor_quran/view_models/providers/theme_provider.dart';

class SurahTemplate extends ConsumerStatefulWidget {
  final List<Ayah> ayahs;
  final int pageNumber;
  final String fontFamily;
  final double fontSize;
  final double height;

  const SurahTemplate({
    super.key,
    required this.ayahs,
    required this.pageNumber,
    required this.fontFamily,
    required this.fontSize,
    required this.height,
  });

  @override
  ConsumerState<SurahTemplate> createState() => _SurahTemplateState();
}

class _SurahTemplateState extends ConsumerState<SurahTemplate>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  AnimationController? _animationController;

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildSurahHeader(
    Ayah ayah,
    BuildContext context,
    ThemeMode themeMode,
  ) {
    final themeColor = Theme.of(context).colorScheme;

    final surahName = ayah.surahName.isNotEmpty
        ? ayah.surahName
        : "سورة غير معروفة";

    // final revelationType = ayah.revelationType.isNotEmpty
    //     ? ayah.revelationType
    //     : "";

    // final ayahCount = ayah.numberOfAyahs > 0 ? ayah.numberOfAyahs : 0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset("assets/images/surah_banner.png"),
            Positioned(
              bottom: context.heightScreen * .009.sp,
              child: Text(
                surahName,
                style: TextStyle(
                  fontFamily: 'Quran',
                  fontSize: context.witdthScreen * 0.05.sp,
                  color: themeMode == ThemeMode.light
                      ? Colors.black87
                      : themeColor.onSurface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    final internalBackgroundColor = themeMode == ThemeMode.light
        ? const Color(0xFFF8F3E7)
        : const Color(0xFF2B2A28);

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: internalBackgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildDynamicSurahContent(context, themeMode),
                  ),

                  Center(
                    child: Text(
                      ArabicNumbers().convert(widget.pageNumber),
                      style: TextStyle(
                        fontSize: context.witdthScreen * 0.045.sp,
                        fontWeight: FontWeight.bold,
                        color: themeMode == ThemeMode.light
                            ? Colors.black54
                            : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicSurahContent(BuildContext context, ThemeMode themeMode) {
    if (widget.ayahs.isEmpty) return Container();

    final List<Widget> children = [];
    final themeColor = Theme.of(context).colorScheme;

    final Map<String, List<Ayah>> surahsInPage = {};
    for (final ayah in widget.ayahs) {
      final surahName = ayah.surahName;
      if (!surahsInPage.containsKey(surahName)) {
        surahsInPage[surahName] = [];
      }
      surahsInPage[surahName]!.add(ayah);
    }

    final bool isFirstTwoPages =
        widget.pageNumber == 1 || widget.pageNumber == 2;
    final TextAlign alignment = isFirstTwoPages
        ? TextAlign.center
        : TextAlign.justify;

    final TextStyle ayahTextStyle = TextStyle(
      fontFamily: widget.fontFamily,
      fontSize: widget.fontSize,
      color: themeMode == ThemeMode.light
          ? themeColor.scrim
          : themeColor.onSurface,
      height: widget.height,
      wordSpacing: 1.4.sp,
      letterSpacing: 0.sp,
    );

    surahsInPage.forEach((surahName, ayahs) {
      final firstAyahOfSurah = ayahs.first;

      if (firstAyahOfSurah.ayahNumber == 1) {
        children.add(_buildSurahHeader(firstAyahOfSurah, context, themeMode));

        if (surahName != "الفَاتِحة" && surahName != "التوبَة") {
          children.add(
            Center(
              child: Image.asset(
                "assets/images/basmalah.png",
                color: themeMode == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                width: context.witdthScreen * 0.55,
              ),
            ),
          );
        } else {
          children.add(SizedBox(height: context.heightScreen * 0.01));
        }
      }

      final List<TextSpan> ayahSpans = [];

      for (final ayah in ayahs) {
        ayahSpans.add(TextSpan(text: "${ayah.text} ", style: ayahTextStyle));
      }

      children.add(
        SelectableText.rich(
          TextSpan(style: ayahTextStyle, children: ayahSpans),
          textDirection: TextDirection.rtl,
          textAlign: alignment,
        ),
      );

      if (surahsInPage.length > 1) {
        children.add(SizedBox(height: context.heightScreen * 0.01));
      }
    });

    return Padding(
      padding: EdgeInsets.all(context.witdthScreen * 0.02.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}