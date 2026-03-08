import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationStatusProvider
    extends StateNotifier<Map<LocationMessage, String>> {
  LocationStatusProvider() : super({});

  void setStatus(Map<LocationMessage, String> status) {
    if (status.isNotEmpty) {
      state = status;
    }
  }

  /// Clears any stored status. Useful when the underlying issue has been
  /// resolved (e.g. permissions granted or network restored) so that the UI
  /// no longer treats the app as being in an error state.
  void clearStatus() {
    state = {};
  }
}

final locationStatusProvider =
    StateNotifierProvider<LocationStatusProvider, Map<LocationMessage, String>>(
      (ref) {
        return LocationStatusProvider();
      },
    );
