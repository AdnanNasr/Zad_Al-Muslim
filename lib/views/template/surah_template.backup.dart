import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/view_models/providers/theme_provider.dart';

class SurahTemplate extends ConsumerStatefulWidget {
  final List<Ayah> ayahs;
  final int pageNumber;

  const SurahTemplate({
    super.key,
    required this.ayahs,
    required this.pageNumber,
  });

  @override
  ConsumerState<SurahTemplate> createState() => _SurahTemplateState();
}

class _SurahTemplateState extends ConsumerState<SurahTemplate> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final themeColor = Theme.of(context).colorScheme;

    // الحصول على معلومات السورة من أول آية تحتوي بيانات صالحة
    final firstValidAyah = widget.ayahs.firstWhere(
      (a) => a.surahName.isNotEmpty && a.revelationType.isNotEmpty,
      orElse: () => widget.ayahs.first,
    );

    final surahName = firstValidAyah.surahName.isNotEmpty
        ? firstValidAyah.surahName
        : "سورة غير معروفة";

    final revelationType = firstValidAyah.revelationType.isNotEmpty
        ? firstValidAyah.revelationType
        : "";

    final ayahCount = firstValidAyah.numberOfAyahs > 0
        ? firstValidAyah.numberOfAyahs
        : widget.ayahs.length;

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.light
          ? const Color(0xFFF8F3E7)
          : const Color(0xFF2B2A28),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (firstValidAyah.ayahNumber == 1)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.witdthScreen * 0.04,
                ),
                child: Column(
                  children: [
                    Text(
                      surahName,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: context.witdthScreen * 0.09,
                        fontWeight: FontWeight.bold,
                        color: themeMode == ThemeMode.light
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                    SizedBox(height: context.heightScreen * 0.005),
                    Text(
                      "$revelationType • $ayahCount آية",
                      style: TextStyle(
                        fontSize: context.witdthScreen * 0.04,
                        color: themeColor.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  radius: const Radius.circular(12),
                  thickness: 3,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.witdthScreen * 0.05,
                        vertical: context.witdthScreen * 0.025,
                      ),
                      child: Column(
                        children: [
                          if (widget.ayahs.first.ayahNumber == 1 &&
                              widget.ayahs.first.surahName != "ٱلْفَاتِحَةِ" &&
                              widget.ayahs.first.surahName != "التَّوۡبَةِ")
                            Center(
                              child: Image.asset(
                                "assets/images/basmalah.png",
                                color: themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          SelectableText(
                            _buildSurahTextWithNumbers(),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: context.witdthScreen * 0.075,
                              color: themeMode == ThemeMode.light
                                  ? themeColor.scrim
                                  : themeColor.onSurface,
                              height: 2.1,
                              wordSpacing: -7,
                            ),
                          ),
                          const SizedBox(height: 20), // مسافة بسيطة قبل رقم الصفحة
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    "${widget.pageNumber}",
                    style: TextStyle(
                      fontSize: context.witdthScreen * 0.06,
                      fontWeight: FontWeight.bold,
                      color: themeMode == ThemeMode.light
                          ? Colors.black54
                          : Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء نص السورة مع أرقام الآيات
  String _buildSurahTextWithNumbers() {
    if (widget.ayahs.isEmpty) return '';

    final buffer = StringBuffer();
    for (final ayah in widget.ayahs) {
      buffer.write(ayah.text);
      buffer.write(' ﴿${ayah.ayahNumber}﴾ ');
    }
    return buffer.toString();
  }
}
