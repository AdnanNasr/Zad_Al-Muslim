import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/i_notification_scheduler.dart';

class NotificationSchedulerImpl implements INotificationScheduler {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationSchedulerImpl(this._notificationsPlugin);

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const settings = InitializationSettings(
      android: androidSettings, 
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
    );
  }

  @override
  Future<void> scheduleAll(List<PrayerTime> prayers) async {
    for (final prayer in prayers) {
      final id = _generateDeterministicId(prayer);
      
      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: _getPrayerTitle(prayer.prayerName),
        body: 'حان وقت أذان ${_getArabicPrayerName(prayer.prayerName)}',
        scheduledDate: tz.TZDateTime.from(prayer.utcTime, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_times_channel',
            'مواقيت الصلاة',
            channelDescription: 'إشعارات أوقات الصلاة',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('adhan'),
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            sound: 'adhan.aiff',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  @override
  Future<int> getScheduledCount() async {
    final pendingRequests = await _notificationsPlugin.pendingNotificationRequests();
    return pendingRequests.length;
  }

  int _generateDeterministicId(PrayerTime prayer) {
    // Format: YYYYMMDDN (where N is prayer index 1-5)
    final dateStr = DateFormat('yyyyMMdd').format(prayer.utcTime);
    return int.parse('$dateStr${prayer.prayerIndex}');
  }

  String _getPrayerTitle(PrayerName name) {
    switch (name) {
      case PrayerName.fajr: return 'صلاة الفجر';
      case PrayerName.dhuhr: return 'صلاة الظهر';
      case PrayerName.asr: return 'صلاة العصر';
      case PrayerName.maghrib: return 'صلاة المغرب';
      case PrayerName.isha: return 'صلاة العشاء';
    }
  }

  String _getArabicPrayerName(PrayerName name) {
    switch (name) {
      case PrayerName.fajr: return 'الفجر';
      case PrayerName.dhuhr: return 'الظهر';
      case PrayerName.asr: return 'العصر';
      case PrayerName.maghrib: return 'المغرب';
      case PrayerName.isha: return 'العشاء';
    }
  }
}
