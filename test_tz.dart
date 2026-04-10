import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  
  final lat = 37.38;
  final lng = -122.08;
  
  String tzName = tzmap.latLngToTimezoneString(lat, lng);
  print('Timezone Name: $tzName');
  
  final location = tz.getLocation(tzName);
  final date = DateTime.utc(2026, 4, 10);
  final tzDate = tz.TZDateTime.from(date, location);
  
  print('TimeZone Offset: ${tzDate.timeZoneOffset}');
}
