import '../entities/prayer_times_entity.dart';

abstract class IPrayerNotificationService {
  Future<void> scheduleDailyNotifications(PrayerTimesEntity prayerTimes);
}
