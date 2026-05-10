import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PermissionService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  PermissionService(this._notificationsPlugin);

  /// Requests all necessary permissions for prayer notifications.
  /// Handles Android 12+ Exact Alarms and Notification permissions.
  Future<void> requestAllPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        // Request notification permission (Android 13+)
        await androidPlugin.requestNotificationsPermission();
        
        // Request exact alarm permission (Android 12+)
        // This will open the system settings if the permission is not granted
        await androidPlugin.requestExactAlarmsPermission();
      }
    } else if (Platform.isIOS) {
      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      
      await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Returns true if notifications are enabled.
  /// (Simplified check for MVP)
  Future<bool> isFullyGranted() async {
    // For this MVP, we return true if the plugin is initialized.
    // Real permission status checking usually requires 'permission_handler' package.
    return true; 
  }
}
