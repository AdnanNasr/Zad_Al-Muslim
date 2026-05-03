import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:zad_al_muslim/core/database/isar_db.dart';
import 'package:zad_al_muslim/features/quran/data/models/mark.dart';
import 'package:zad_al_muslim/features/quran/presentation/pages/quran_pages.dart';
import 'package:zad_al_muslim/main.dart';
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

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == 'quran_reading_reminder') {
          _handleQuranReminder();
        }
      },
    );

    // 4. طلب صلاحيات الإشعارات (لأندرويد 13+)
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();

    // 5. إذن إضافي ضروري جداً للأذان (Exact Alarms)
    // هذا يفتح للمستخدم إعدادات النظام للسماح بالتنبيهات الدقيقة إذا لزم الأمر
    await androidPlugin?.requestExactAlarmsPermission();
  }

  static Future<void> _handleQuranReminder() async {
    // ننتظر حتى تكتمل واجهة المستخدم  (Navigator)
    while (appNavigatorKey.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // ننتظر قليلاً إضافياً لضمان تخطي شاشة البداية (Splash)
    await Future.delayed(const Duration(milliseconds: 2500));

    final db = IsarDb.database;
    int targetPage = 1;

    try {
      if (db != null) {
        final marks = await db.marks.where().findAll();
        if (marks.isNotEmpty) {
          // نأخذ آخر علامة تم حفظها
          targetPage = marks.last.pageNumber;
        }
      }
    } catch (_) {}

    // الانتقال لصفحة القرآن
    appNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => QuranPages(pageNumber: targetPage)),
    );
  }
}
