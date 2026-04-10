import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:noor_quran/core/common/providers/user_position_provider.dart';
import 'package:noor_quran/features/qebla/data/repositories/qibla_repository_impl.dart';
import 'package:noor_quran/features/qebla/domain/entities/qibla_entity.dart';
import 'package:noor_quran/features/qebla/domain/usecases/get_qibla_direction.dart';

/// -- 1. مخزن استدعاء حساب القبلة --
/// يقرأ الإحداثيات المخزنة من SharedPreferences ويحسب زاوية القبلة فوراً
final qiblaEntityProvider = Provider<QiblaEntity?>((ref) {
  final position = ref.watch(userPositionProvider);
  if (position == null) return null;

  final useCase = GetQiblaDirection(QiblaRepositoryImpl());
  final result = useCase(
    latitude: position.latitude,
    longitude: position.longitude,
  );

  return result.fold((_) => null, (entity) => entity);
});

/// -- 2. Stream بوصلة الجهاز --
/// يُعيد heading كـ double بالدرجات (0–360، من الشمال).
/// يراعي:
///   - headingForCameraMode (الشمال الحقيقي إذا توفّر)
///   - heading الاحتياطي (الشمال المغناطيسي)
final compassStreamProvider = Provider<Stream<double?>>((ref) {
  return (FlutterCompass.events ?? const Stream.empty()).map((event) {
    // نفضّل headingForCameraMode لأنه يعوّض الميل المغناطيسي على الأجهزة الداعمة
    return event.headingForCameraMode ?? event.heading;
  }).asBroadcastStream();
});

/// -- 3. التحقق من دعم البوصلة --
/// يُرجع null أثناء التحقق، true إذا توفر الحساس، false إذا لم يتوفر
final compassSupportProvider = FutureProvider<bool>((ref) async {
  // نستمع للحدث الأول فقط للتحقق من وجود البوصلة
  try {
    final event = await FlutterCompass.events?.first
        .timeout(const Duration(seconds: 3));
    return event != null;
  } catch (_) {
    return false;
  }
});
