import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/features/pray_time/domain/entities/prayer_times_entity.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/pray_times_provider.dart';

/// بيانات الصلاة القادمة الجاهزة للاستخدام داخل الواجهة.
class NextPrayerInfo {
  const NextPrayerInfo({
    required this.name,
    required this.time,
    required this.remaining,
    required this.icon,
  });

  final String name;
  final DateTime time;
  final Duration remaining;
  final IconData icon;

  Duration get safeRemaining {
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// مثال: 01:24:09
  String get digitalRemaining {
    final duration = safeRemaining;

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// مثال: بعد ساعتين و15 دقيقة
  String get compactRemaining {
    final duration = safeRemaining;

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (duration.inSeconds < 60) {
      return 'بعد أقل من دقيقة';
    }

    if (hours > 0 && minutes > 0) {
      return 'بعد $hours س و$minutes د';
    }

    if (hours > 0) {
      return hours == 1 ? 'بعد ساعة' : 'بعد $hours ساعات';
    }

    return 'بعد $minutes دقيقة';
  }

  /// الوقت بصيغة 24 ساعة، مثال: 15:42
  String get formattedTime {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  bool get isVeryClose {
    return safeRemaining <= const Duration(minutes: 10);
  }

  bool get isImminent {
    return safeRemaining < const Duration(minutes: 1);
  }

  String get statusMessage {
    final duration = safeRemaining;

    if (duration < const Duration(minutes: 1)) {
      return 'حان موعد الصلاة';
    }

    if (duration <= const Duration(minutes: 10)) {
      return 'اقترب موعد الصلاة';
    }

    if (duration <= const Duration(hours: 1)) {
      return 'لم يتبقَّ الكثير';
    }

    return 'استعد للصلاة القادمة';
  }
}

/// ساعة مشتركة تتحدث كل ثانية.
///
/// عند الانتقال إلى يوم جديد، يتم تحديث مواقيت الصلاة تلقائيًا.
final prayerClockProvider = StreamProvider.autoDispose<DateTime>((ref) async* {
  var previousDate = _dateOnly(DateTime.now());

  yield DateTime.now();

  await for (final _ in Stream<void>.periodic(const Duration(seconds: 1))) {
    final now = DateTime.now();
    final currentDate = _dateOnly(now);

    if (currentDate != previousDate) {
      previousDate = currentDate;
      ref.invalidate(todayPrayerTimesProvider);
    }

    yield now;
  }
});

/// الصلاة القادمة، محسوبة من مواقيت اليوم والوقت الحالي.
final nextPrayerProvider = Provider<AsyncValue<NextPrayerInfo?>>((ref) {
  final prayerTimesAsync = ref.watch(todayPrayerTimesProvider);
  final clockAsync = ref.watch(prayerClockProvider);

  final clockError = clockAsync.asError;

  if (clockError != null) {
    return AsyncError(clockError.error, clockError.stackTrace);
  }

  final now = clockAsync.value ?? DateTime.now();

  return prayerTimesAsync.whenData((prayerTimes) {
    if (prayerTimes == null) {
      return null;
    }

    return calculateNextPrayer(prayerTimes: prayerTimes, now: now);
  });
});

NextPrayerInfo calculateNextPrayer({
  required PrayerTimesEntity prayerTimes,
  required DateTime now,
}) {
  final prayers = <_PrayerEntry>[
    _PrayerEntry(
      name: 'الفجر',
      time: prayerTimes.fajr,
      icon: Icons.wb_twilight_rounded,
    ),
    _PrayerEntry(
      name: 'الظهر',
      time: prayerTimes.dhuhr,
      icon: Icons.wb_sunny_rounded,
    ),
    _PrayerEntry(
      name: 'العصر',
      time: prayerTimes.asr,
      icon: Icons.cloud_outlined,
    ),
    _PrayerEntry(
      name: 'المغرب',
      time: prayerTimes.maghrib,
      icon: Icons.nightlight_round,
    ),
    _PrayerEntry(
      name: 'العشاء',
      time: prayerTimes.isha,
      icon: Icons.bedtime_rounded,
    ),
  ];

  for (final prayer in prayers) {
    if (now.isBefore(prayer.time)) {
      return NextPrayerInfo(
        name: prayer.name,
        time: prayer.time,
        remaining: prayer.time.difference(now),
        icon: prayer.icon,
      );
    }
  }

  // بعد العشاء يتم عرض فجر اليوم التالي.
  //
  // هذه طريقة تقريبية تعتمد على فجر اليوم الحالي مضافًا إليه يوم.
  // الأفضل مستقبلًا تحميل مواقيت الغد الفعلية من الـ Repository.
  final tomorrowFajr = prayerTimes.fajr.add(const Duration(days: 1));

  return NextPrayerInfo(
    name: 'الفجر',
    time: tomorrowFajr,
    remaining: tomorrowFajr.difference(now),
    icon: Icons.wb_twilight_rounded,
  );
}

class _PrayerEntry {
  const _PrayerEntry({
    required this.name,
    required this.time,
    required this.icon,
  });

  final String name;
  final DateTime time;
  final IconData icon;
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
