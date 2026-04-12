import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/constants/routes.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/features/quran/data/models/mark.dart';
import 'package:noor_quran/features/quran/presentation/pages/quran_pages.dart';
import 'package:noor_quran/features/quran/presentation/providers/mark.dart';
import 'package:noor_quran/core/common/providers/theme_provider.dart';
import 'package:noor_quran/core/common/widgets/home/home_button.dart';
import 'package:noor_quran/features/pray_time/presentation/widgets/pray_times_container.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:noor_quran/core/common/widgets/home/next_prayer_card.dart';
import 'package:noor_quran/core/common/widgets/home/quick_adkar_strip.dart';
import 'package:noor_quran/core/common/widgets/home/reading_progress_card.dart';
import 'package:noor_quran/core/common/widgets/home/daily_verse_card.dart';
import 'package:noor_quran/core/common/providers/daily_content_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeProvider);
    final marksProvider = ref.watch(marksProvder);

    Mark? lastReadingPostion;
    if (marksProvider.isNotEmpty) {
      lastReadingPostion = marksProvider.last;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: BodyContent(
          colorScheme: colorScheme,
          themeMode: themeMode,
          lastReadingPostion: lastReadingPostion,
        ),
      ),
    );
  }
}

class BodyContent extends ConsumerWidget {
  // تم تحويله لـ ConsumerWidget لمراقبة الـ Providers
  const BodyContent({
    super.key,
    required this.colorScheme,
    required this.themeMode,
    required this.lastReadingPostion,
  });

  final ColorScheme colorScheme;
  final ThemeMode themeMode;
  final Mark? lastReadingPostion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = [
      const PrayTimesContainer(),
      const NextPrayerCard(),
      Material(
        surfaceTintColor: colorScheme.primary,
        shadowColor: themeMode == ThemeMode.light
            ? colorScheme.surface
            : colorScheme.primary,
        elevation: 2,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        color: colorScheme.surface,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 6.w),
                  Text(
                    AppLocalizations.of(context)!.main_categories,
                    style: TextStyle(
                      height: 1.h,
                      fontSize: context.witdthScreen * 0.058.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    // أضفت Expanded هنا ليعمل الـ Divider بشكل صحيح
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.r, right: 8.r),
                      child: Divider(color: colorScheme.primary, thickness: 2),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.only(bottom: 10.r, right: 10.r, left: 10.r),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 15,
                children: [
                  HomeButton(
                    text: AppLocalizations.of(context)!.quran_kareem,
                    iconImage: "assets/icons/quran.png", // TODO: change icon
                    color: context.color.primary,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.selectSurahPage);
                    },
                  ),
                  HomeButton(
                    text: "القرآن مُرتل",
                    iconImage: "assets/icons/voice.png", // TODO: change icon
                    color: context.color.primary,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.quranMoratal);
                    },
                  ),
                  HomeButton(
                    text: AppLocalizations.of(context)!.sunah,
                    iconImage: "assets/icons/quran2.png", // TODO: change icon
                    color: context.color.primary,
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.sunnahPage);
                    },
                  ),

                  // --- زر مواقيت الصلاة ---
                  HomeButton(
                    text: AppLocalizations.of(context)!.pray_times,
                    iconImage: "assets/icons/mosque.png", // TODO: change icon
                    color: context.color.primary,
                    onTap: () {
                      Navigator.of(context).pushNamed("/pray_time_page");
                    },
                  ),

                  // ----------------------------
                  HomeButton(
                    text: AppLocalizations.of(context)!.qebla_direction,
                    iconImage: "assets/icons/kaaba.png", // TODO: change icon
                    color: context.color.primary,
                    onTap: () {
                      Navigator.of(context).pushNamed("/qebla_page");
                    },
                  ),
                  HomeButton(
                    text: AppLocalizations.of(context)!.adkar_adia,
                    iconImage: "assets/icons/prayer.png", // TODO: change icon
                    color: context.color.primary,
                    onTap: () {
                      Navigator.of(context).pushNamed("/adkar_page");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 8.h),
      if (lastReadingPostion != null)
        // ... (كود الـ "آخر قراءة" يبقى كما هو) ...
        _buildLastReadingWidget(
          context,
          colorScheme,
          themeMode,
          lastReadingPostion!,
        ),

      // شريط التقدم الخاص بالقراءة
      const ReadingProgressCard(),
      // ويدجت أذكار سريعة
      const QuickAdkarStrip(),
      // ويدجت آية اليوم
      const DailyVerseCard(),
      SizedBox(height: 8.h),
      // دعاء اليوم
      TodayDuaa(colorScheme: colorScheme, themeMode: themeMode),
      SizedBox(height: 20.h),
    ];

    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: children,
        ),
      ),
    );
  }

  // دالة مساعدة لتنظيم كود الـ Last Reading
  Widget _buildLastReadingWidget(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeMode themeMode,
    Mark lastReadingPostion,
  ) {
    final isDark =
        themeMode == ThemeMode.dark ||
        Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            AppLocalizations.of(context)!.last_reading_surah,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: "Cairo",
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12.h),

          // Card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        colorScheme.primary.withValues(alpha: 0.7),
                        colorScheme.primary.withValues(alpha: 0.4),
                      ]
                    : [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(
                    alpha: isDark ? 0.2 : 0.3,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuranPages(
                      highlightVerse: lastReadingPostion.ayahNumber,
                      highlightSurah: lastReadingPostion.surahNumber,
                      pageNumber: lastReadingPostion.pageNumber,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.bookmark, color: Colors.white),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "سُورَةَ ${lastReadingPostion.surahName}",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontFamily: "Amiri",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "${AppLocalizations.of(context)!.page_number} ${lastReadingPostion.pageNumber}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: "Cairo",
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodayDuaa extends ConsumerWidget {
  const TodayDuaa({
    super.key,
    required this.colorScheme,
    required this.themeMode,
  });
  final ColorScheme colorScheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duaaAsync = ref.watch(dailyDuaaProvider);

    return Material(
      surfaceTintColor: colorScheme.primary,
      shadowColor: themeMode == ThemeMode.light
          ? colorScheme.surface
          : colorScheme.primary,
      elevation: 2,
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(20.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 2.sp,
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0.r),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.volunteer_activism_rounded,
                      color: colorScheme.primary,
                      size: 22.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "دعاء اليوم",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 2.sp,
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
            child: duaaAsync.when(
              data: (duaaText) => Column(
                children: [
                  Text(
                    "« $duaaText »",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: "Tajawal",
                      height: 1.6,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        icon: Icons.copy_rounded,
                        label: "نسخ",
                        color: colorScheme.primary,
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: "$duaaText\n\nمن تطبيق نور البيان",
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("تم نسخ الدعاء"),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.sp, color: color.withValues(alpha: 0.7)),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: "Cairo",
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
