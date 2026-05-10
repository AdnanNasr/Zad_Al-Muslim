import '../entities/prayer_time.dart';

abstract class IPrayerRepository {
  Future<void> savePrayers(List<PrayerTime> prayers);
  Future<List<PrayerTime>> getPrayersForRange(DateTime from, DateTime to);
  Future<List<PrayerTime>> getPrayersForDay(DateTime date);
  Future<void> deleteAll();

  // For optimization: avoid redundant recalculations and scheduling
  Future<void> saveLastKnownLocation(double lat, double lng);
  Future<Map<String, double>?> getLastKnownLocation();
  Future<void> saveLastScheduleDate(DateTime date);
  Future<DateTime?> getLastScheduleDate();
}
