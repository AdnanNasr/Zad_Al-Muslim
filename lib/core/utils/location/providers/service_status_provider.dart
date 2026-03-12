import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// StreamProvider which listens to GPS service status changes (enabled/disabled)
final serviceStatusProvider = StreamProvider.autoDispose<ServiceStatus>((ref) {
  return Geolocator.getServiceStatusStream();
});
