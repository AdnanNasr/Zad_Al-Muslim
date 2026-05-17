import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zad_al_muslim/core/utils/notifications/pending_notification_navigation.dart';
import 'notification_tap_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get plugin => _plugin;

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        NotificationTapHandler.handle(response.payload);
      },
    );

    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      final response = details!.notificationResponse;
      PendingNotificationNavigation.payload = response?.payload;
    }
  }
}
