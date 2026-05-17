import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

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
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_id',
          'Prayer Times',
          channelDescription: 'Notifications for prayer times',
          importance: Importance.max,
          priority: Priority.high,
          // sound: RawResourceAndroidNotificationSound('adhan'),
        ),
        iOS: DarwinNotificationDetails(
          // sound: 'adhan.aiff',
        ),
      ),
      // المعاملات الجديدة والمطلوبة في إصدارك:
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          null, // لا نريد تكراراً تلقائياً لأن الأوقات تتغير يومياً
    );
  }
}
