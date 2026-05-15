import 'notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPermissionService {
  static Future<void> request() async {
    final android = NotificationService.plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }
}
