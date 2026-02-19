import 'package:geolocator/geolocator.dart';

class LocationLocator {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("يحب تفعيل الـ GPS في من إعدادات الجوال");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("تم رفض طلب إذن الموقع");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'الأذونات مرفوضة بشكل دائم، يرجى تفعيلها من الإعدادات',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
