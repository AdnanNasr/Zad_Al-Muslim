import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../models/prayer_times/prayer_times_model.dart';
import '../notifiers/pray_times_notifier.dart';

/// يحتوي على موقع المستخدم الذي جلبناه عند بدأ التطبيق.
/// سنستخدم [StateProvider] لكي نتمكن من تحديث الموقع لاحقاً
/// (مثلاً من شاشة السبلش بعد تحديد الموقع).
final userPositionProvider = StateProvider<Position?>((ref) => null);

/// موفر يعيد موديل مواقيت الصلاة لليوم؛ يعتمد على [PrayTimesNotifier]
/// ويقوم بالقراءة من القاعدة أو الحساب التلقائي إذا لم يكن مخزناً.
final todayPrayerTimesProvider =
    FutureProvider.autoDispose<PrayerTimesModel?>((ref) async {
  // keep the provider alive while the request is underway, some widgets may
  // subscribe/unsubscribe quickly and we don't want the future to be cancelled
  // or re-created unexpectedly (which could also trigger duplicate-completion
  // errors).
  ref.keepAlive();

  final pos = ref.watch(userPositionProvider);
  if (pos == null) {
    // قد لا تتوفر بيانات الموقع بعد عند بعض السيناريوهات
    return null;
  }
  final notifier = ref.read(prayTimesNotifierProvider.notifier);
  return notifier.loadToday(position: pos);
});
