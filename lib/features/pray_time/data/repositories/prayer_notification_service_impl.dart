import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/prayer_times_entity.dart';
import '../../domain/repositories/prayer_notification_service.dart';
import '../../presentation/providers/schedule_prayer_time_notification.dart';

class PrayerNotificationServiceImpl implements IPrayerNotificationService {
  final SharedPreferences _prefs;

  PrayerNotificationServiceImpl(this._prefs);

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

    // 2. جدولة أذكار الصباح والمساء بعد الصلاة بـ 30 دقيقة
    final bool morningEnabled = _prefs.getBool('morning_adkar_key') ?? false;
    final bool eveningEnabled = _prefs.getBool('evening_adkar_key') ?? false;

    if (morningEnabled) {
      await SchedulePrayerTimeNotification.schedulePrayerNotification(
        id: 10,
        title: 'أذكار الصباح',
        time: prayerTimes.fajr.add(const Duration(minutes: 30)),
      );
    }

    if (eveningEnabled) {
      await SchedulePrayerTimeNotification.schedulePrayerNotification(
        id: 11,
        title: 'أذكار المساء',
        time: prayerTimes.asr.add(const Duration(minutes: 30)),
      );
    }
  }
}
