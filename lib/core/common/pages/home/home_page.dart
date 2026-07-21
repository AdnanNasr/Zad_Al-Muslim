import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/core/common/widgets/home/dashboard_card.dart';
import 'package:zad_al_muslim/core/common/widgets/home/home_header.dart';
import 'package:zad_al_muslim/core/common/widgets/home/today_duaa.dart';
import 'package:zad_al_muslim/core/constants/routes.dart';
import 'package:zad_al_muslim/core/constants/shared_pref_keys.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/mark.dart';
import 'package:zad_al_muslim/core/common/widgets/home/next_prayer_card.dart';
import 'package:zad_al_muslim/core/common/widgets/home/quick_adkar_strip.dart';
import 'package:zad_al_muslim/core/common/widgets/home/reading_progress_card.dart';
import 'package:zad_al_muslim/core/constants/surah_names.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marks = ref.watch(marksProvder);

    final Mark? lastReadingPosition = marks.isNotEmpty ? marks.last : null;

    final sections = <Widget>[
      const RepaintBoundary(child: HomeHeader()),
      const RepaintBoundary(child: NextPrayerCard()),
      const RepaintBoundary(child: QuickAdkarStrip()),
      RepaintBoundary(
        child: PrimarySectionWidget(lastReadingPosition: lastReadingPosition),
      ),
      const RepaintBoundary(child: ReadingProgressCard()),
      SizedBox(height: 8.h),
      const RepaintBoundary(child: TodayDuaa()),
      SizedBox(height: MediaQuery.paddingOf(context).bottom + 90.h),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverList.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              return sections[index];
            },
          ),
        ],
      ),
    );
  }
}

class PrimarySectionWidget extends ConsumerWidget {
  const PrimarySectionWidget({super.key, required this.lastReadingPosition});

  final Mark? lastReadingPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;

    final hasLastReading = lastReadingPosition != null;

    final quranLabel = hasLastReading ? 'آخر قراءة' : 'ابدأ رحلتك';

    final quranValue = hasLastReading
        ? 'سورة ${SurahNames.getFormattedName(lastReadingPosition!.surahNumber ?? 1)} • الصفحة ${lastReadingPosition!.pageNumber}'
        : 'ابدأ رحلتك مع القرآن الكريم';

    final quranFooter = hasLastReading ? 'متابعة القراءة' : 'ابدأ القراءة';

    final adkarContent = _getAdkarContent();

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context),

          SizedBox(height: 14.h),

          DashboardCard(
            title: localizations.quran_kareem,
            label: quranLabel,
            value: quranValue,
            footer: quranFooter,
            iconImage: 'assets/icons/quran.png',
            accentColor: colorScheme.primary,
            size: DashboardCardSize.large,
            onTap: () => _openQuran(context),
          ),

          SizedBox(height: 12.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'القرآن المُرتل',
                  label: 'استماع وتحميل',
                  value: 'اختر قارئك المفضل',
                  footer: 'فتح المشغل',
                  iconImage: 'assets/icons/voice.png',
                  accentColor: colorScheme.tertiary,
                  onTap: () => _openQuranMoratal(context),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: DashboardCard(
                  title: localizations.adkar_adia,
                  label: adkarContent.label,
                  value: adkarContent.value,
                  footer: 'فتح الأذكار',
                  iconImage: 'assets/icons/prayer.png',
                  accentColor: colorScheme.secondary,
                  onTap: () {
                    Navigator.of(context).pushNamed('/adkar_page');
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DashboardCard(
                  title: localizations.qebla_direction,
                  label: 'تحديد الاتجاه',
                  value: 'البوصلة جاهزة',
                  footer: 'فتح القبلة',
                  iconImage: 'assets/icons/kaaba.png',
                  accentColor: colorScheme.tertiary,
                  onTap: () {
                    Navigator.of(context).pushNamed('/qebla_page');
                  },
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: DashboardCard(
                  title: localizations.sunah,
                  label: 'السنة النبوية',
                  value: 'أحاديث وهدي نبوي',
                  footer: 'استكشف السنة',
                  iconImage: 'assets/icons/quran2.png',
                  accentColor: colorScheme.primary,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.sunnahPage);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openQuran(BuildContext context) {
    final position = lastReadingPosition;

    if (position == null) {
      Navigator.of(context).pushNamed(Routes.selectSurahPage);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuranPages(
          highlightVerse: position.ayahNumber,
          highlightSurah: position.surahNumber,
          pageNumber: position.pageNumber,
        ),
      ),
    );
  }

  _AdkarCardContent _getAdkarContent() {
    final hour = DateTime.now().hour;

    if (hour >= 4 && hour < 12) {
      return const _AdkarCardContent(
        label: 'ورد الصباح',
        value: 'أذكار الصباح',
      );
    }

    if (hour >= 12 && hour < 18) {
      return const _AdkarCardContent(
        label: 'وردك اليومي',
        value: 'الأذكار اليومية',
      );
    }

    return const _AdkarCardContent(label: 'ورد المساء', value: 'أذكار المساء');
  }
}

class _AdkarCardContent {
  const _AdkarCardContent({required this.label, required this.value});

  final String label;
  final String value;
}

Widget _buildSectionHeader(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    children: [
      Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.dashboard_customize_rounded,
          size: 20.sp,
          color: colorScheme.onPrimaryContainer,
        ),
      ),

      SizedBox(width: 10.w),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خدماتك اليومية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                height: 1.3,
              ),
            ),

            SizedBox(height: 1.h),

            Text(
              'القرآن والأذكار والسنة بين يديك',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Future<void> _openQuranMoratal(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  final permissionShownCount =
      prefs.getInt(SharedPrefKeys.batteryPermissionKey) ?? 0;

  final status = await Permission.ignoreBatteryOptimizations.status;

  if (!status.isDenied) {
    await prefs.remove(SharedPrefKeys.batteryPermissionKey);
  }

  if (permissionShownCount < 2 && status.isDenied) {
    if (!context.mounted) return;

    await Permission.ignoreBatteryOptimizations.request();

    await prefs.setInt(
      SharedPrefKeys.batteryPermissionKey,
      permissionShownCount + 1,
    );
  }

  if (!context.mounted) return;

  Navigator.pushNamed(context, Routes.quranMoratal);
}

class ComingPrayWidget extends StatelessWidget {
  const ComingPrayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NextPrayerCard();
  }
}
