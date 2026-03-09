import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../../domain/repositories/prayer_notification_service.dart';
import '../../presentation/providers/schedule_prayer_time_notification.dart';

class PrayerNotificationServiceImpl implements IPrayerNotificationService {
  @override
  Future<void> scheduleDailyNotifications(PrayerTimesEntity prayerTimes) async {
    // 1. مسح أي إشعارات قديمة مجدولة
    await FlutterLocalNotificationsPlugin().cancelAll();

    final Map<String, DateTime> prayers = {
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    int idCounter = 0;
    for (var entry in prayers.entries) {
      await SchedulePrayerTimeNotification.schedulePrayerNotification(
        id: idCounter++,
        title: entry.key,
        time: entry.value,
      );
    }
  }
}
