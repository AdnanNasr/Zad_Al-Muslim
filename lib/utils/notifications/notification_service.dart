import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. تهيئة المناطق الزمنية
    tz.initializeTimeZones();

    // 2. إعدادات الأندرويد
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 3. إعدادات iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // لاحظ هنا: قمنا بتمرير المتغير settings مباشرة
    await _notifications.initialize(settings:  settings);

    // 4. طلب صلاحيات الإشعارات (لأندرويد 13+)
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    await androidPlugin?.requestNotificationsPermission();

    // 5. إذن إضافي ضروري جداً للأذان (Exact Alarms)
    // هذا يفتح للمستخدم إعدادات النظام للسماح بالتنبيهات الدقيقة إذا لزم الأمر
    await androidPlugin?.requestExactAlarmsPermission();
  }
}