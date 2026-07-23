import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:zad_al_muslim/core/constants/surah_names.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';
import 'package:zad_al_muslim/core/utils/arabic_numbers.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart'
    show buildQuranPageHeader;
import 'package:zad_al_muslim/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/mark.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/player_state_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/quran_settings_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/voice_ayah_by_ayah_provider.dart';
import 'package:zad_al_muslim/features/quran/presentation/widgets/index_surah_menu.dart';
import 'package:zad_al_muslim/features/quran/presentation/widgets/mini_audio_player.dart';
import 'package:zad_al_muslim/features/quran/presentation/widgets/qurah_page_bottom_navigation_bar.dart';
import 'package:zad_al_muslim/features/quran/presentation/widgets/quran_page_app_bar.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/selected_book.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/widgets/show_tafsser_modal_bottom.dart';
import 'package:qcf_quran/qcf_quran.dart' hide ScreenType;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

class QuranVerticalPage extends ConsumerStatefulWidget {
  final int? pageNumber;
  final int? highlightSurah;
  final int? highlightVerse;

  const QuranVerticalPage({
    super.key,
    this.pageNumber,
    this.highlightSurah,
    this.highlightVerse,
  });

  @override
  ConsumerState<QuranVerticalPage> createState() => _QuranVerticalPageState();
}

class _QuranVerticalPageState extends ConsumerState<QuranVerticalPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final List<_VerticalQuranItem> _readingItems = [];
  final Map<int, int> _surahStartIndices = {};
  final Map<(int, int), int> _ayahIndices = {};

  late double _fontSize;
  double _baseFontSize = 22.0;
  bool _isScaling = false;
  bool _showFontIndicator = false;
  Timer? _indicatorTimer;

  // Current visible surah for app bar
  int _currentVisibleSurah = 1;
  int _onPageChanged = 1;

  // App Bar, Bottom Bar and Menu State
  bool isMenuOpen = false;
  bool _showAppAndBottomBar = true;

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _closeMenu() {
    setState(() {
      isMenuOpen = false;
    });
  }

  void _toggleShowAppBar() {
    setState(() {
      _showAppAndBottomBar = !_showAppAndBottomBar;
    });
  }

  @override
  void initState() {
    super.initState();
    _prepareReadingItems();
    itemPositionsListener.itemPositions.addListener(_onScroll);

    // تحديد السورة الابتدائية من رقم الصفحة
    final page = widget.pageNumber ?? 1;
    _onPageChanged = page;
    final initialSurah = _surahFromPage(page);
    _currentVisibleSurah = initialSurah;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fontSize = ref.read(quranSettingsProvider).quranVerticalFontSize;
      setState(() {});

      // تأخير بسيط للتأكد من بناء الصفحة قبل التمرير
      Future.delayed(const Duration(milliseconds: 100), () {
        final highlightSurah = widget.highlightSurah;
        final highlightVerse = widget.highlightVerse;
        if (highlightSurah != null && highlightVerse != null) {
          _scrollToAyah(highlightSurah, highlightVerse);
        } else {
          _scrollToSurah(initialSurah);
        }
      });
    });
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    _indicatorTimer?.cancel();
    super.dispose();
  }

  /// تحويل رقم الصفحة إلى رقم السورة
  int _surahFromPage(int page) {
    for (int s = 1; s <= 114; s++) {
      final p = getPageNumber(s, 1);
      if (p > page) {
        return s > 1 ? s - 1 : 1;
      } else if (p == page) {
        return s;
      }
    }
    return 114;
  }

  void _prepareReadingItems() {
    for (var surah = 1; surah <= 114; surah++) {
      _surahStartIndices[surah] = _readingItems.length;
      _readingItems.add(
        _VerticalQuranItem(
          type: _VerticalItemType.surahHeader,
          surahNumber: surah,
        ),
      );

      if (surah != 1 && surah != 9) {
        _readingItems.add(
          _VerticalQuranItem(
            type: _VerticalItemType.basmala,
            surahNumber: surah,
          ),
        );
      }

      final verseCount = getVerseCount(surah);
      for (var verse = 1; verse <= verseCount; verse++) {
        _ayahIndices[(surah, verse)] = _readingItems.length;
        _readingItems.add(
          _VerticalQuranItem(
            type: _VerticalItemType.ayah,
            surahNumber: surah,
            verseNumber: verse,
          ),
        );
      }

      _readingItems.add(
        _VerticalQuranItem(
          type: _VerticalItemType.surahGap,
          surahNumber: surah,
        ),
      );
    }
  }

  void _scrollToSurah(int surahNumber) {
    final index = _surahStartIndices[surahNumber];
    if (index == null) return;
    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: index);
    }
  }

  void _scrollToAyah(int surahNumber, int verseNumber) {
    final index = _ayahIndices[(surahNumber, verseNumber)];
    if (index == null || !itemScrollController.isAttached) return;
    itemScrollController.jumpTo(index: index, alignment: .12);
  }

  void _onScroll() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      // Find the first item whose trailing edge is visible, or which is the topmost visible
      int? firstVisible;
      double minTop = double.infinity;
      for (var pos in positions) {
        if (pos.itemTrailingEdge > 0 && pos.itemLeadingEdge < minTop) {
          minTop = pos.itemLeadingEdge;
          firstVisible = pos.index;
        }
      }
      if (firstVisible != null) {
        final surah = _readingItems[firstVisible].surahNumber;
        final page = getPageNumber(surah, 1);
        if (_currentVisibleSurah != surah || _onPageChanged != page) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _currentVisibleSurah = surah;
                _onPageChanged = page;
              });
            }
          });
        }
      }
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    // 1. استخدام setState هنا ضروري لتعطيل الـ Scroll فوراً
    setState(() {
      _isScaling = true;
    });
    _baseFontSize = _fontSize;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // 2. التحقق من عدد الأصابع ومن أننا في وضع Scaling
    if (details.pointerCount < 2 && !_isScaling) return;

    final newSize = (_baseFontSize * details.scale).clamp(14.0, 40.0);

    // 3. تقليل العتبة (Threshold) إلى 0.1 يجعل الزوم يبدو "لحظياً" أكثر
    if ((newSize - _fontSize).abs() > 0.1) {
      setState(() {
        _fontSize = newSize;
        _showFontIndicator = true;
      });

      _indicatorTimer?.cancel();
      _indicatorTimer = Timer(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _showFontIndicator = false);
      });
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    // 4. إعادة تفعيل الـ Scroll وتخزين القيمة نهائياً
    setState(() {
      _isScaling = false;
    });

    // حفظ القيمة في الـ Provider (يفضل بدون await لسرعة الاستجابة)
    ref
        .read(quranSettingsProvider.notifier)
        .setQuranVerticalFontSize(_fontSize);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(quranSettingsProvider);
    if (!_isScaling) {
      _fontSize = settings.quranVerticalFontSize;
    }

    final themeMode = ref.watch(themeProvider);
    final themeColor = ref.watch(userThemeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        Theme.of(context).brightness == Brightness.dark;

    final List<Color> colorsList = isDark
        ? [
            const Color(0xFF1E1E1E),
            const Color(0xFF000000),
            const Color(0xFF2C241B),
            const Color(0xFF111A22),
          ]
        : [
            const Color(0xFFF5E6D3),
            const Color(0xFFFFFFFF),
            const Color(0xFFF5F5F5),
            const Color(0xFFFAF6EE),
          ];

    final bgColor =
        colorsList[settings.readingBackgroundColorIndex.clamp(
          0,
          colorsList.length - 1,
        )];

    final currentAyah = ref.watch(currentPlayingAyahProvider);

    final showBars = _showAppAndBottomBar && currentAyah == null;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.35,
                color: Theme.of(
                  context,
                ).colorScheme.primaryFixedDim.withValues(alpha: .08),
                child: const IndexSurahMenu(),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              transform: Matrix4.translationValues(
                isMenuOpen ? -MediaQuery.of(context).size.width / 1.35 : 0,
                0,
                0,
              ),
              child: Scaffold(
                backgroundColor: bgColor,
                extendBody: true,
                body: Stack(
                  children: [
                    // ─── المحتوى الرئيسي ───────────────────────────────
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          if (isMenuOpen) {
                            _closeMenu();
                          } else {
                            _toggleShowAppBar();
                          }
                        },
                        onScaleStart: _onScaleStart,
                        onScaleUpdate: _onScaleUpdate,
                        onScaleEnd: _onScaleEnd,
                        child: ScrollablePositionedList.builder(
                          physics: _isScaling
                              ? const NeverScrollableScrollPhysics()
                              : const AlwaysScrollableScrollPhysics(),
                          itemScrollController: itemScrollController,
                          itemPositionsListener: itemPositionsListener,
                          padding: EdgeInsets.only(top: 70.h, bottom: 120.h),
                          itemCount: _readingItems.length,
                          itemBuilder: (context, index) {
                            final item = _readingItems[index];
                            return switch (item.type) {
                              _VerticalItemType.surahHeader => Padding(
                                padding: const EdgeInsetsGeometry.only(
                                  bottom: 18,
                                ),
                                child: buildQuranPageHeader(
                                  context,
                                  item.surahNumber,
                                  themeColor,
                                  themeMode,
                                ),
                              ),
                              _VerticalItemType.basmala => _BasmalaItem(
                                fontSize: _fontSize,
                                isDark: isDark,
                              ),
                              _VerticalItemType.ayah => RepaintBoundary(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                  ),
                                  child: _AyahCard(
                                    surahNumber: item.surahNumber,
                                    verseNumber: item.verseNumber!,
                                    fontSize: _fontSize,
                                    backgroundColor: bgColor,
                                    isDark: isDark,
                                    isPlaying:
                                        currentAyah?.surahNumber ==
                                            item.surahNumber &&
                                        currentAyah?.ayahNumber ==
                                            item.verseNumber,
                                    isHighlighted:
                                        widget.highlightSurah ==
                                            item.surahNumber &&
                                        widget.highlightVerse ==
                                            item.verseNumber,
                                  ),
                                ),
                              ),
                              _VerticalItemType.surahGap => SizedBox(
                                height: 20.h,
                              ),
                            };
                          },
                        ),
                      ),
                    ),

                    // ─── شريط العنوان التفاعلي (Toggling AppBar) ─────────
                    if (showBars)
                      AppAndBottomBar(
                        globalSurahNumber: _currentVisibleSurah,
                        globalStartOfSurah: 1,
                      ),

                    // ─── مؤشر حجم الخط ────────────────────────────────
                    AnimatedOpacity(
                      opacity: _showFontIndicator ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .7),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.format_size_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                _fontSize.toStringAsFixed(0),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ─── المشغل الصوتي ─────────────────────────────────
                    Positioned(
                      bottom: showBars
                          ? kBottomNavigationBarHeight + 10.h
                          : 10.h,
                      left: 0,
                      right: 0,
                      child: const MiniAudioPlayer(),
                    ),

                    // ─── شريط التنقل السفلي ───────────────────────────
                    if (showBars)
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
          ],
        ),
      ),
    );
  }
}

enum _VerticalItemType { surahHeader, basmala, ayah, surahGap }

class _VerticalQuranItem {
  const _VerticalQuranItem({
    required this.type,
    required this.surahNumber,
    this.verseNumber,
  });

  final _VerticalItemType type;
  final int surahNumber;
  final int? verseNumber;
}

class _BasmalaItem extends StatelessWidget {
  const _BasmalaItem({required this.fontSize, required this.isDark});

  final double fontSize;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      child: Text(
        " ﱁ  ﱂﱃﱄ ",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "QCF_P001",
          package: "qcf_quran",
          fontSize: fontSize,
          color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// بطاقة الآية
// ═══════════════════════════════════════════════════════════
class _AyahCard extends ConsumerWidget {
  const _AyahCard({
    required this.surahNumber,
    required this.verseNumber,
    required this.fontSize,
    required this.backgroundColor,
    required this.isDark,
    required this.isPlaying,
    required this.isHighlighted,
  });

  final int surahNumber;
  final int verseNumber;
  final double fontSize;
  final Color backgroundColor;
  final bool isDark;
  final bool isPlaying;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final active = isPlaying || isHighlighted;
    final pageNumber = getPageNumber(surahNumber, verseNumber);
    final marks = ref.watch(marksProvder);
    final isReadingPositionSaved = marks.any(
      (mark) => mark.pageNumber == pageNumber && mark.ayahNumber == null,
    );
    final cardColor = Color.alphaBlend(
      scheme.primary.withValues(alpha: active ? .11 : .025),
      backgroundColor,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: active
              ? scheme.primary.withValues(alpha: .65)
              : isDark
              ? scheme.outlineVariant.withValues(alpha: .65)
              : scheme.outline.withValues(alpha: .28),
          width: active ? 1.4 : 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: .07),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 13.h, 16.w, 4.h),
            child: Row(
              children: [
                Container(
                  height: 34.r,
                  padding: EdgeInsets.symmetric(horizontal: 9.w),
                  constraints: BoxConstraints(minWidth: 42.r),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? scheme.primary : scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'آية ${_toArabicNumber(verseNumber)}',
                    style: TextStyle(
                      fontFamily: 'Quran',
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w800,
                      color: active
                          ? scheme.onPrimary
                          : scheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                if (isPlaying) ...[
                  Icon(
                    Icons.graphic_eq_rounded,
                    size: 19.sp,
                    color: scheme.primary,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'جاري الاستماع',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ],
                SizedBox(width: 6.w),
                IconButton.filledTonal(
                  visualDensity: VisualDensity.compact,
                  tooltip: isReadingPositionSaved
                      ? 'إزالة موضع القراءة'
                      : 'حفظ موضع القراءة',
                  onPressed: () async {
                    final notifier = ref.read(marksProvder.notifier);
                    if (isReadingPositionSaved) {
                      await notifier.removeMark(pageNumber);
                    } else {
                      await notifier.addMark(
                        Mark()
                          ..surahName = SurahNames.getFormattedName(surahNumber)
                          ..pageNumber = pageNumber
                          ..surahNumber = surahNumber,
                      );
                    }
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            isReadingPositionSaved
                                ? 'تمت إزالة موضع القراءة'
                                : 'تم حفظ موضع القراءة وسيظهر تقدمك في الصفحة الرئيسية',
                          ),
                        ),
                      );
                  },
                  icon: Icon(
                    isReadingPositionSaved ? Icons.save : Icons.save_outlined,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 14.h),
            child: Text(
              '${getVerse(surahNumber, verseNumber, verseEndSymbol: false)} ${ArabicNumbers().convert(verseNumber)}',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: 'Quran',
                fontSize: fontSize,
                height: 2,
                color: isDark
                    ? const Color(0xFFE8E4DC)
                    : const Color(0xFF1A1A1A),
              ),
            ),
          ),
          Divider(height: 1, color: scheme.outlineVariant),
          _AyahActionMenu(
            surahNumber: surahNumber,
            verseNumber: verseNumber,
            onDismiss: () {},
          ),
        ],
      ),
    );
  }

  String _toArabicNumber(int number) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabic[int.parse(digit)])
        .join();
  }
}

// ═══════════════════════════════════════════════════════════
// إجراءات الآية
// ═══════════════════════════════════════════════════════════
class _AyahActionMenu extends ConsumerWidget {
  final int surahNumber;
  final int verseNumber;
  final VoidCallback onDismiss;

  const _AyahActionMenu({
    required this.surahNumber,
    required this.verseNumber,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marks = ref.watch(marksProvder);
    final qari = ref.watch(selectedQariProvider);
    final isMarked = marks.any(
      (m) => m.surahNumber == surahNumber && m.ayahNumber == verseNumber,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .55),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _btn(
            context,
            icon: Icons.copy_rounded,
            label: 'نسخ',
            onTap: () async {
              final text = getVerse(
                surahNumber,
                verseNumber,
                verseEndSymbol: false,
              );
              await Clipboard.setData(ClipboardData(text: text));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم نسخ الآية')));
              onDismiss();
            },
          ),
          _btn(
            context,
            icon: Icons.play_arrow_rounded,
            label: 'استماع',
            onTap: () async {
              final urlEither = ref.read(
                voiceAyahByAyahProvider(
                  AyahVoiceParameter(surahNumber, verseNumber, qari),
                ),
              );
              urlEither.fold(
                (failure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(failure.message)));
                },
                (url) async {
                  try {
                    final player = ref.read(audioPlayerProvider);
                    await player.stop();
                    ref
                        .read(currentPlayingAyahProvider.notifier)
                        .state = CurrentPlayingAyah(
                      surahNumber: surahNumber,
                      ayahNumber: verseNumber,
                      surahName: SurahNames.getFormattedName(surahNumber),
                    );
                    await player.setAudioSource(
                      AudioSource.uri(
                        Uri.parse(url),
                        tag: MediaItem(
                          id: 'ayah_${surahNumber}_$verseNumber',
                          title:
                              'سورة ${SurahNames.getFormattedName(surahNumber)}',
                          artist: 'الآية $verseNumber',
                        ),
                      ),
                    );
                    await player.play();
                  } on PlayerInterruptedException {
                    // تم الإيقاف من قبل المستخدم
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تعذّر تشغيل الآية. تحقق من الاتصال.'),
                      ),
                    );
                  }
                },
              );
              onDismiss();
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              return _btn(
                context,
                icon: isMarked
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_add_outlined,
                label: 'علامة',
                onTap: () async {
                  final notifier = ref.read(marksProvder.notifier);
                  if (!isMarked) {
                    await notifier.addMark(
                      Mark()
                        ..surahName = SurahNames.getFormattedName(surahNumber)
                        ..pageNumber = getPageNumber(surahNumber, verseNumber)
                        ..surahNumber = surahNumber
                        ..ayahNumber = verseNumber,
                    );
                  } else {
                    await notifier.removeAyahMark(surahNumber, verseNumber);
                  }
                  onDismiss();
                },
              );
            },
          ),
          _btn(
            context,
            icon: Icons.menu_book_rounded,
            label: 'تفسير',
            onTap: () {
              final bookId = ref.read(selectedBookProvider).id;
              showTafsserModalBottom(
                context,
                ref,
                surahNumber,
                verseNumber,
                bookId,
              );
              onDismiss();
            },
          ),
          _btn(
            context,
            icon: Icons.share_rounded,
            label: 'مشاركة',
            onTap: () async {
              final text = getVerse(
                surahNumber,
                verseNumber,
                verseEndSymbol: true,
              );
              await SharePlus.instance.share(ShareParams(text: text));
              onDismiss();
            },
          ),
        ],
      ),
    );
  }

  Widget _btn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
