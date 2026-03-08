import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/core/utils/network_info.dart';
import 'package:noor_quran/view_models/providers/location_status_provider.dart';
import 'package:noor_quran/view_models/utils/app_logger.dart';

class NetworkInfoNotifier extends StateNotifier<NetworkInfoState> {
  final Ref ref;

  /// [ref] is provided by the caller so that we can read/refresh other
  /// providers from within the notifier methods. It replaces the previously
  /// undeclared `ref` variable.
  NetworkInfoNotifier(this.ref) : super(NetworkInfoState.loading) {
    checkNetworkState();
  }

  Future<bool> checkNetworkState() async {
    final isConnectionValid = await NetworkInfo.hasValidConnection();

    if (isConnectionValid) {
      state = NetworkInfoState.connected;
      AppLogger.logger.i("يوجد اتصال بالانترنت");
      // network is back - any previous location status might now be stale
      // (e.g. we were showing "no internet"), so clear it.
      ref.read(locationStatusProvider.notifier).clearStatus();
      return true;
    } else {
      state = NetworkInfoState.notConnected;
      AppLogger.logger.e("لا يوجد اتصال بالانترنت");
      return false;
    }
  }
}

final networkInfoProvider =
    StateNotifierProvider<NetworkInfoNotifier, NetworkInfoState>((ref) {
      ref.invalidate(locationStatusProvider);
      return NetworkInfoNotifier(ref);
    });
