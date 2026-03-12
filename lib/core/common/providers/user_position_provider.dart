import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:geolocator/geolocator.dart";
import "package:noor_quran/core/constants/shared_pref_keys.dart";

import "package:noor_quran/core/di/injection_container.dart";
import "package:shared_preferences/shared_preferences.dart";

final userPositionProvider = StateProvider<Position?>((ref) {
  final prefs = sl<SharedPreferences>();
  final lat = prefs.getDouble(SharedPrefKeys.lat);
  final long = prefs.getDouble(SharedPrefKeys.long);

  if (lat != null && long != null) {
    return Position(
      latitude: lat,
      longitude: long,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }
  return null;
});