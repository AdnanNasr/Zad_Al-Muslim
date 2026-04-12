import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/pray_time/data/models/prayer_times_model.dart';
import 'package:noor_quran/features/pray_time/presentation/providers/pray_times_provider.dart';

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

  Widget _buildCard(BuildContext context, PrayerTimesModel model) {
    final nextInfo = _getNextPrayer(model);
    final name = nextInfo['name'] as String;
    final icon = nextInfo['icon'] as IconData;
    final remaining = nextInfo['remaining'] as Duration;

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: context.color.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: context.color.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: context.color.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: context.color.primary, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الصلاة القادمة",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "Cairo",
                    color: context.color.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                    color: context.color.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: context.color.primary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.color.onPrimary,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getNextPrayer(PrayerTimesModel model) {
    final now = DateTime.now();

    final prayers = [
      {'name': 'الفجر', 'time': model.fajr, 'icon': Icons.wb_twilight},
      {'name': 'الشروق', 'time': model.sunrise, 'icon': Icons.wb_sunny_outlined},
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
