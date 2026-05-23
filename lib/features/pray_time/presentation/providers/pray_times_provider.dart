import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/common/providers/user_position_provider.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:zad_al_muslim/domain/repositories/i_prayer_repository.dart';
import 'package:zad_al_muslim/domain/entities/prayer_time.dart' as domain;
import 'package:zad_al_muslim/features/pray_time/presentation/providers/prayer_adjustments_provider.dart';
import '../../domain/entities/prayer_times_entity.dart';

/// موفر اليوم المحدد حالياً للعرض. الافتراضي هو اليوم الحالي.
/// يمكن التنقل داخل نطاق ± 30 يوم من اليوم الحالي.
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// موفر يعيد موديل مواقيت الصلاة لليوم الحالي حصراً (للاستخدام في الويدجتات الدائمة مثل Home).
final todayPrayerTimesProvider = FutureProvider.autoDispose<PrayerTimesEntity?>(
  (ref) async {
    ref.keepAlive();

    final pos = ref.watch(userPositionProvider);
    if (pos == null) {
      AppLogger.logger.e("todayPrayerTimesProvider: الموقع (pos) غير متوفر.");
      return null;
    }

    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    // AppLogger.logger.e(
    //   "todayPrayerTimesProvider: جاري طلب مواقيت اليوم: $todayDate",
    // );

    final adjustmentsAsync = ref.watch(prayerAdjustmentsProvider);
    final adjustments = adjustmentsAsync.valueOrNull;

    final repo = sl<IPrayerRepository>();
    final prayers = await repo.getPrayersForDay(todayDate);

    if (prayers.isEmpty) return null;

    return _mapToUiEntity(prayers, todayDate, adjustments);
  },
);

/// موفر يعيد موديل مواقيت الصلاة للتاريخ المحدد (للاستخدام في صفحة أوقات الصلاة).
final selectedDatePrayerTimesProvider =
    FutureProvider.autoDispose<PrayerTimesEntity?>((ref) async {
      ref.keepAlive();

      final pos = ref.watch(userPositionProvider);
      if (pos == null) return null;

      final selectedDate = ref.watch(selectedDateProvider);

      final adjustmentsAsync = ref.watch(prayerAdjustmentsProvider);
      final adjustments = adjustmentsAsync.valueOrNull;

      final repo = sl<IPrayerRepository>();
      final prayers = await repo.getPrayersForDay(selectedDate);

      if (prayers.isEmpty) return null;

      return _mapToUiEntity(prayers, selectedDate, adjustments);
    });

PrayerTimesEntity _mapToUiEntity(
  List<domain.PrayerTime> prayers,
  DateTime date,
  dynamic adjustments,
) {
  // نقوم بتحويل الوقت من UTC إلى Local هنا لضمان دقة العرض حسب توقيت الجهاز
  final fajr = prayers
      .firstWhere((p) => p.prayerName == domain.PrayerName.fajr)
      .time
      .toLocal();
  final sunrise = prayers
      .firstWhere((p) => p.prayerName == domain.PrayerName.sunrise)
      .time
      .toLocal();
  final dhuhr = prayers
      .firstWhere((p) => p.prayerName == domain.PrayerName.dhuhr)
      .time
      .toLocal();
  final asr = prayers
      .firstWhere((p) => p.prayerName == domain.PrayerName.asr)
      .time
      .toLocal();
  final maghrib = prayers
      .firstWhere((p) => p.prayerName == domain.PrayerName.maghrib)
      .time
      .toLocal();
  final isha = prayers
      .firstWhere((p) => p.prayerName == domain.PrayerName.isha)
      .time
      .toLocal();

  return PrayerTimesEntity(
    date: date,
    fajr: _applyAdjustment(fajr, adjustments?.fajrAdjustment ?? 0),
    sunrise: _applyAdjustment(sunrise, adjustments?.sunriseAdjustment ?? 0),
    dhuhr: _applyAdjustment(dhuhr, adjustments?.dhuhrAdjustment ?? 0),
    asr: _applyAdjustment(asr, adjustments?.asrAdjustment ?? 0),
    maghrib: _applyAdjustment(maghrib, adjustments?.maghribAdjustment ?? 0),
    isha: _applyAdjustment(isha, adjustments?.ishaAdjustment ?? 0),
  );
}

DateTime _applyAdjustment(DateTime time, int minutes) {
  return time.add(Duration(minutes: minutes));
}

/// مساعد لتحديد إذا كان التاريخ المحدد هو اليوم الحالي
bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

/// مساعد للتحقق من الحد الأقصى للتنقل (± 30 يوم)
bool canGoForward(DateTime date) {
  final maxDate = DateTime.now().add(const Duration(days: 30));
  return date.isBefore(DateTime(maxDate.year, maxDate.month, maxDate.day));
}

bool canGoBack(DateTime date) {
  final minDate = DateTime.now().subtract(const Duration(days: 30));
  return date.isAfter(DateTime(minDate.year, minDate.month, minDate.day));
}
