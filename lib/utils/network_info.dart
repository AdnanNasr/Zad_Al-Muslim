import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:noor_quran/utils/dotenv_util.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

class NetworkInfo {
  static Future<bool> hasValidConnection() async {
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

  // الفحص اذا كان هناك اتصال حقيقي بالانترنت
  static Future<bool> _hasActualInternet() async {
    final domainName = DotenvUtil.getEnvironmentVariables(
      key: "PING_DOMAIN",
      onNullValue: "google.com",
    );
    AppLogger.logger.d("Current Pinging domain is: $domainName");
    try {
      final result = await InternetAddress.lookup(
        domainName,
      ).timeout(Duration(seconds: 3));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } on Exception catch (_) {
      return false;
    }
    return false;
  }

  // الفحص اذا كان المستخدم قد قام بتفعيل بيانات الجوال او الواي فاي
  static Future<bool> _isWiFiOrPhoneDataActive() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}
