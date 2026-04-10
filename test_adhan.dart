import 'package:adhan/adhan.dart';

void main() {
  final coordinates = Coordinates(37.3861, -122.0839); // Mountain View
  final date = DateComponents(2026, 4, 10);
  final params = CalculationMethod.muslim_world_league.getParameters();
  
  final prayerTimes = PrayerTimes(coordinates, date, params);
  
  print("Current Device TimeZone Offset: ${DateTime.now().timeZoneOffset}");
  print("Without passing utcOffset (adhan default):");
  print("Fajr: ${prayerTimes.fajr}");
  print("Dhuhr: ${prayerTimes.dhuhr}");
  
  print("\nWith PrayerTimes.utc():");
  final utcTimes = PrayerTimes.utc(coordinates, date, params);
  print("Fajr: ${utcTimes.fajr}");
  print("Dhuhr: ${utcTimes.dhuhr}");
  print("Fajr isUtc: ${utcTimes.fajr.isUtc}");
  
  print("\nWith PrayerTimes.utcOffset (passing -7 hours):");
  final offsetTimes = PrayerTimes.utcOffset(coordinates, date, params, Duration(hours: -7));
  print("Fajr: ${offsetTimes.fajr}");
  print("Fajr isUtc: ${offsetTimes.fajr.isUtc}");
}
