import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/core/constants/enums/qrai_names_ayah_by_ayah.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/screen_util_sizes.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/themes/theme_notifier.dart';
import 'package:noor_quran/features/quran/data/models/mark.dart';
import 'package:noor_quran/features/quran/domain/repositories/voice_ayah_by_ayah_repo.dart';
import 'package:noor_quran/features/quran/domain/usecases/get_surah_number_by_page_number.dart';
import 'package:noor_quran/features/quran/presentation/providers/audio_player_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/mark.dart';
import 'package:noor_quran/features/quran/presentation/providers/player_state_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/quran_settings_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/surah_by_page_number_provider.dart';
import 'package:noor_quran/features/quran/presentation/providers/voice_ayah_by_ayah_provider.dart';
import 'package:noor_quran/features/quran/presentation/widgets/index_surah_menu.dart';
import 'package:noor_quran/features/quran/presentation/widgets/mini_audio_player.dart';
import 'package:noor_quran/features/quran/presentation/widgets/qurah_page_bottom_navigation_bar.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_page_app_bar.dart';
import 'package:noor_quran/core/common/constants/surah_names.dart';
import 'package:flutter/services.dart';
import 'package:noor_quran/features/tafsser/presentation/providers/tafsser_book_provider.dart';
import 'package:noor_quran/features/tafsser/presentation/widgets/show_tafsser_modal_bottom.dart';
import 'package:qcf_quran/qcf_quran.dart' hide ScreenType;
import 'package:share_plus/share_plus.dart';

class QuranPages extends ConsumerStatefulWidget {
  final int? pageNumber;
  final int? highlightSurah;
  final int? highlightVerse;

  const QuranPages({
    super.key,
    this.pageNumber,
    this.highlightSurah,
    this.highlightVerse,
  });

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

  late final PageController _pageController;

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
  int _onPageChanged = 1;
  Offset? _tapPosition;

  void onChnageSurahNumber(int surahNumber) => setState(() {
    _onPageChanged = surahNumber;
  });

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final initialPage = (widget.pageNumber != null && widget.pageNumber! > 0)
        ? widget.pageNumber!
        : 1;
    _onPageChanged = initialPage;
    _pageController = PageController(initialPage: initialPage - 1);

    if (widget.highlightSurah != null && widget.highlightVerse != null) {
      _surahNumber = widget.highlightSurah!;
      _verseNumber = widget.highlightVerse!;
      _highlightAyah = true;
    }
  }

  List<String> surahsInPage = [];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.read(themeProvider);
    final themeColor = ref.read(userThemeProvider);
    final currentSelectedQariProvider = ref.watch(selectedQariProvider);

    List<dynamic> pageData = getPageData(_onPageChanged);
    surahsInPage.clear();
    for (int i = 0; i < pageData.length; i++) {
      final surahName = SurahNames.getFormattedName(
        pageData[i]["surah"] as int,
      );
      surahsInPage.add(surahName);
    }
    // الاستماع لتغيير الآية الحالية للقيام بالتمرير التلقائي
    ref.listen(currentPlayingAyahProvider, (previous, current) {
      final autoScroll = ref.read(quranSettingsProvider).autoScrollWithAudio;
      if (current != null && autoScroll) {
        final ayahPage = getPageNumber(current.surahNumber, current.ayahNumber);
        if (ayahPage != _onPageChanged) {
          _pageController.animateToPage(
            ayahPage - 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
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
              child: _quranPages(
                context,
                themeMode,
                themeColor,
                currentSelectedQariProvider,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold _quranPages(
    BuildContext context,
    ThemeMode themeMode,
    FlexScheme themeColor,
    QariModel currentSelectedQariProvider,
  ) {
    final settings = ref.watch(quranSettingsProvider);
    final theme = Theme.of(context);
    final isDark =
        themeMode == ThemeMode.dark || theme.brightness == Brightness.dark;

    final List<Color> currentColorsList = isDark
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

    final Color pageBackgroundColor =
        currentColorsList[settings.readingBackgroundColorIndex.clamp(
          0,
          currentColorsList.length - 1,
        )];

    var globalSurahNumber = ref.read(
      surahByPageNumberProvider.call(_onPageChanged),
    )["surah"]!;
    var globalStartOfSurah = ref.read(
      surahByPageNumberProvider.call(_onPageChanged),
    )["start"]!;

    final currentAyah = ref.watch(currentPlayingAyahProvider);
    final isAudioPlaying = currentAyah != null;
    final showBars = _showAppAndBottomBar && !isAudioPlaying;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          if (isMenuOpen) {
            _closeMenu();
            return;
          }

          if (_highlightAyah) {
            _highlightAyah = false;
            _tapPosition = null;
            setState(() {});
          } else {
            _toggleShowAppBar();
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(top: context.mediaQueryHeight * 0.055),
              child: Align(
                alignment: Alignment.center,
                child: InteractiveViewer(
                  child: PageviewQuran(
                    controller: _pageController,
                    theme: isDark == false
                        ? QcfThemeData(
                            pageBackgroundColor: pageBackgroundColor,
                            verseNumberHeight:
                                _onPageChanged == 1 || _onPageChanged == 2
                                ? 2.2
                                : 2,
                            verseHeight: 2,

                            verseNumberColor: context.color.primary,
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
                            verseNumberColor: context.color.primary, // amber
                            basmalaColor: context.color.primary,
                            headerTextColor: Colors.white,
                            headerBackgroundColor: Colors.white,
                            pageBackgroundColor: pageBackgroundColor,
                            verseNumberHeight:
                                _onPageChanged == 1 || _onPageChanged == 2
                                ? 2.2
                                : 2,
                            verseHeight: 2,
                            customHeaderBuilder: (surahNumber) {
                              return customQuranPageHeader(
                                context,
                                surahNumber,
                                themeColor,
                                themeMode,
                              );
                            },
                          ),
                    sp: context.tiny
                        ? 1.sp
                        : context.small
                        ? 1.sp
                        : context.medium
                        ? 1.sp
                        : 1.sp,
                    h: context.tiny ? 0.87 : 1.05,
                    initialPageNumber:
                        widget.pageNumber != null && widget.pageNumber! > 0
                        ? widget.pageNumber!
                        : 1,
                    verseBackgroundColor: (surahNumber, verseNumber) {
                      // تظليل الآية التي يتم قراءتها حالياً
                      if (currentAyah != null &&
                          currentAyah.surahNumber == surahNumber &&
                          currentAyah.ayahNumber == verseNumber) {
                        return context.color.primary.withValues(
                          alpha: 0.4,
                        ); // لون أغمق للمقروءة
                      }

                      // تظليل الآية عند التحديد العادي
                      if (surahNumber == _surahNumber &&
                          verseNumber == _verseNumber &&
                          _highlightAyah) {
                        return context.color.primary.withValues(alpha: 0.25);
                      }
                      return null;
                    },
                    onLongPressDown: (_, _, details) {
                      _tapPosition = details.globalPosition;
                    },
                    onLongPress: (surahNumber, verseNumber) {
                      _surahNumber = surahNumber;
                      _verseNumber = verseNumber;
                      setState(() {});

                      _toggleHighlightAyah(_surahNumber, _verseNumber);
                    },
                    onPageChanged: (pageNumber) {
                      ref.read(surahByPageNumberProvider.call(pageNumber));
                      _onPageChanged = pageNumber;
                      setState(() {});
                      _hideAppBar();
                      _removeHighlightAyah();
                      _tapPosition = null;
                      _closeMenu();
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            surahsInPage.join(" "),
                            style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: context.color.primary,
                            ),
                          ),
                          // جهة اليسار: رقم الجزء
                          Row(
                            children: [
                              Text(
                                "الجزء ${getJuzNumber(globalSurahNumber, globalStartOfSurah)}",
                                style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: context.color.primary,
                                ),
                              ),
                              Consumer(
                                builder: (context, ref, child) {
                                  final marks = ref.watch(marksProvder);
                                  final isMarked = marks.any(
                                    (m) => m.pageNumber == _onPageChanged,
                                  );
                                  return IconButton(
                                    onPressed: () async {
                                      final int? surahNumber =
                                          sl<GetSurahNumberByPageNumber>().call(
                                            _onPageChanged,
                                          )["surah"];
                                      if (!isMarked) {
                                        await ref
                                            .read(marksProvder.notifier)
                                            .addMark(
                                              Mark()
                                                ..surahName =
                                                    SurahNames.getFormattedName(
                                                      globalSurahNumber,
                                                    )
                                                ..pageNumber = _onPageChanged
                                                ..surahNumber = surahNumber,
                                            );

                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              backgroundColor:
                                                  context.color.primary,
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .bookmark_added_rounded,
                                                    color:
                                                        context.color.onPrimary,
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Text(
                                                    "تم إضافة علامة القراءة",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily: "Cairo",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: context
                                                          .color
                                                          .onPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                      } else {
                                        await ref
                                            .read(marksProvder.notifier)
                                            .removeMark(_onPageChanged);

                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .bookmark_remove_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Text(
                                                    "تم إزالة العلامة",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily: "Cairo",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                      }
                                    },
                                    icon: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      transitionBuilder: (child, anim) =>
                                          ScaleTransition(
                                            scale: anim,
                                            child: child,
                                          ),
                                      child: Icon(
                                        isMarked
                                            ? Icons.bookmark_rounded
                                            : Icons.bookmark_outline_rounded,
                                        key: ValueKey(isMarked),
                                        color: isMarked
                                            ? context.color.primary
                                            : context.color.primary,
                                        size: 24.sp,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0.h,
              child: Text(
                _onPageChanged.toString(), // رقم الصفحة الحالية
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold,
                  color: context.color.primary,
                ),
              ),
            ),
            if (showBars)
              AppAndBottomBar(
                globalSurahNumber: globalSurahNumber,
                globalStartOfSurah: globalStartOfSurah,
              ),

            if (showBars)
              Positioned(
                bottom: kBottomNavigationBarHeight / 2,
                left: 0,
                right: 0,
                child: QurahPageBottomNavigationBar(
                  onIndexPressed: _toggleMenu,
                ),
              ),

            if (_highlightAyah)
              Positioned(
                top: _tapPosition != null
                    ? (_tapPosition!.dy - 100.h).clamp(
                        100.0,
                        context.mediaQueryHeight - 150.0,
                      )
                    : null,
                bottom: _tapPosition == null
                    ? (_showAppAndBottomBar ? 120.h : 80.h)
                    : null,
                left: 20.w,
                right: 20.w,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: ayahMenu(
                    themeMode,
                    context,
                    currentSelectedQariProvider,
                  ),
                ),
              ),

            // Mini Audio Player widget
            Positioned(
              bottom: kBottomNavigationBarHeight + 10.h,
              left: 0,
              right: 0,
              child: const MiniAudioPlayer(),
            ),
          ],
        ),
      ),
    );
  }

  Container ayahMenu(
    ThemeMode themeMode,
    BuildContext context,
    QariModel currentSelectedQariProvider,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
        // horizontal: 16.w,
      ),
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
          _actionButton(
            icon: Icons.copy_rounded,
            label: 'نسخ',
            onTap: () async {
              final text = getVerse(
                _surahNumber,
                _verseNumber,
                verseEndSymbol: false,
              );
              await Clipboard.setData(ClipboardData(text: text));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ الآية بنجاح')),
              );
              _highlightAyah = false;
              setState(() {});
            },
          ),
          _actionButton(
            icon: Icons.play_arrow_rounded,
            label: 'قراءة',
            onTap: () async {
              final url = ref.read(
                voiceAyahByAyahProvider(
                  AyahVoiceParameter(
                    _surahNumber,
                    _verseNumber,
                    currentSelectedQariProvider,
                  ),
                ),
              );

              url.fold(
                (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "حدث خطأ",
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  );
                },
                (url) async {
                  try {
                    final player = ref.read(audioPlayerProvider);
                    await player.stop(); // Stop previous audio if any

                    ref
                        .read(currentPlayingAyahProvider.notifier)
                        .state = CurrentPlayingAyah(
                      surahNumber: _surahNumber,
                      ayahNumber: _verseNumber,
                      surahName: SurahNames.getFormattedName(_surahNumber),
                    );

                    await player.setAudioSource(
                      AudioSource.uri(
                        Uri.parse(url),
                        tag: MediaItem(
                          id: 'ayah_${_surahNumber}s_$_verseNumber',
                          title:
                              'سورة ${SurahNames.getFormattedName(_surahNumber)}',
                          artist: 'الآية $_verseNumber',
                          // artUri: Uri.parse(
                          //   'asset:///assets/icons/moon.png',
                          // ), // TODO: change app icon
                        ),
                      ),
                    );
                    await player.play();
                  } on PlayerInterruptedException {
                    // تم إيقاف المشغل من قبل المستخدم أو تغيير الآية، لا حاجة لإظهار خطأ
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "تعذر تشغيل الصوت. تحقق من اتصالك بالإنترنت.",
                          ),
                        ),
                      );
                    }
                  }
                },
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final marks = ref.watch(marksProvder);
              final isMarked = marks.any(
                (m) =>
                    m.surahNumber == _surahNumber &&
                    m.ayahNumber == _verseNumber,
              );

              return _actionButton(
                icon: isMarked
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_add_outlined,
                label: 'علامة',
                onTap: () async {
                  final notifier = ref.read(marksProvder.notifier);
                  if (!isMarked) {
                    await notifier.addMark(
                      Mark()
                        ..surahName = SurahNames.getFormattedName(_surahNumber)
                        ..pageNumber = _onPageChanged
                        ..surahNumber = _surahNumber
                        ..ayahNumber = _verseNumber,
                    );

                    if (!context.mounted) return;
                    _highlightAyah = false;
                    setState(() {});

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          backgroundColor: context.color.primary,
                          content: Row(
                            children: [
                              Icon(
                                Icons.bookmark_added_rounded,
                                color: context.color.onPrimary,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "تم حفظ الآية!",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.bold,
                                  color: context.color.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  } else {
                    await notifier.removeAyahMark(_surahNumber, _verseNumber);

                    if (!context.mounted) return;
                    _highlightAyah = false;
                    setState(() {});

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          backgroundColor: Colors.grey.shade800,
                          content: Row(
                            children: [
                              Icon(
                                Icons.bookmark_remove_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "تم إزالة العلامة",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: "Cairo",
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  }
                },
              );
            },
          ),
          _actionButton(
            icon: Icons.menu_book_rounded,
            label: 'تفسير',
            onTap: () {
              final books = ref.read(tafsserBooksProvider).value;
              String defaultBookId = 'ar.jalalayn';

              if (books != null && books.isNotEmpty) {
                final defaultBook = books.firstWhere(
                  (b) => b.isDownloaded,
                  orElse: () => books.first,
                );
                defaultBookId = defaultBook.id;
              }

              showTafsserModalBottom(
                context,
                ref,
                _surahNumber,
                _verseNumber,
                defaultBookId,
              );
            },
          ),
          _actionButton(
            icon: Icons.share_rounded,
            label: 'مشاركة',
            onTap: () async {
              final text = getVerse(
                _surahNumber,
                _verseNumber,
                verseEndSymbol: true,
              );
              final sharePlusInstance = SharePlus.instance;

              await sharePlusInstance.share(ShareParams(text: text));
            },
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22.sp, color: context.color.primary),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: context.color.onSurface,
              ),
            ),
          ],
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
                  : themeColor == FlexScheme.shadRed
                  ? const AssetImage("assets/images/rose_bg_banner.jpg")
                  : themeColor == FlexScheme.shadRose
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
                            ? effectiveTheme.headerFontSizeLarge + 10.sp
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

class AppAndBottomBar extends StatelessWidget {
  const AppAndBottomBar({
    super.key,
    required this.globalSurahNumber,
    required this.globalStartOfSurah,
  });

  final int globalSurahNumber;
  final int globalStartOfSurah;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: QuranPageAppBar(
        surahName: SurahNames.getFormattedName(globalSurahNumber),
        juzzNumber: getJuzNumber(globalSurahNumber, globalStartOfSurah),
        placeOfRevelation: getPlaceOfRevelation(globalSurahNumber),
        verseCount: getVerseCount(globalSurahNumber),
      ),
    );
  }
}
