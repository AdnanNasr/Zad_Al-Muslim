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
final compassStreamProvider = StreamProvider<double?>((ref) {
  return (FlutterCompass.events ?? const Stream.empty()).map((event) {
    // Some devices return 0.0 for headingForCameraMode incorrectly.
    final double? cameraHeading = event.headingForCameraMode;
    if (cameraHeading != null && cameraHeading != 0.0) {
      return cameraHeading;
    }
    return event.heading;
  });
});

/// -- 3. التحقق من دعم البوصلة --
/// يُرجع null أثناء التحقق، true إذا توفر الحساس، false إذا لم يتوفر
final compassSupportProvider = FutureProvider<bool>((ref) async {
  // للتحقق من دعم البوصلة نكتفي بالتأكد من أن الاستريم ليس فارغا
  // استخدام .first يغلق الاشتراك في بعض الأجهزة ويسبب توقف البوصلة
  await Future.delayed(const Duration(milliseconds: 50));
  return FlutterCompass.events != null;
});
