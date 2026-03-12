import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';

class NetworkInfo {
  // دالة الفحص الرئيسية (بقيت كما هي في التسمية والمنطق)
  Future<bool> hasValidConnection() async {
    final isWiFiOrPhoneDataActive = await _isWiFiOrPhoneDataActive();

    if (!isWiFiOrPhoneDataActive) {
      AppLogger.logger.e("بيانات الجوال او الواي فاي غير مفعل");
      return false;
    }

    final hasActualInternet = await _hasActualInternet();

    if (!hasActualInternet) {
      AppLogger.logger.e("ليس هناك اتصال حقيقي بالانترنت");
      return false;
    }

    AppLogger.logger.i(
      "بيانات الجوال او الواي فاي مفعل وهناك اتصال حقيقي بالانترنت",
    );
    return true;
  }

  // الفحص المطور باستخدام مكتبة internet_connection_checker_plus
  Future<bool> _hasActualInternet() async {
    // المكتبة تقوم داخلياً بعمل فحص لعدة عناوين (Google, Cloudflare)
    // وهذا يغنيك عن تمرير domainName واحد يدوياً
    bool result = await InternetConnection().hasInternetAccess;
    
    AppLogger.logger.d("نتيجة فحص الاتصال الحقيقي: $result");
    return result;
  }

  // فحص تفعيل الوايفاي أو البيانات (باستخدام التحديثات الأخيرة لـ connectivity_plus)
  Future<bool> _isWiFiOrPhoneDataActive() async {
    final List<ConnectivityResult> connectivityResult = 
        await (Connectivity().checkConnectivity());

    // ملاحظة: الإصدارات الجديدة من connectivity_plus تعيد List
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}