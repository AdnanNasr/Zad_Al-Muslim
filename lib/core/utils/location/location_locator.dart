import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/core/common/providers/location_status_provider.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';

class LocationLocator {
  static Future<Position?> determinePosition(WidgetRef ref) async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. فحص هل خدمة الـ GPS مفعلة في الجهاز
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      const message = "يجب تفعيل الـ GPS من إعدادات الجوال";
      _updateStatus(
        ref: ref,
        status: LocationMessage.locationDisabled,
        message: message,
      );

      // محاولة فتح الإعدادات للمستخدم
      await Geolocator.openLocationSettings();
      return null;
    }

    // 2. فحص أذونات الموقع
    permission = await Geolocator.checkPermission();

    // إذا كان الإذن مرفوضاً، نطلبه من المستخدم
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        const message = "تم رفض طلب إذن الموقع";
        _updateStatus(
          ref: ref,
          status: LocationMessage.locationNotAllowed,
          message: message,
        );
        return null;
      }
    }

    // إذا كان الإذن مرفوضاً بشكل دائم (من إعدادات النظام)
    if (permission == LocationPermission.deniedForever) {
      const message =
          'الأذونات مرفوضة بشكل دائم، يرجى تفعيلها يدوياً من الإعدادات';
      _updateStatus(
        ref: ref,
        status: LocationMessage.locationNotAllowedEver,
        message: message,
      );
      // يمكن فتح إعدادات التطبيق مباشرة هنا
      await Geolocator.openAppSettings();
      return null;
    }

    // 3. إذا وصلنا هنا، يعني الأذونات والخدمة تعمل
    _updateStatus(
      ref: ref,
      status: LocationMessage.locationAllowed,
      message: "جاري تحديد الموقع...",
    );

    try {
      // إعدادات جلب الموقع الحديثة (تجنباً للـ Deprecated timeLimit)
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15), // وقت مستقطع لتجنب التعليق
      );

      // جلب الموقع الفعلي
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      _updateStatus(
        ref: ref,
        status: LocationMessage.locationAllowed,
        message: "تم تحديد الموقع بنجاح",
      );
      return position;
    } catch (e) {
      // معالجة الأخطاء مثل Timeout أو فشل الحساسات
      final errorMessage = "فشل جلب الموقع: ${e.toString()}";
      AppLogger.logger.e(errorMessage);
      return null;
    }
  }

  /// دالة مساعدة لتحديث الحالة وتقليل تكرار الكود
  static void _updateStatus({
    required WidgetRef ref,
    required LocationMessage status,
    required String message,
  }) {
    ref.read(locationStatusProvider.notifier).setStatus({status: message});
    AppLogger.logger.i(message);
  }
}
