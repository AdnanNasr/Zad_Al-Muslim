import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/routes.dart';
import 'package:zad_al_muslim/features/pray_time/domain/entities/prayer_times_entity.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/pray_times_provider.dart';

class NextPrayerCard extends ConsumerStatefulWidget {
  const NextPrayerCard({super.key});

  @override
  ConsumerState<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends ConsumerState<NextPrayerCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayerAsync = ref.watch(todayPrayerTimesProvider);

    return prayerAsync.when(
      data: (model) {
        if (model == null) return const SizedBox.shrink();
        return _buildCard(context, model);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(
    BuildContext context,
    PrayerTimesEntity model,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final nextInfo = _getNextPrayer(model);
    final name = nextInfo['name'] as String;
    final icon = nextInfo['icon'] as IconData;
    final remaining = nextInfo['remaining'] as Duration;

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    // تحديد اللون الأساسي بناءً على وقت الصلاة
    Color baseColor;
    if (name == "الفجر" || name == "الشروق") {
      baseColor = Colors.amber;
    } else if (name == "الظهر" || name == "العصر") {
      baseColor = Colors.orange;
    } else {
      baseColor = Colors.indigo;
    }

    final bgColor = isDark
        ? baseColor.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.4);

    final contentColor = isDark
        ? (baseColor is MaterialColor ? baseColor.shade200 : baseColor)
        : (baseColor is MaterialColor ? baseColor.shade900 : baseColor);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: baseColor.withValues(alpha: isDark ? 0.05 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap:
                    () => Navigator.of(context).pushNamed(Routes.prayTimePage),
                child: Ink(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : baseColor.withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      // أيقونة الصلاة بتصميم مميز
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: contentColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 24.sp,
                          color: contentColor,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      // تفاصيل الصلاة القادمة
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الصلاة القادمة",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Cairo",
                                color: contentColor.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: "Cairo",
                                fontWeight: FontWeight.bold,
                                color: contentColor,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // عداد الوقت التنازلي
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: contentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: contentColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14.sp,
                              color: contentColor,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: contentColor,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getNextPrayer(PrayerTimesEntity model) {
    final now = DateTime.now();

    final prayers = [
      {'name': 'الفجر', 'time': model.fajr, 'icon': Icons.wb_twilight},
      {
        'name': 'الشروق',
        'time': model.sunrise,
        'icon': Icons.wb_sunny_outlined,
      },
      {'name': 'الظهر', 'time': model.dhuhr, 'icon': Icons.wb_sunny},
      {'name': 'العصر', 'time': model.asr, 'icon': Icons.wb_cloudy_outlined},
      {'name': 'المغرب', 'time': model.maghrib, 'icon': Icons.nightlight_round},
      {'name': 'العشاء', 'time': model.isha, 'icon': Icons.bedtime},
    ];

    for (final prayer in prayers) {
      final time = (prayer['time'] as DateTime).toLocal();
      if (now.isBefore(time)) {
        return {
          'name': prayer['name'],
          'icon': prayer['icon'],
          'remaining': time.difference(now),
        };
      }
    }

    // بعد العشاء → ننتظر فجر الغد
    final tomorrowFajr = model.fajr.toLocal().add(const Duration(days: 1));
    return {
      'name': 'الفجر',
      'icon': Icons.wb_twilight,
      'remaining': tomorrowFajr.difference(now),
    };
  }
}
