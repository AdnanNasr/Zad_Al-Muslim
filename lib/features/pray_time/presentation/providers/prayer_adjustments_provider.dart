import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/features/pray_time/data/models/prayer_adjustments_model.dart';
import 'package:noor_quran/features/pray_time/domain/repositories/prayer_times_repository.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';

/// موفر StateNotifier للتحكم في تعديلات دقائق أوقات الصلاة
class PrayerAdjustmentsNotifier extends StateNotifier<AsyncValue<PrayerAdjustmentsModel>> {
  final Ref _ref;

  PrayerAdjustmentsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadAdjustments();
  }

  Future<void> _loadAdjustments() async {
    final isar = sl<Isar>();
    final existing = await isar.prayerAdjustmentsModels.get(1);
    state = AsyncValue.data(existing ?? PrayerAdjustmentsModel());
  }

  /// تحديث الـ offset لصلاة معينة وحفظه في Isar
  Future<void> updateOffset(String prayerName, int newOffset) async {
    final current = state.valueOrNull ?? PrayerAdjustmentsModel();
    final updated = current.copyWithOffset(prayerName, newOffset);

    // حفظ فوري في Isar
    final isar = sl<Isar>();
    await isar.writeTxn(() async {
      await isar.prayerAdjustmentsModels.put(updated);
    });

    state = AsyncValue.data(updated);

    // إعادة جدولة الإشعارات مع الـ offsets الجديدة
    final position = _ref.read(userPositionProvider);
    if (position != null) {
      final repo = sl<PrayerTimesRepository>();
      await repo.saveAdjustments(updated, position);
    }
  }

  /// إعادة تعيين جميع التعديلات إلى الصفر
  Future<void> resetAllOffsets() async {
    final resetModel = PrayerAdjustmentsModel();
    final isar = sl<Isar>();
    await isar.writeTxn(() async {
      await isar.prayerAdjustmentsModels.put(resetModel);
    });
    state = AsyncValue.data(resetModel);

    // إعادة جدولة الإشعارات بالأوقات الأصلية
    final position = _ref.read(userPositionProvider);
    if (position != null) {
      final repo = sl<PrayerTimesRepository>();
      await repo.saveAdjustments(resetModel, position);
    }
  }
}

final prayerAdjustmentsProvider =
    StateNotifierProvider<PrayerAdjustmentsNotifier, AsyncValue<PrayerAdjustmentsModel>>((ref) {
  return PrayerAdjustmentsNotifier(ref);
});
