import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/providers/home_clock_provider.dart';
import 'package:zad_al_muslim/core/common/widgets/home/home_header.dart';
import 'package:zad_al_muslim/core/common/widgets/home/today_duaa.dart';
import 'package:zad_al_muslim/core/constants/routes.dart';
import 'package:zad_al_muslim/core/l10n/app_localizations.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:zad_al_muslim/core/common/widgets/home/next_prayer_card.dart';
import 'package:zad_al_muslim/core/common/widgets/home/quick_adkar_strip.dart';
import 'package:zad_al_muslim/core/common/widgets/home/reading_progress_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(homeClockProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      const HomeHeader(),
      const NextPrayerCard(),
      ReadingProgressCard(onTap: (mark) => _openQuran(context, mark)),
      const PrimarySectionWidget(),
      const QuickAdkarStrip(),
      SizedBox(height: 8.h),
      const TodayDuaa(),
      SizedBox(height: MediaQuery.paddingOf(context).bottom + 90.h),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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

  void _openQuran(BuildContext context, Mark? position) {
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
}

class PrimarySectionWidget extends ConsumerWidget {
  const PrimarySectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;
    final now = ref.watch(homeClockProvider).value ?? DateTime.now();
    final adkarContent = _getAdkarContent(now);

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context),

          SizedBox(height: 14.h),

          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 12.w) / 2;
              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  _ServiceTile(
                    width: tileWidth,
                    title: 'القرآن المُرتل',
                    subtitle: 'استماع وتحميل',
                    iconImage: 'assets/icons/voice.png',
                    accentColor: colorScheme.primary,
                    onTap: () => _openQuranMoratal(context),
                  ),
                  _ServiceTile(
                    width: tileWidth,
                    title: localizations.adkar_adia,
                    subtitle: adkarContent.value,
                    iconImage: 'assets/icons/prayer.png',
                    accentColor: colorScheme.tertiary,
                    onTap: () {
                      Navigator.of(context).pushNamed('/adkar_page');
                    },
                  ),
                  _ServiceTile(
                    width: tileWidth,
                    title: localizations.qebla_direction,
                    subtitle: 'تحديد الاتجاه',
                    iconImage: 'assets/icons/kaaba.png',
                    accentColor: colorScheme.secondary,
                    onTap: () {
                      Navigator.of(context).pushNamed('/qebla_page');
                    },
                  ),
                  _ServiceTile(
                    width: tileWidth,
                    title: localizations.sunah,
                    subtitle: 'أحاديث وهدي نبوي',
                    iconImage: 'assets/icons/quran2.png',
                    accentColor: colorScheme.primary,
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.sunnahPage);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  _AdkarCardContent _getAdkarContent(DateTime now) {
    final hour = now.hour;

    if (hour >= 4 && hour < 12) {
      return const _AdkarCardContent('أذكار الصباح');
    }

    if (hour >= 12 && hour < 18) {
      return const _AdkarCardContent('الأذكار اليومية');
    }

    return const _AdkarCardContent('أذكار المساء');
  }
}

class _AdkarCardContent {
  const _AdkarCardContent(this.value);

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
  await Navigator.pushNamed(context, Routes.quranMoratal);
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.width,
    required this.title,
    required this.subtitle,
    required this.iconImage,
    required this.accentColor,
    required this.onTap,
  });

  final double width;
  final String title;
  final String subtitle;
  final String iconImage;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: '$title، $subtitle',
      child: SizedBox(
        width: width,
        child: Material(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Ink(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: accentColor.withValues(alpha: 0.16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    child: Image.asset(
                      iconImage,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.widgets_rounded,
                        color: accentColor,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 11.h),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 18.sp,
                    color: accentColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
