import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/core/notification_sound/notification_sound_manager.dart';

class SchedulePrayerTimeNotification {
  static Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required DateTime time,
  }) async {
    final notifications = FlutterLocalNotificationsPlugin();

    // 1. التأكد من أن الوقت في المستقبل
    if (time.isBefore(DateTime.now())) return;

    // 2. تحويل DateTime إلى TZDateTime
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(time, tz.local);

    await notifications.zonedSchedule(
      id: id,
      title: 'حان الآن موعد صلاة $title',
      body: 'حي على الصلاة...',
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(
        android: NotificationSoundManager.androidDetails(
          NotificationSoundManager.prayerChannelFor(
            NotificationSoundManager.prayerAudioMode(sl<SharedPreferences>()),
          ),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      // المعاملات الجديدة والمطلوبة في إصدارك:
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          null, // لا نريد تكراراً تلقائياً لأن الأوقات تتغير يومياً
    );
  }
}
