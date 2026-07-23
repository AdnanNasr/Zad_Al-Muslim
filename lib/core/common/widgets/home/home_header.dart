import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zad_al_muslim/core/common/providers/home_clock_provider.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = ref.watch(homeClockProvider).value ?? DateTime.now();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 6.h),
        child: Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(26.r),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _HeaderContent(now: now)),

                    SizedBox(width: 14.w),

                    const _AppLogoButton(),
                  ],
                ),

                SizedBox(height: 12.h),

                _DatesRow(now: now),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),

            SizedBox(width: 7.w),

            Flexible(
              child: Text(
                _getGreeting(now),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 5.h),

        Text(
          'زاد المسلم',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            height: 1.25,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          _getDailyMessage(now),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _AppLogoButton extends StatelessWidget {
  const _AppLogoButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: 'عن تطبيق زاد المسلم ومشاركته',
      child: Tooltip(
        message: 'عن التطبيق',
        child: Material(
          color: colorScheme.primaryContainer.withValues(alpha: 0.40),
          borderRadius: BorderRadius.circular(16.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              _showBehindScenesDialog(context);
            },
            borderRadius: BorderRadius.circular(16.r),
            splashColor: colorScheme.primary.withValues(alpha: 0.10),
            highlightColor: colorScheme.primary.withValues(alpha: 0.05),
            child: Container(
              width: 50.r,
              height: 50.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: colorScheme.primary.withValues(
                    alpha: isDark ? 0.24 : 0.15,
                  ),
                ),
              ),
              child: Image.asset(
                'assets/images/icon-512.png',
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) {
                  return Icon(
                    Icons.menu_book_rounded,
                    size: 26.sp,
                    color: colorScheme.primary,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DatesRow extends StatelessWidget {
  const _DatesRow({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldStack = constraints.maxWidth < 310;

        if (shouldStack) {
          return Column(
            children: [
              _DateItem(
                icon: Icons.dark_mode_outlined,
                label: 'التاريخ الهجري',
                text: _getFormattedHijriDate(now),
                accent: _HeaderDateAccent.primary,
              ),

              SizedBox(height: 8.h),

              _DateItem(
                icon: Icons.calendar_today_rounded,
                label: 'التاريخ الميلادي',
                text: _getFormattedGregorianDate(now),
                accent: _HeaderDateAccent.secondary,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _DateItem(
                icon: Icons.dark_mode_outlined,
                label: 'الهجري',
                text: _getFormattedHijriDate(now),
                accent: _HeaderDateAccent.primary,
              ),
            ),

            SizedBox(width: 8.w),

            Expanded(
              child: _DateItem(
                icon: Icons.calendar_today_rounded,
                label: 'الميلادي',
                text: _getFormattedGregorianDate(now),
                accent: _HeaderDateAccent.secondary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DateItem extends StatelessWidget {
  const _DateItem({
    required this.icon,
    required this.label,
    required this.text,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String text;
  final _HeaderDateAccent accent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final accentColor = switch (accent) {
      _HeaderDateAccent.primary => colorScheme.primary,
      _HeaderDateAccent.secondary => colorScheme.secondary,
    };

    return Container(
      constraints: BoxConstraints(minHeight: 48.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(icon, size: 16.sp, color: accentColor),
          ),

          SizedBox(width: 9.w),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _HeaderDateAccent { primary, secondary }

String _getGreeting(DateTime now) {
  final hour = now.hour;

  if (hour >= 4 && hour < 12) {
    return 'صباح مبارك';
  }

  if (hour >= 12 && hour < 17) {
    return 'نهارك مبارك';
  }

  if (hour >= 17 && hour < 22) {
    return 'مساء مبارك';
  }

  return 'السلام عليكم ورحمة الله';
}

String _getDailyMessage(DateTime now) {
  final hour = now.hour;

  if (hour >= 4 && hour < 10) {
    return 'ابدأ يومك بذكر الله وتلاوة كتابه';
  }

  if (hour >= 10 && hour < 16) {
    return 'رفيقك اليومي للقرآن والأذكار';
  }

  if (hour >= 16 && hour < 21) {
    return 'اختم يومك بما يقربك إلى الله';
  }

  return 'اجعل ذكر الله آخر ما تختم به يومك';
}

String _getFormattedGregorianDate(DateTime now) {
  const dayNames = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  const months = [
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

  return '$dayName، ${now.day} $month ${now.year}';
}

String _getFormattedHijriDate(DateTime now) {
  HijriCalendar.setLocal('ar');

  final hijriDate = HijriCalendar.fromDate(now);

  return '${hijriDate.hDay} '
      '${hijriDate.longMonthName} '
      '${hijriDate.hYear}';
}

Future<void> _showBehindScenesDialog(BuildContext context) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(
            color: isDark ? colorScheme.outlineVariant : Colors.transparent,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(22.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: colorScheme.primary,
                  size: 30.sp,
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                'خلف كواليس التطبيق',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 12.h),

              Text(
                'خلف هذه الشاشة البسيطة والسطور البرمجية المرتبة، '
                'تكمن رحلة طويلة من الشغف والسهر والتعلم المستمر. '
                'أردت من خلال هذا المشروع أن أقدم لك رفيقًا إيمانيًا '
                'يوميًا، يجمع بين سهولة الاستخدام وجمال التصميم '
                'والأداء السلس، دون إعلانات تشوش عليك خلوتك مع ذكر الله.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14.sp,
                  height: 1.7,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 22.h),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final share = SharePlus.instance;

                        await share.share(
                          ShareParams(
                            title: 'شارك التطبيق',
                            text:
                                'أرشح لك تطبيق "زاد المسلم"، '
                                'رفيقك اليومي للأذكار والأدعية '
                                'بدون إعلانات وبأداء سلس ومميز.\n\n'
                                'https://play.google.com/store/apps/'
                                'details?id=com.zad_al_muslim.adnan',
                          ),
                        );
                      },
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text(
                        'شارك الأجر',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: colorScheme.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                      ),
                      child: Text(
                        'إغلاق',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
