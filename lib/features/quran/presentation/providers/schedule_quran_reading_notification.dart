import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/notifications/notification_service.dart';
import 'package:zad_al_muslim/domain/repositories/i_prayer_repository.dart';
import 'package:zad_al_muslim/domain/entities/prayer_time.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';

class ScheduleQuranReadingNotification {
  static const int notificationId = 9999;

  static final List<Map<String, String>> messages = [
    {
      'title': 'أنِر يومك بالقرآن 📖',
      'body': 'اجعل لقلبك نصيباً من الطمأنينة اليوم.. وردك القرآني في انتظارك.',
    },
    {
      'title': 'أحب الأعمال إلى الله.. ✨',
      'body':
          'قليلٌ دائم خير من كثير منقطع. دقائق مع وردك ستصنع فرقاً في يومك.',
    },
    {
      'title': 'طمأنينة لروحك 🌿',
      'body':
          '"ألا بذكر الله تطمئن القلوب".. حان موعد وردك، استقطع وقتاً لنفسك مع كلام الله.',
    },
    {
      'title': 'وردك القرآني ⚡',
      'body': 'لا تنسَ نصيبك من البركة اليوم. ابدأ تلاوتك الآن.',
    },
  ];

  static Future<void> updateSchedule({
    required bool isEnabled,
    required String? timeString,
  }) async {
    final notifications = NotificationService.plugin;

    if (!isEnabled) {
      await notifications.cancel(id: notificationId);
      AppLogger.logger.i("تم إلغاء تفعيل تنبيه ورد القرآن");
      return;
    }

    int targetHour = 0;
    int targetMinute = 0;

    if (timeString != null && timeString.contains(':')) {
      final parts = timeString.split(':');
      targetHour = int.tryParse(parts[0]) ?? 0;
      targetMinute = int.tryParse(parts[1]) ?? 0;
    } else {
      // إعداد افتراضي: بعد صلاة الفجر بنصف ساعة
      final repo = sl<IPrayerRepository>();
      final now = DateTime.now();

      final todayPrayers = await repo.getPrayersForDay(now);
      final fajr = todayPrayers
          .where((p) => p.prayerName == PrayerName.fajr)
          .firstOrNull;

      if (fajr != null) {
        final fajrLocal = fajr.time;
        // حساب الفجر والدقائق
        targetHour = fajrLocal.hour;
        targetMinute = fajrLocal.minute;

        // إضافة 30 دقيقة
        targetMinute += 30;
        if (targetMinute >= 60) {
          targetHour += 1;
          targetMinute -= 60;
        }
      } else {
        // احتياطي إذا لم توجد مواقيت: 5:00 صباحاً
        targetHour = 5;
        targetMinute = 0;
      }
    }

    final randomData = messages[Random().nextInt(messages.length)];

    // إنشاء تكرار يومي في التوقيت المحسوب
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
      id: notificationId,
      title: randomData['title'],
      body: randomData['body'],
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'quran_reading_id',
          'Quran Reading Reminders',
          channelDescription: 'تنبيهات الورد القرآني اليومي',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'quran_reading_reminder',
    );

    AppLogger.logger.i(
      "تم جدولة ورد القرآن يومياً الساعة $targetHour:$targetMinute",
    );
  }
}
