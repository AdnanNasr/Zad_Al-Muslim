import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/common/providers/user_position_provider.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/pray_time/domain/usecases/get_prayer_times_usecase.dart';
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
    if (pos == null) return null;

    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    final adjustmentsAsync = ref.watch(prayerAdjustmentsProvider);
    final adjustments = adjustmentsAsync.valueOrNull;

    final getPrayerTimes = sl<GetPrayerTimesUseCase>();
    final result = await getPrayerTimes(
      pos,
      date: todayDate,
      adjustments: adjustments,
    );

    return result.fold((failure) => null, (entity) => entity);
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

      final getPrayerTimes = sl<GetPrayerTimesUseCase>();
      final result = await getPrayerTimes(
        pos,
        date: selectedDate,
        adjustments: adjustments,
      );

      return result.fold((failure) => null, (entity) => entity);
    });

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
