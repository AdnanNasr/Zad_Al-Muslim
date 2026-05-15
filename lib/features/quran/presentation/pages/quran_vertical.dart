import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:zad_al_muslim/core/common/constants/surah_names.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';
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
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_book_provider.dart';
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

  late double _fontSize;
  double _baseFontSize = 22.0;
  bool _isScaling = false;
  bool _showFontIndicator = false;
  Timer? _indicatorTimer;

  // Ayah long-press state
  int _selectedSurah = 0;
  int _selectedVerse = 0;
  bool _highlightAyah = false;
  Offset? _tapPosition;

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
        _scrollToSurah(initialSurah);
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

  void _scrollToSurah(int surahNumber) {
    final index = surahNumber - 1;
    if (index < 0 || index >= 114) return;
    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: index);
    }
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
        final surah = firstVisible + 1;
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

  void _showAyahMenu(int surah, int verse, Offset position) {
    setState(() {
      _selectedSurah = surah;
      _selectedVerse = verse;
      _highlightAyah = true;
      _tapPosition = position;
    });
  }

  void _hideAyahMenu() {
    setState(() {
      _highlightAyah = false;
      _tapPosition = null;
    });
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
                      child: ScrollablePositionedList.builder(
                        physics: _isScaling
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                        padding: EdgeInsets.only(top: 70.h, bottom: 120.h),
                        itemCount: 114,
                        itemBuilder: (context, index) {
                          final surahNumber = index + 1;
                          return _SurahSection(
                            currentVisibleSurah: _currentVisibleSurah,
                            surahNumber: surahNumber,
                            fontSize: _fontSize,
                            bgColor: bgColor,
                            isDark: isDark,
                            themeColor: themeColor,
                            themeMode: themeMode,
                            currentAyah: currentAyah,
                            highlightSurah: _highlightAyah
                                ? _selectedSurah
                                : null,
                            highlightVerse: _highlightAyah
                                ? _selectedVerse
                                : null,
                            onLongPress: _showAyahMenu,
                          );
                        },
                      ),
                    ),

                    Positioned.fill(
                      child: GestureDetector(
                        // behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (isMenuOpen) {
                            _closeMenu();
                            return;
                          }

                          if (_highlightAyah) {
                            _hideAyahMenu();
                          } else {
                            _toggleShowAppBar();
                          }
                        },
                        onScaleStart: _onScaleStart,
                        onScaleUpdate: _onScaleUpdate,
                        onScaleEnd: _onScaleEnd,
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
                      // TODO
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

                    // ─── قائمة الآية عند الضغط المطول ─────────────────
                    if (_highlightAyah)
                      Positioned(
                        top: _tapPosition != null
                            ? (_tapPosition!.dy - 80.h).clamp(
                                80.0,
                                MediaQuery.of(context).size.height - 150.0,
                              )
                            : null,
                        bottom: _tapPosition == null ? 120.h : null,
                        left: 20.w,
                        right: 20.w,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) =>
                              Transform.translate(
                                offset: Offset(0, 40 * (1 - value)),
                                child: Opacity(
                                  opacity: value.clamp(0.0, 1.0),
                                  child: child,
                                ),
                              ),
                          child: _AyahActionMenu(
                            surahNumber: _selectedSurah,
                            verseNumber: _selectedVerse,
                            themeMode: themeMode,
                            onDismiss: _hideAyahMenu,
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

// ═══════════════════════════════════════════════════════════
// Widget لكل سورة
// ═══════════════════════════════════════════════════════════
class _SurahSection extends ConsumerWidget {
  final int surahNumber;
  final double fontSize;
  final Color bgColor;
  final bool isDark;
  final Color themeColor;
  final ThemeMode themeMode;
  final CurrentPlayingAyah? currentAyah;
  final int? highlightSurah;
  final int? highlightVerse;
  final void Function(int surah, int verse, Offset position) onLongPress;
  final int currentVisibleSurah;

  const _SurahSection({
    required this.surahNumber,
    required this.fontSize,
    required this.bgColor,
    required this.isDark,
    required this.themeColor,
    required this.themeMode,
    required this.currentAyah,
    required this.onLongPress,
    required this.currentVisibleSurah,
    this.highlightSurah,
    this.highlightVerse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verseCount = getVerseCount(surahNumber);
    final textColor = isDark
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF1A1A1A);
    final primaryColor = Theme.of(context).colorScheme.primary;

    // بناء الـ TextSpan لكل آيات السورة
    final List<InlineSpan> spans = [];

    for (int v = 1; v <= verseCount; v++) {
      final verseText = getVerse(surahNumber, v, verseEndSymbol: false);

      final isPlaying =
          currentAyah != null &&
          currentAyah!.surahNumber == surahNumber &&
          currentAyah!.ayahNumber == v;

      final isHighlighted =
          highlightSurah == surahNumber && highlightVerse == v;

      // final verseColor = isPlaying || isHighlighted
      //     ? primaryColor.withValues(alpha: isPlaying ? 0.85 : 0.6)
      //     : textColor;

      // النص الرئيسي للآية
      spans.add(
        TextSpan(
          text: verseText,
          style: TextStyle(
            fontFamily: "Quran",
            fontSize: fontSize,
            color: textColor,
            height: 2.0,
            backgroundColor: isPlaying
                ? primaryColor.withValues(alpha: 0.4)
                : isHighlighted
                ? primaryColor.withValues(alpha: 0.4)
                : null,
          ),
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              // نحتاج الـ position لاحقاً — نستخدم center كـ fallback
              onLongPress(
                surahNumber,
                v,
                Offset(
                  MediaQuery.of(context).size.width / 2,
                  MediaQuery.of(context).size.height / 2,
                ),
              );
            },
        ),
      );

      // رقم الآية
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onLongPressStart: (details) =>
                onLongPress(surahNumber, v, details.globalPosition),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: fontSize + 6,
              height: fontSize + 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.12),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _toArabicNumber(v),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: (fontSize * 0.42).clamp(8.0, 16.0),
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // رأس السورة
        buildQuranPageHeader(context, surahNumber, themeColor, themeMode),

        // البسملة (ما عدا الفاتحة والتوبة)
        if (surahNumber != 1 && surahNumber != 9)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              " ﱁ  ﱂﱃﱄ ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "QCF_P001",
                package: "qcf_quran",
                fontSize: fontSize,
                color: isDark
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF1A1A1A),
              ),
            ),
          ),

        // نص السورة
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: RichText(
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            text: TextSpan(children: spans),
          ),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }

  String _toArabicNumber(int n) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((d) => arabic[int.parse(d)]).join();
  }
}

// ═══════════════════════════════════════════════════════════
// قائمة أكشن الآية
// ═══════════════════════════════════════════════════════════
class _AyahActionMenu extends ConsumerWidget {
  final int surahNumber;
  final int verseNumber;
  final ThemeMode themeMode;
  final VoidCallback onDismiss;

  const _AyahActionMenu({
    required this.surahNumber,
    required this.verseNumber,
    required this.themeMode,
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
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.light
            ? Colors.white
            : const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
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
            label: 'قراءة',
            onTap: () async {
              final urlEither = ref.read(
                voiceAyahByAyahProvider(
                  AyahVoiceParameter(surahNumber, verseNumber, qari),
                ),
              );
              urlEither.fold((_) {}, (url) async {
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
                } catch (_) {}
              });
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
              final books = ref.read(tafsserBooksProvider).value;
              String bookId = 'ar.jalalayn';
              if (books != null && books.isNotEmpty) {
                bookId = books
                    .firstWhere(
                      (b) => b.isDownloaded,
                      orElse: () => books.first,
                    )
                    .id;
              }
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
