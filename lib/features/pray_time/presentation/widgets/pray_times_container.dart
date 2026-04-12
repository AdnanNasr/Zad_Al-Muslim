import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pray_times_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:noor_quran/core/extensions/sizes_ext.dart';
import 'package:noor_quran/core/l10n/app_localizations.dart';
import 'package:noor_quran/features/settings/presentation/providers/app_settings_provider.dart';

class PrayTimesContainer extends ConsumerWidget {
  const PrayTimesContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncModel = ref.watch(todayPrayerTimesProvider);
    final use24h = ref.watch(appSettingsProvider).use24HourFormat;

    String formatDate(DateTime dt) => (use24h
        ? DateFormat.Hm().format(dt.toLocal())
        : DateFormat.jm("ar").format(dt.toLocal()));

    return asyncModel.when(
      data: (model) {
        // إذا لم تتوفر البيانات، نظهر المحتوى الافتراضي
        final fajr = model?.fajr;
        final dhuhr = model?.dhuhr;
        final asr = model?.asr;
        final maghrib = model?.maghrib;
        final esha = model?.isha;

        return ClipPath(
          clipper: _CurvedBottomClipper(),
          child: Container(
            height: context.witdthScreen <= 360 ? 300.h : 270.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              image: const DecorationImage(
                image: AssetImage("assets/images/pray_times_cover.jpg"),
                fit: BoxFit.cover,
                opacity: .8,
                colorFilter: ColorFilter.mode(
                  Colors.black38,
                  BlendMode.colorBurn,
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: EdgeInsets.all(context.witdthScreen * 0.01),
              child: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Column(
                  children: [
                    // --- الترحيب الذكي ---
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Tajawal",
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // --- التاريخ ---
                    Text(
                      _getFormattedDate(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: "Cairo",
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.pray_times,
                          style: TextStyle(
                            fontSize: context.witdthScreen * 0.05,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: context.heightScreen * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _PrayTimeItem(
                              title: AppLocalizations.of(context)!.fajer,
                              time: fajr != null ? formatDate(fajr) : "--:--",
                            ),
                            _PrayTimeItem(
                              title: AppLocalizations.of(context)!.duhur,
                              time: dhuhr != null ? formatDate(dhuhr) : "--:--",
                            ),
                            _PrayTimeItem(
                              title: AppLocalizations.of(context)!.asr,
                              time: asr != null ? formatDate(asr) : "--:--",
                            ),
                            _PrayTimeItem(
                              title: AppLocalizations.of(context)!.magrib,
                              time: maghrib != null
                                  ? formatDate(maghrib)
                                  : "--:--",
                            ),
                            _PrayTimeItem(
                              title: AppLocalizations.of(context)!.esha,
                              time: esha != null ? formatDate(esha) : "--:--",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => ClipPath(
        clipper: _CurvedBottomClipper(),
        child: Container(
          height: context.witdthScreen <= 360 ? 300.h : 270.h,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.primary,
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      ),
      error: (err, _) => ClipPath(
        clipper: _CurvedBottomClipper(),
        child: Container(
          height: context.witdthScreen <= 360 ? 300.h : 270.h,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            AppLocalizations.of(context)!.pray_times,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// ترحيب يتغير حسب الوقت
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "صباح الخير ☀️";
    if (hour < 18) return "مساء النور ✨";
    return "مساء الخير 🌙";
  }

  /// تنسيق التاريخ الميلادي
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

class _PrayTimeItem extends ConsumerWidget {
  final String title;
  final String time;

  const _PrayTimeItem({required this.title, required this.time});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyleTitle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: context.heightScreen * 0.026,
    );

    final textStyleTime = TextStyle(
      color: Colors.white.withValues(alpha: 0.9),
      fontSize: context.heightScreen * 0.016,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: textStyleTitle),
        SizedBox(height: context.heightScreen * 0.005),
        Text(time, style: textStyleTime),
      ],
    );
  }
}

/// مقص لعمل حافة منحنية في الأسفل
class _CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 10,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
