import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zad_al_muslim/core/constants/enums/my_enums.dart';

import 'package:zad_al_muslim/core/constants/shared_pref_keys.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationStatusProvider
    extends StateNotifier<Map<LocationMessage, String>> {
  final SharedPreferences _prefs;

  // نمرر SharedPreferences عبر الـ Constructor لسهولة الاختبار
  LocationStatusProvider(this._prefs) : super({}) {
    _loadStatus(); // جلب الحالة المحفوظة فور التشغيل
  }

  // 1. جلب الحالة المحفوظة عند بداية التشغيل
  void _loadStatus() {
    final savedStatusStr = _prefs.getString(SharedPrefKeys.locationMessage);
    if (savedStatusStr != null) {
      // استخدام الـ Extension الذي صنعته لتحويل النص إلى Enum
      final status = LocationMessageExtension.fromString(savedStatusStr);

      // هنا نقوم بتعيين الرسالة الافتراضية بناءً على الـ Enum
      state = {status: _getMessageForStatus(status)};
    }
  }

  // 2. تحديث الحالة وحفظها تلقائياً
  void setStatus(Map<LocationMessage, String> status) {
    if (status.isNotEmpty) {
      state = status;
      // حفظ المفتاح (الـ Enum) كـ String
      _prefs.setString(SharedPrefKeys.locationMessage, status.keys.first.name);
    }
  }

  void clearStatus() {
    state = {};
    _prefs.remove(SharedPrefKeys.locationMessage);
  }

  Future<void> refreshStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setStatus({
        LocationMessage.locationDisabled: _getMessageForStatus(
          LocationMessage.locationDisabled,
        ),
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      setStatus({
        LocationMessage.locationNotAllowed: _getMessageForStatus(
          LocationMessage.locationNotAllowed,
        ),
      });
    } else if (permission == LocationPermission.deniedForever) {
      setStatus({
        LocationMessage.locationNotAllowedEver: _getMessageForStatus(
          LocationMessage.locationNotAllowedEver,
        ),
      });
    } else {
      setStatus({
        LocationMessage.locationAllowed: _getMessageForStatus(
          LocationMessage.locationAllowed,
        ),
      });
    }
  }

  // دالة مساعدة لتعريف الرسائل الافتراضية عند الاسترجاع
  String _getMessageForStatus(LocationMessage status) {
    switch (status) {
      case LocationMessage.locationAllowed:
        return "تم تحديد الموقع";
      case LocationMessage.locationDisabled:
        return "الـ GPS معطل";
      case LocationMessage.locationNotAllowed:
        return "الإذن مرفوض";
      case LocationMessage.locationNotAllowedEver:
        return "الإذن مرفوض دائماً";
      case LocationMessage.loading:
        return "جاري التحميل";
      case LocationMessage.error:
        return "افحص اتصالك بالإنترنت";
    }
  }
}

// 3. تحديث تعريف الـ Provider ليمرر SharedPreferences
final locationStatusProvider =
    StateNotifierProvider<LocationStatusProvider, Map<LocationMessage, String>>(
      (ref) {
        final prefs = sl<SharedPreferences>();
        return LocationStatusProvider(prefs);
      },
    );
