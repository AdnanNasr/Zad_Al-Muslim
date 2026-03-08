import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/core/database/isar_db.dart';
import 'package:noor_quran/features/quran/data/models/mark.dart';
import 'package:noor_quran/features/quran/data/models/quran_models.dart';
import 'package:noor_quran/features/quran/presentation/providers/mark.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_more_menu.dart';
import 'package:noor_quran/features/quran/presentation/pages/quran_pages.dart';
import 'package:noor_quran/features/quran/presentation/pages/search_page.dart';
import 'package:noor_quran/features/settings/presentation/pages/settings_page.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/features/quran/presentation/widgets/marks_dialog.dart';
import 'package:noor_quran/features/quran/presentation/widgets/quran_overlay_managar.dart';

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
  return Scaffold(
    appBar: CustomAppBar(
      title: "",
      center: false,
      profile: false,
    ),
    body: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.color.primary,
            context.color.primary.withValues(alpha: .7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة توضح وجود مشكلة في البيانات أو المحتوى
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.storage_rounded,
              size: 70.r,
              color: Colors.white.withValues(alpha: .8),
            ),
          ),
          SizedBox(height: 30.h),
          
          // نص التنبيه الرئيسي
          Text(
            "تنبيه بخصوص البيانات",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "Cairo",
            ),
          ),
          SizedBox(height: 15.h),
          
          // نص الشرح
          Text(
            "لم نتمكن من العثور على الصفحات المطلوبة. قد يكون هناك خلل مؤقت في قاعدة البيانات.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withValues(alpha: .9),
              fontFamily: "Cairo",
              height: 1.5, // لزيادة المسافة بين الأسطر وجعله مريحاً للعين
            ),
          ),
          SizedBox(height: 30.h),
          
          // إرشاد للمستخدم مع لمسة جمالية
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  "يرجى إعادة فتح التطبيق مرة أخرى",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontFamily: "Cairo",
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
