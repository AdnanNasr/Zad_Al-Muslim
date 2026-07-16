import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/core/common/widgets/home/today_duaa.dart';
import 'package:zad_al_muslim/core/constants/routes.dart';
import 'package:zad_al_muslim/core/constants/shared_pref_keys.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/pray_times_provider.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/mark.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/common/widgets/home/home_button.dart';
import 'package:zad_al_muslim/core/common/widgets/home/next_prayer_card.dart';
import 'package:zad_al_muslim/core/common/widgets/home/quick_adkar_strip.dart';
import 'package:zad_al_muslim/core/common/widgets/home/reading_progress_card.dart';
import 'package:zad_al_muslim/core/constants/surah_names.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  bool showCopiedMessage = false;

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
      backgroundColor: context.color.primary.withValues(alpha: .07),
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
      headerWidget(context, themeMode),

      const ComingPrayWidget(),

      const QuickAdkarStrip(),

      PrimarySectionWidget(colorScheme: colorScheme, themeMode: themeMode),

      SizedBox(height: 8.h),
      if (lastReadingPostion != null)
        _buildLastReadingWidget(
          context,
          colorScheme,
          themeMode,
          lastReadingPostion!,
        ),

      const ReadingProgressCard(),

      SizedBox(height: 8.h),

      TodayDuaa(colorScheme: colorScheme, themeMode: themeMode),
      SizedBox(height: 100.h),
    ];

    return Column(children: children);
  }

  Widget headerWidget(BuildContext context, ThemeMode themeMode) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.h,
          bottom: 10.h,
          right: 14.w,
          left: 14.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "زاد المسلم",
                            style: TextStyle(
                              fontSize: 23.sp,
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.bold,
                              color: context.color.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Image.asset(
                          "assets/images/icon-512.png",
                          width: 50.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: context.color.primary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: context.color.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.brightness_2_outlined,
                                size: 16.sp,
                                color: context.color.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                _getFormattedDateHijri(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.w700,
                                  color: context.color.onSurface,
                                ),
                              ),
                            ],
                          ),

                          VerticalDivider(
                            color: context.color.outlineVariant,
                            thickness: 1,
                            width: 24.w,
                            indent: 2,
                            endIndent: 2,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 15.sp,
                                color: context.color.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                _getFormattedDate(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: "Cairo",
                                  fontWeight: FontWeight.w700,
                                  color: context.color.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildLastReadingWidget(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeMode themeMode,
    Mark lastReadingPostion,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                const Icon(Icons.bookmark_added, color: Colors.orange),
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

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: context.color.primary.withValues(alpha: .08),
              border: Border.all(
                color: context.color.primary.withValues(alpha: .2),
              ),
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
                              color: context.color.primary.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bookmark,
                              color: context.color.primary,
                            ),
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
                                  color: themeMode == ThemeMode.dark
                                      ? context.color.onSurface
                                      : context.color.scrim,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "${AppLocalizations.of(context)!.page_number} ${lastReadingPostion.pageNumber}",
                                style: TextStyle(
                                  fontSize: 14.sp,

                                  fontWeight: FontWeight.w600,
                                  color: context.color.secondary.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: context.color.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: context.color.primary,
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

  String _getFormattedDate() {
    final now = DateTime.now();

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

  String _getFormattedDateHijri() {
    HijriCalendar.setLocal("ar");
    final hijriDate = HijriCalendar.now();
    return "${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear}";
  }
}

class PrimarySectionWidget extends ConsumerWidget {
  const PrimarySectionWidget({
    super.key,
    required this.colorScheme,
    required this.themeMode,
  });

  final ColorScheme colorScheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color primaryColor = context.color.primary;
    return Material(
      surfaceTintColor: colorScheme.primary,
      shadowColor: themeMode == ThemeMode.light
          ? colorScheme.surface
          : colorScheme.primary,
      elevation: 0,
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
                      const Icon(Icons.widgets_rounded, color: Colors.orange),
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
            child: AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) {
                final List<Widget> buttons = [
                  HomeButton(
                    text: AppLocalizations.of(context)!.quran_kareem,
                    description: "قراءة وتلاوة",
                    iconImage: "assets/icons/quran.png",
                    color: primaryColor,
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.selectSurahPage),
                  ),
                  HomeButton(
                    text: "القرآن مُرتل",
                    description: "استماع وتحميل",
                    iconImage: "assets/icons/voice.png",
                    color: primaryColor,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();

                      final int permissionShownCount =
                          prefs.getInt(SharedPrefKeys.batteryPermissionKey) ??
                          0;

                      var status =
                          await Permission.ignoreBatteryOptimizations.status;

                      if (!status.isDenied) {
                        await prefs.remove(SharedPrefKeys.batteryPermissionKey);
                      }

                      if (permissionShownCount < 2 && status.isDenied) {
                        if (context.mounted) {
                          await Permission.ignoreBatteryOptimizations.request();
                          await prefs.setInt(
                            SharedPrefKeys.batteryPermissionKey,
                            permissionShownCount + 1,
                          );
                        }
                      }

                      if (!context.mounted) return;
                      Navigator.pushNamed(context, Routes.quranMoratal);
                    },
                  ),
                  HomeButton(
                    text: AppLocalizations.of(context)!.sunah,
                    description: "أحاديث شريفة",
                    iconImage: "assets/icons/quran2.png",
                    color: primaryColor,
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.sunnahPage),
                  ),
                  HomeButton(
                    text: AppLocalizations.of(context)!.pray_times,
                    description: "أوقات الأذان",
                    iconImage: "assets/icons/mosque.png",
                    color: primaryColor,
                    onTap: () async {
                      final selectedDateTiem = await Navigator.of(
                        context,
                      ).pushNamed("/pray_time_page");
                      await Future.delayed(const Duration(milliseconds: 250));
                      if (selectedDateTiem != DateTime.now()) {
                        ref.read(selectedDateProvider.notifier).state =
                            DateTime.now();
                      }
                    },
                  ),
                  HomeButton(
                    text: AppLocalizations.of(context)!.qebla_direction,
                    description: "بوصلة دقيقة",
                    iconImage: "assets/icons/kaaba.png",
                    color: primaryColor,
                    onTap: () => Navigator.of(context).pushNamed("/qebla_page"),
                  ),
                  HomeButton(
                    text: AppLocalizations.of(context)!.adkar_adia,
                    description: "حصن المسلم",
                    iconImage: "assets/icons/prayer.png",
                    color: primaryColor,
                    onTap: () => Navigator.of(context).pushNamed("/adkar_page"),
                  ),
                ];

                return buttons[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ComingPrayWidget extends StatelessWidget {
  const ComingPrayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NextPrayerCard();
  }
}
