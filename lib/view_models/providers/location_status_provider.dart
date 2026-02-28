import 'package:noor_quran/utils/location_locator.dart';
import 'package:riverpod/riverpod.dart';

class LocationStatusProvider
    extends StateNotifier<Map<LocationMessage, String>> {
  LocationStatusProvider() : super({});

  void setStatus(Map<LocationMessage, String> status) {
    if (status.isNotEmpty) {
      state = status;
    }
  }
}

final locationStatusProvider =
    StateNotifierProvider<LocationStatusProvider, Map<LocationMessage, String>>(
      (ref) {
        return LocationStatusProvider();
      },
    );
