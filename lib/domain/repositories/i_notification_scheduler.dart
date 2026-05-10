import '../entities/prayer_time.dart';

abstract class INotificationScheduler {
  Future<void> scheduleAll(List<PrayerTime> prayers);
  Future<void> cancelAll();
  Future<int> getScheduledCount();
}
