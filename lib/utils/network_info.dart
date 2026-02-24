import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  static Future<bool> hasInvalidConnection() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    
    // إذا كانت القائمة تحتوي على none، فهذا يعني لا يوجد اتصال
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return true; // لا يوجد إنترنت
    }
    return false; // متصل (سواء واي فاي أو بيانات)
  }
}