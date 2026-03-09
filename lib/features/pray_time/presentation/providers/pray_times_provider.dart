import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/features/pray_time/domain/usecases/get_prayer_times_usecase.dart';

import '../../data/models/prayer_times_model.dart';

/// يحتوي على موقع المستخدم الذي جلبناه عند بدأ التطبيق.
/// سنستخدم [StateProvider] لكي نتمكن من تحديث الموقع لاحقاً
/// (مثلاً من شاشة السبلش بعد تحديد الموقع).

/// موفر يعيد موديل مواقيت الصلاة لليوم؛ يعتمد على [GetPrayerTimesUseCase]
/// ويقوم بالقراءة من القاعدة أو الحساب التلقائي إذا لم يكن مخزناً.
final todayPrayerTimesProvider = FutureProvider.autoDispose<PrayerTimesModel?>((
  ref,
) async {
  ref.keepAlive();

  final pos = ref.watch(userPositionProvider);
  if (pos == null) {
    return null;
  }

  final getPrayerTimes = sl<GetPrayerTimesUseCase>();
  final result = await getPrayerTimes(pos);

  return result.fold(
    (failure) => null,
    (entity) => PrayerTimesModel.fromEntity(entity),
  );
});
