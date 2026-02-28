import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noor_quran/view_models/providers/location_status_provider.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

class LocationLocator {
  static Future<Position?> determinePosition(WidgetRef ref) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      final message = "يحب تفعيل الـ GPS في من إعدادات الجوال";
      ref.read(locationStatusProvider.notifier).setStatus({
        LocationMessage.locationDisabeld: message,
      });
      AppLogger.logger.e(message);
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        final message = "تم رفض طلب إذن الموقع";
        ref.read(locationStatusProvider.notifier).setStatus({
          LocationMessage.locationNotAllowed: message,
        });
        AppLogger.logger.e(message);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      final message =
          'الأذونات مرفوضة بشكل دائم، يرجى تفعيلها بشكل يدوي من الإعدادات';
      ref.read(locationStatusProvider.notifier).setStatus({
        LocationMessage.locationNotAllowedEver: message,
      });
      AppLogger.logger.e(message);
      return null;
    }

    ref.read(locationStatusProvider.notifier).setStatus({
      LocationMessage.locationAllowed: "الأذونات مفعلة",
    });
    return await Geolocator.getCurrentPosition();
  }
}

enum LocationMessage {
  locationAllowed,
  locationDisabeld,
  locationNotAllowed,
  locationNotAllowedEver,
}
