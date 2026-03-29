import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/features/tafsser/presentation/widgets/show_tafsser_modal_bottom.dart';
import 'package:noor_quran/features/quran/data/models/quran_models.dart';
import 'package:noor_quran/core/utils/arabic_numbers.dart';
import 'package:noor_quran/features/tafsser/domain/entities/tafsser_entities.dart';
import 'package:noor_quran/features/tafsser/presentation/providers/tafsser_book_provider.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';

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
  int? _selectedAyahId;
  final List<GestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    _scrollController.dispose();
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  void _showHorizontalMenu(
    BuildContext context,
    Ayah ayah,
    Offset position,
    TafsserBookEntity? selectedBook,
  ) {
    final menuWidth = 250.0.w;
    final menuHeight = 70.0.h;
    final screenSize = MediaQuery.of(context).size;

    double left = position.dx - (menuWidth / 2);
    double top = position.dy - menuHeight - 20;

    if (left < 10) left = 10;
    if (left + menuWidth > screenSize.width - 10) {
      left = screenSize.width - menuWidth - 10;
    }
    if (top < 50) top = position.dy + 20;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.transparent,
      pageBuilder: (ctx, anim1, anim2) => Stack(
        children: [
          Positioned(
            top: top,
            left: left,
            child: FadeTransition(
              opacity: anim1,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuAction(ctx, Icons.copy, "نسخ", () {
                        Clipboard.setData(ClipboardData(text: ayah.text));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم نسخ الآية"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }),
                      _divider(),
                      _menuAction(ctx, Icons.menu_book, "تفسير", () {
                        final effectiveBookId =
                            selectedBook?.id ?? 'ar.jalalayn';

                        Navigator.pop(ctx);

                        showTafsserModalBottom(
                          context,
                          ref,
                          ayah.surahNumber,
                          ayah.ayahNumber,
                          effectiveBookId,
                        );
                      }),
                      _divider(),
                      _menuAction(
                        ctx,
                        Icons.share,
                        "مشاركة",
                        () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) setState(() => _selectedAyahId = null);
    });
  }

  Widget _menuAction(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20.sp, color: Theme.of(context).primaryColor),
            Text(
              title,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 20.h,
    color: Colors.grey.withValues(alpha: 0.2),
    margin: EdgeInsets.symmetric(horizontal: 2.w),
  );

  @override
  Widget build(BuildContext context) {
    final selectedBook = ref.watch(selectedTafsserBookProvider);
    final themeMode = ref.watch(themeProvider);
    final bgColor = themeMode == ThemeMode.light
        ? const Color(0xFFF8F3E7)
        : const Color(0xFF2B2A28);

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: bgColor,
          child: Column(
            children: [
              Expanded(
                child: _buildDynamicSurahContent(
                  context,
                  themeMode,
                  selectedBook,
                ),
              ),
              _buildPageNumber(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicSurahContent(
    BuildContext context,
    ThemeMode themeMode,
    TafsserBookEntity? selectedBook,
  ) {
    if (widget.ayahs.isEmpty) return const SizedBox.shrink();
    _disposeRecognizers();

    final List<Widget> children = [];
    final Map<String, List<Ayah>> surahsInPage = {};
    for (var a in widget.ayahs) {
      surahsInPage.putIfAbsent(a.surahName, () => []).add(a);
    }

    surahsInPage.forEach((surahName, ayahs) {
      children.add(_buildSurahHeader(ayahs.first, themeMode));

      final List<TextSpan> ayahSpans = [];
      for (final ayah in ayahs) {
        final int uniqueId = (ayah.surahNumber * 1000) + ayah.ayahNumber;

        final recognizer =
            LongPressGestureRecognizer(
                duration: const Duration(milliseconds: 400),
              )
              ..onLongPressStart = (details) {
                HapticFeedback.lightImpact();
                setState(() => _selectedAyahId = uniqueId);
                _showHorizontalMenu(
                  context,
                  ayah,
                  details.globalPosition,
                  selectedBook,
                );
              };
        _recognizers.add(recognizer);

        ayahSpans.add(
          TextSpan(
            text: " ${ayah.text}",
            style: TextStyle(
              fontFamily: widget.fontFamily,
              fontSize: widget.fontSize,
              height: widget.height,
              color: themeMode == ThemeMode.light
                  ? Colors.black87
                  : Colors.white,
              backgroundColor: _selectedAyahId == uniqueId
                  ? Theme.of(context).primaryColor.withValues(alpha: .2)
                  : null,
            ),
            recognizer: recognizer,
          ),
        );
      }

      children.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Text.rich(
            TextSpan(children: ayahSpans),
            textAlign: TextAlign.justify,
            softWrap: true,
          ),
        ),
      );
    });

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(children: children),
    );
  }

  Widget _buildPageNumber() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        ArabicNumbers().convert(widget.pageNumber),
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSurahHeader(Ayah ayah, ThemeMode themeMode) {
    if (ayah.ayahNumber != 1) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/surah_banner.png", width: 0.9.sw),
          Text(
            ayah.surahName,
            style: TextStyle(
              fontFamily: 'Quran',
              fontSize: 22.sp,
              color: themeMode == ThemeMode.light
                  ? Colors.black87
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
