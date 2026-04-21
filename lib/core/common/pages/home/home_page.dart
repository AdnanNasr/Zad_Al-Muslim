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
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:noor_quran/core/common/widgets/home/next_prayer_card.dart';
import 'package:noor_quran/core/common/widgets/home/quick_adkar_strip.dart';
import 'package:noor_quran/core/common/widgets/home/reading_progress_card.dart';
import 'package:noor_quran/core/common/widgets/home/daily_verse_card.dart';
import 'package:noor_quran/core/common/providers/daily_content_provider.dart';
import 'package:noor_quran/core/common/constants/surah_names.dart';

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

  bool showCopiedMessage = false;

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
      headerWidget(context),
      AnimationConfiguration.synchronized(
        duration: Duration(milliseconds: 700),
        child: SlideAnimation(
          horizontalOffset: 40,
          child: const NextPrayerCard(),
        ),
      ),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.widgets_rounded,
                          color: context.color.primary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          AppLocalizations.of(context)!.main_categories,
                          style: TextStyle(
                            height: 1.h,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
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

    return Column(children: children);
  }

  Widget headerWidget(BuildContext context) {
    final primaryColor = context.color.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withValues(alpha: 0.85),
            HSLColor.fromColor(primaryColor)
                .withLightness(
                  (HSLColor.fromColor(primaryColor).lightness - 0.1).clamp(
                    0.0,
                    1.0,
                  ),
                )
                .toColor(),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Stack(
        children: [
          // --- عناصر زخرفية ---
          Positioned(
            top: -30.r,
            right: -30.r,
            child: Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -20.r,
            left: -20.r,
            child: Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          // --- المحتوى ---
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(
                top: 12.h,
                bottom: 20.h,
                right: 20.w,
                left: 20.w,
              ),
              child: Row(
                children: [
                  // --- الأيقونة ---
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Icon(
                      _getGreetingIcon(),
                      color: Colors.white,
                      size: 26.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  // --- النصوص ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal",
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _getFormattedDate(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: "Cairo",
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // --- زر الإعدادات ---
                  Material(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.settingsPage),
                      child: Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Icon(
                          Icons.settings_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Icon(Icons.bookmark_added, color: context.color.primary),
                SizedBox(width: 8.w),
                Text(
                  AppLocalizations.of(context)!.last_reading_surah,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
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
                                "سورة ${SurahNames.getFormattedName(lastReadingPostion.surahNumber ?? 1)}",
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "صباح الخير ☀️";
    if (hour < 18) return "مساء النور ✨";
    return "مساء الخير 🌙";
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 6) return Icons.bedtime_rounded;
    if (hour < 12) return Icons.wb_sunny_rounded;
    if (hour < 18) return Icons.wb_twilight_rounded;
    return Icons.nightlight_round;
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    // يوم الأسبوع بالعربي
    final dayNames = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    final dayName = dayNames[now.weekday - 1];
    final month = months[now.month - 1];
    return "$dayName، ${now.day} $month ${now.year}";
  }
}

class TodayDuaa extends ConsumerStatefulWidget {
  const TodayDuaa({
    super.key,
    required this.colorScheme,
    required this.themeMode,
  });
  final ColorScheme colorScheme;
  final ThemeMode themeMode;

  @override
  ConsumerState<TodayDuaa> createState() => _TodayDuaaState();
}

class _TodayDuaaState extends ConsumerState<TodayDuaa> {
  bool _showCopiedMessage = false;

  @override
  Widget build(BuildContext context) {
    final duaaAsync = ref.watch(dailyDuaaProvider);

    return Material(
      surfaceTintColor: widget.colorScheme.primary,
      shadowColor: widget.themeMode == ThemeMode.light
          ? widget.colorScheme.surface
          : widget.colorScheme.primary,
      elevation: 2,
      color: widget.colorScheme.surface,
      borderRadius: BorderRadius.circular(20.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 2.sp,
                  color: widget.colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0.r),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.volunteer_activism_rounded,
                      color: widget.colorScheme.primary,
                      size: 22.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "دعاء اليوم",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.bold,
                        color: widget.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 2.sp,
                  color: widget.colorScheme.primary.withValues(alpha: 0.1),
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
                      color: widget.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 70.w,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _showCopiedMessage ? 1.0 : 0.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: context.color.primary,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              "تم النسخ",
                              style: TextStyle(
                                color: context.color.onPrimary,
                                fontSize: 12.sp,
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      _buildActionButton(
                        icon: Icons.copy_rounded,
                        label: "نسخ",
                        color: widget.colorScheme.primary,
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: "$duaaText\n\nمن تطبيق نور البيان",
                            ),
                          );
                          _showCopiedMessage = true;
                          setState(() {});
                          Future.delayed(
                            const Duration(seconds: 1, milliseconds: 500),
                            () {
                              if (mounted) {
                                setState(() => _showCopiedMessage = false);
                              }
                            },
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
