import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/extensions/sizes_ext.dart';
import 'package:noor_quran/l10n/app_localizations.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';
import 'package:noor_quran/view_models/models/db/islamic/mark.dart';
import 'package:noor_quran/view_models/models/db/islamic/quran_models.dart';
import 'package:noor_quran/view_models/providers/quran_providers/mark.dart';
import 'package:noor_quran/view_models/providers/theme_provider.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';
import 'package:noor_quran/views/pages/quran_more_menu.dart';
import 'package:noor_quran/views/pages/quran_pages.dart';
import 'package:noor_quran/views/pages/search_page.dart';
import 'package:noor_quran/views/pages/settings_page.dart';
import 'package:noor_quran/views/widgets/marks_dialog.dart';
import 'package:noor_quran/views/widgets/quran_overlay_managar.dart';

class QuranPageAppBar extends ConsumerStatefulWidget {
  final int? lastReadingPostion;
  const QuranPageAppBar({super.key, this.lastReadingPostion});

  @override
  ConsumerState<QuranPageAppBar> createState() => _QuranPagesState();
}

class _QuranPagesState extends ConsumerState<QuranPageAppBar>
    with SingleTickerProviderStateMixin {
  bool isFullscreen = true;
  bool didJump = false;

  late final AnimationController _animationController;

  final PageController _pageController = PageController(initialPage: 0);

  QuranOverlayManager? _overlayManager;
  bool isVisible = false;
  int currentPage = 0;

  List<QuranPage> pages = [];
  bool isLoading = true;

  int pageIndex = 0;

  String localSelectedSurah = 'الفاتحة';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadQuranPages();
  }

  void _setIsVisible(bool visible) {
    if (!mounted) {
      setState(() {
        isVisible = visible;
      });
    }
  }

  void _updateCurrentSurah(String surahName) {
    if (mounted) {
      setState(() {
        localSelectedSurah = surahName;
      });

      _overlayManager?.localSelectedSurah = surahName;
    }
  }

  Future<void> _loadQuranPages() async {
    final isar = await IsarDb.initDatabase();
    final dbPages = await isar.quranPages.where().findAll();

    if (dbPages.isEmpty) {
      AppLogger.logger.e("لا يوجد بيانات في قاعدة بيانات Isar");
    }

    if (mounted) {
      setState(() {
        pages = dbPages;
        isLoading = false;

        if (pages.isNotEmpty && pages[0].ayahs.isNotEmpty) {
          localSelectedSurah = pages[0].ayahs.first.surahName;
        }
      });

      _overlayManager = QuranOverlayManager(
        pageController: _pageController,
        pages: pages,
        updateCurrentSurah: _updateCurrentSurah,
        localSelectedSurah: localSelectedSurah,
        setIsVisible: _setIsVisible,
      );
    }
  }

  bool isMarked = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final internalBackgroundColor = themeMode == ThemeMode.light
        ? const Color(0xFFF8F3E7)
        : const Color(0xFF2B2A28);

    final markMethods = ref.read(marksProvder.notifier);

    if (isLoading || _overlayManager == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pages.isEmpty) {
      return const Center(
        child: Text(
          "هناك خطأ في قاعدة البيانات، يرجى إعادة فتح التطبيق مرة اخرى.",
        ),
      );
    }

    final markExists = ref.watch(
      markExistsProvider(pages[currentPage].pageNumber),
    );

    final surahNames = pages[currentPage].ayahs
        .map((a) => a.surahName)
        .toSet()
        .toList();

    final surahTitle = surahNames.join("  ");

    if (!didJump && widget.lastReadingPostion != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(widget.lastReadingPostion! - 1);
        }
      });
      didJump = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: internalBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: context.witdthScreen,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.go_back,
                          onPressed: () {
                            _overlayManager!
                                .removeOverly(); // remove overlay if it is open before go back
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            fontWeight: FontWeight.bold,

                            size: context.witdthScreen * 0.055,
                          ),
                        ),
                        Text(
                          surahTitle,
                          style: TextStyle(
                            fontFamily: "Amiri",
                            fontSize: context.witdthScreen * 0.045,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          style: ButtonStyle(
                            iconColor: WidgetStatePropertyAll(
                              markExists.when(
                                data: (exists) => exists
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.primary,
                                loading: () => Colors.grey,
                                error: (_, __) => Colors.red,
                              ),
                            ),
                          ),
                          tooltip: markExists.when(
                            data: (exists) => exists
                                ? "ازالة العلامة"
                                : AppLocalizations.of(
                                    context,
                                  )?.save_reading_place,
                            error: (_, _) => null,
                            loading: () => null,
                          ),
                          onPressed: () async {
                            final page = pages[currentPage];
                            final surahName = page.ayahs.isNotEmpty
                                ? page.ayahs.first.surahName
                                : "—";

                            final exists = await markMethods.exists(
                              page.pageNumber,
                            );

                            if (exists) {
                              await markMethods.removeMark(page.pageNumber);
                              page.saved = false;
                            } else {
                              final mark = Mark()
                                ..pageNumber = page.pageNumber
                                ..surahName = surahName
                                ..date = DateTime.now();

                              await markMethods.addMark(mark);
                              page.saved = true;
                            }

                            setState(() {});

                            ref.invalidate(markExistsProvider);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                shape: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(milliseconds: 700),
                                content: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    page.saved
                                        ? AppLocalizations.of(
                                            context,
                                          )!.mark_added
                                        : AppLocalizations.of(
                                            context,
                                          )!.mark_removed,
                                    style: TextStyle(
                                      fontSize: context.witdthScreen * 0.043,
                                      fontFamily: "Tajawal",
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: markExists.when(
                            data: (exists) => Icon(
                              exists ? Icons.bookmark : Icons.bookmark_border,
                              size: context.witdthScreen * 0.07,
                            ),
                            loading: () => Icon(
                              Icons.bookmark_border,
                              size: context.witdthScreen * 0.07,
                            ),
                            error: (_, __) => Icon(
                              Icons.error,
                              size: context.witdthScreen * 0.07,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: AppLocalizations.of(context)!.more_options,
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            if (QuranOverlayManager.isVisible) {
                              _overlayManager!.removeOverly();
                            }
                            showModalBottomSheet(
                              constraints: BoxConstraints(minHeight: 200.h),

                              context: context,
                              builder: (context) {
                                return QuranMoreMenu(
                                  menuItems: [
                                    MenuItem(
                                      icon: Icons.settings,
                                      label: AppLocalizations.of(
                                        context,
                                      )!.app_settings,
                                      backgroundColor: Colors.teal.shade700,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SettingsPage(),
                                          ),
                                        );
                                      },
                                    ),
                                    MenuItem(
                                      icon: Icons.bookmark,
                                      label: AppLocalizations.of(
                                        context,
                                      )!.last_reading,
                                      backgroundColor: Colors.cyan.shade700,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        showModalBottomSheet(
                                          context: context,
                                          enableDrag: true,
                                          showDragHandle: true,
                                          isScrollControlled: true,
                                          constraints: BoxConstraints(
                                            minHeight:
                                                context.heightScreen / 2.h,
                                            maxHeight:
                                                context.heightScreen * 0.8.w,
                                          ),
                                          builder: (context) {
                                            return MarksDialog(
                                              pageController: _pageController,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    MenuItem(
                                      icon: Icons.search,
                                      label: AppLocalizations.of(
                                        context,
                                      )!.search_in_quran,
                                      backgroundColor: Colors.indigo.shade700,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        showModalBottomSheet(
                                          context: context,
                                          showDragHandle: true,
                                          sheetAnimationStyle:
                                              const AnimationStyle(
                                                duration: Duration(
                                                  milliseconds: 500,
                                                ),
                                              ),
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          builder: (context) {
                                            return SearchPage(
                                              pageController: _pageController,
                                              pages: pages,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    MenuItem(
                                      icon: Icons.widgets,
                                      label: AppLocalizations.of(
                                        context,
                                      )!.controll_panel,
                                      backgroundColor:
                                          Colors.lightBlue.shade700,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _overlayManager!.toggleOverly(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            QuranPages(
              pageController: _pageController,
              pages: pages,
              togglePages: (value) {
                setState(() {
                  currentPage = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
