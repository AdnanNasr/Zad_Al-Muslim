import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zad_al_muslim/core/common/providers/home_clock_provider.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/notifications/notification_inbox_service.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = ref.watch(homeClockProvider).value ?? DateTime.now();
    ref.listen(homeClockProvider, (_, _) {
      sl<NotificationInboxService>().reconcile();
    });

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 6.h),
        child: Material(
          color: colorScheme.surface,
          elevation: isDark ? 0 : 3,
          shadowColor: Colors.black.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(26.r),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26.r),
              border: Border.all(
                color: isDark
                    ? colorScheme.outlineVariant.withValues(alpha: 0.45)
                    : colorScheme.outline.withValues(alpha: 0.34),
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

                    ValueListenableBuilder<List<AppNotification>>(
                      valueListenable:
                          sl<NotificationInboxService>().notifications,
                      builder: (context, notifications, _) {
                        final unread = notifications
                            .where((item) => !item.isRead)
                            .length;
                        return Badge(
                          isLabelVisible: unread > 0,
                          label: Text(unread > 99 ? '99+' : '$unread'),
                          alignment: Alignment.topRight,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          textStyle: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                          ),
                          child: IconButton(
                            tooltip: 'الإشعارات',
                            onPressed: () {
                              HapticFeedback.vibrate();
                              Navigator.of(
                                context,
                              ).pushNamed('/notifications_page');
                            },
                            icon: Icon(
                              Icons.notifications,
                              color: isDark
                                  ? Colors.white
                                  : context.color.onPrimaryContainer,
                              size: 27.5,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                isDark
                                    ? context.color.secondaryContainer
                                    : context.color.primaryContainer,
                              ),
                              shape: WidgetStatePropertyAll(
                                CircleBorder(
                                  side: BorderSide(
                                    color: isDark
                                        ? context.color.secondary
                                        : context.color.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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

class _HeaderContent extends ConsumerWidget {
  const _HeaderContent({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const _AppLogoButton(),
            SizedBox(width: 10.w),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: 6.h),
                Text(
                  _getDailyMessage(now),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),

        // SizedBox(height: 5.h),

        // SizedBox(height: 4.h),
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

class _DatesRow extends ConsumerWidget {
  const _DatesRow({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode.isDark;
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
                    decoration: BoxDecoration(
                      color: context.color.surface,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // الهلال
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.color.primaryContainer,
                          ),
                          child: Icon(
                            Icons.nightlight_round,
                            size: 40,
                            color: isDark
                                ? Colors.white
                                : context.color.primary,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // العنوان
                        Text(
                          'التاريخ الهجري',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: context.color.onSurface,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'تاريخ اليوم حسب التقويم الهجري',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: context.color.onSurfaceVariant,
                            fontFamily: 'Cairo',
                          ),
                        ),

                        const SizedBox(height: 20),

                        // التاريخ
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: context.color.primaryContainer.withValues(
                              alpha: 0.45,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: context.color.primary.withValues(
                                alpha: .12,
                              ),
                            ),
                          ),
                          child: Text(
                            _getFormattedHijriDate(now),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: context.color.primary,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // زر الإغلاق
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: context.color.primary,
                              foregroundColor: context.color.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'حسنًا',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                                color: context.color.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: _DateItem(
              icon: Icons.dark_mode_outlined,
              label: 'الهجري',
              text: _getFormattedHijriDate(now),
              accent: _HeaderDateAccent.primary,
            ),
          ),
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
                    decoration: BoxDecoration(
                      color: context.color.surface,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // أيقونة التقويم
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.color.secondaryContainer,
                          ),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            size: 40,
                            color: isDark
                                ? Colors.white
                                : context.color.secondary,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // العنوان
                        Text(
                          'التاريخ الميلادي',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: context.color.onSurface,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'تاريخ اليوم حسب التقويم الميلادي',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: context.color.onSurfaceVariant,
                            fontFamily: 'Cairo',
                          ),
                        ),

                        const SizedBox(height: 20),

                        // التاريخ
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: context.color.secondaryContainer.withValues(
                              alpha: 0.45,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: context.color.secondary.withValues(
                                alpha: .12,
                              ),
                            ),
                          ),
                          child: Text(
                            _getFormattedGregorianDate(now),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: context.color.secondary,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // زر الإغلاق
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: context.color.secondary,
                              foregroundColor: context.color.onSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'حسنًا',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                                color: context.color.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: _DateItem(
              icon: Icons.calendar_today_rounded,
              label: 'الميلادي',
              text: _getFormattedGregorianDate(now),
              accent: _HeaderDateAccent.secondary,
            ),
          ),
        ),
      ],
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

// String _getGreeting(DateTime now) {
//   final hour = now.hour;

//   if (hour >= 4 && hour < 12) {
//     return 'صباح مبارك';
//   }

//   if (hour >= 12 && hour < 17) {
//     return 'نهارك مبارك';
//   }

//   if (hour >= 17 && hour < 22) {
//     return 'مساء مبارك';
//   }

//   return 'السلام عليكم ورحمة الله';
// }

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
  // const dayNames = [
  //   'الإثنين',
  //   'الثلاثاء',
  //   'الأربعاء',
  //   'الخميس',
  //   'الجمعة',
  //   'السبت',
  //   'الأحد',
  // ];

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

  // final dayName = dayNames[now.weekday - 1];
  final month = months[now.month - 1];

  return '${now.day} $month ${now.year}';
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
