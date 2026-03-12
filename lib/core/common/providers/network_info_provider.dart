import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/core/utils/network/network_info.dart';
import 'package:noor_quran/core/utils/location/providers/location_status_provider.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';

class NetworkInfoNotifier extends StateNotifier<NetworkInfoState> {
  final Ref ref;
  StreamSubscription? _subscription;

  NetworkInfoNotifier(this.ref) : super(NetworkInfoState.loading) {
    checkNetworkState();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        state = NetworkInfoState.connected;
        ref.read(locationStatusProvider.notifier).clearStatus();
      } else {
        state = NetworkInfoState.notConnected;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<bool> checkNetworkState() async {
    final isConnectionValid = await NetworkInfo().hasValidConnection();

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

