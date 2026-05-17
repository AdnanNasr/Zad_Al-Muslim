import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/notifications/notification_service.dart';
import 'package:zad_al_muslim/domain/repositories/i_prayer_repository.dart';
import 'package:zad_al_muslim/domain/entities/prayer_time.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

class ScheduleAdkarNotification {
  static const int morningNotificationId = 10;
  static const int eveningNotificationId = 11;

  static final List<Map<String, String>> morningMessages = [
    {
      'title': 'أذكار الصباح 🌅',
      'body': 'ابدأ يومك بذكر الله لتحل البركة في وقتك وعملك.',
    },
    {
      'title': 'حصن يومك ✨',
      'body': 'أذكار الصباح حصن المسلم المنيع.. لا تفوتها اليوم.',
    },
    {
      'title': 'صباح الطمأنينة 🌿',
      'body': 'ألا بذكر الله تطمئن القلوب.. حان وقت أذكار الصباح.',
    },
  ];

  static final List<Map<String, String>> eveningMessages = [
    {
      'title': 'أذكار المساء 🌙',
      'body': 'اختم يومك بالذكر واشكر الله على نعمه.',
    },
    {
      'title': 'حصن ليلتك ✨',
      'body': 'أذكار المساء تحفظك حتى تصبح.. اقرأها الآن.',
    },
    {
      'title': 'مساء السكينة 🌿',
      'body': 'هدئ قلبك بعد يوم طويل بأذكار المساء.',
    },
  ];

  static Future<void> updateMorningSchedule({
    required bool isEnabled,
    required String? timeString,
  }) async {
    final notifications = NotificationService.plugin;

    if (!isEnabled) {
      await notifications.cancel(id: morningNotificationId);
      AppLogger.logger.i("تم إلغاء تفعيل تنبيه أذكار الصباح");
      return;
    }

    int targetHour = 0;
    int targetMinute = 0;

    if (timeString != null && timeString.contains(':')) {
      final parts = timeString.split(':');
      targetHour = int.tryParse(parts[0]) ?? 0;
      targetMinute = int.tryParse(parts[1]) ?? 0;
    } else {
      // إعداد افتراضي: وقت الفجر
      final repo = sl<IPrayerRepository>();
      final now = DateTime.now();

      final todayPrayers = await repo.getPrayersForDay(now);
      final fajr = todayPrayers
          .where((p) => p.prayerName == PrayerName.fajr)
          .firstOrNull;

      if (fajr != null) {
        final fajrLocal = fajr.time;
        targetHour = fajrLocal.hour;
        targetMinute = fajrLocal.minute;
      } else {
        targetHour = 5;
        targetMinute = 0;
      }
    }

    final randomData = morningMessages[Random().nextInt(morningMessages.length)];

    final tz.TZDateTime nowTz = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      nowTz.year,
      nowTz.month,
      nowTz.day,
      targetHour,
      targetMinute,
    );

    if (scheduledDate.isBefore(nowTz)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notifications.zonedSchedule(
      id: morningNotificationId,
      title: randomData['title'],
      body: randomData['body'],
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_adkar_id',
          'Morning Adkar Reminders',
          channelDescription: 'تنبيهات أذكار الصباح',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'morning_adkar_reminder',
    );

    AppLogger.logger.i(
      "تم جدولة أذكار الصباح يومياً الساعة ${targetHour.toString().padLeft(2, '0')}:${targetMinute.toString().padLeft(2, '0')}",
    );
  }

  static Future<void> updateEveningSchedule({
    required bool isEnabled,
    required String? timeString,
  }) async {
    final notifications = NotificationService.plugin;

    if (!isEnabled) {
      await notifications.cancel(id: eveningNotificationId);
      AppLogger.logger.i("تم إلغاء تفعيل تنبيه أذكار المساء");
      return;
    }

    int targetHour = 0;
    int targetMinute = 0;

    if (timeString != null && timeString.contains(':')) {
      final parts = timeString.split(':');
      targetHour = int.tryParse(parts[0]) ?? 0;
      targetMinute = int.tryParse(parts[1]) ?? 0;
    } else {
      // إعداد افتراضي: وقت المغرب
      final repo = sl<IPrayerRepository>();
      final now = DateTime.now();

      final todayPrayers = await repo.getPrayersForDay(now);
      final maghrib = todayPrayers
          .where((p) => p.prayerName == PrayerName.maghrib)
          .firstOrNull;

      if (maghrib != null) {
        final maghribLocal = maghrib.time;
        targetHour = maghribLocal.hour;
        targetMinute = maghribLocal.minute;
      } else {
        targetHour = 18;
        targetMinute = 0;
      }
    }

    final randomData = eveningMessages[Random().nextInt(eveningMessages.length)];

    final tz.TZDateTime nowTz = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      nowTz.year,
      nowTz.month,
      nowTz.day,
      targetHour,
      targetMinute,
    );

    if (scheduledDate.isBefore(nowTz)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notifications.zonedSchedule(
      id: eveningNotificationId,
      title: randomData['title'],
      body: randomData['body'],
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_adkar_id',
          'Evening Adkar Reminders',
          channelDescription: 'تنبيهات أذكار المساء',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'evening_adkar_reminder',
    );

    AppLogger.logger.i(
      "تم جدولة أذكار المساء يومياً الساعة ${targetHour.toString().padLeft(2, '0')}:${targetMinute.toString().padLeft(2, '0')}",
    );
  }
}
