import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/i_notification_scheduler.dart';
import '../../core/notification_sound/notification_sound_manager.dart';
import '../../features/adhan/services/adhan_alarm_scheduler.dart';
import '../../features/adhan/services/adhan_settings.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/notifications/notification_inbox_service.dart';

class NotificationSchedulerImpl implements INotificationScheduler {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final SharedPreferences _prefs;
  final AdhanAlarmScheduler _adhanAlarms = AdhanAlarmScheduler();

  NotificationSchedulerImpl(this._notificationsPlugin, this._prefs);

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings: settings);
    await NotificationSoundManager.ensureChannels(_notificationsPlugin);
  }

  @override
  Future<void> scheduleAll(List<PrayerTime> prayers) async {
    final bool globalEnabled =
        _prefs.getBool('prayer_notifications_enabled_key') ?? true;
    if (!globalEnabled) {
      await sl<NotificationInboxService>().replaceOneTimeSchedules([]);
      return;
    }

    final bool fajrEnabled = _prefs.getBool('fajr_notif_key') ?? true;
    final bool sunriseEnabled = _prefs.getBool('sunrise_notif_key') ?? false;
    final bool dhuhrEnabled = _prefs.getBool('dhuhr_notif_key') ?? true;
    final bool asrEnabled = _prefs.getBool('asr_notif_key') ?? true;
    final bool maghribEnabled = _prefs.getBool('maghrib_notif_key') ?? true;
    final bool ishaEnabled = _prefs.getBool('isha_notif_key') ?? true;

    final inboxSchedules = <Map<String, dynamic>>[];
    for (final prayer in prayers) {
      if (prayer.prayerName == PrayerName.fajr && !fajrEnabled) continue;
      if (prayer.prayerName == PrayerName.sunrise && !sunriseEnabled) continue;
      if (prayer.prayerName == PrayerName.dhuhr && !dhuhrEnabled) continue;
      if (prayer.prayerName == PrayerName.asr && !asrEnabled) continue;
      if (prayer.prayerName == PrayerName.maghrib && !maghribEnabled) continue;
      if (prayer.prayerName == PrayerName.isha && !ishaEnabled) continue;

      final id = _generateDeterministicId(prayer);
      final audioMode = NotificationSoundManager.prayerAudioMode(_prefs);

      // The notification remains scheduled through flutter_local_notifications.
      // Native Android playback is only armed for Adhan, preventing a channel
      // sound from being layered over the media audio.
      if (audioMode == PrayerNotificationAudioMode.adhan &&
          prayer.prayerName != PrayerName.sunrise) {
        await _adhanAlarms.schedule(
          id: id,
          time: prayer.time,
          isFajr: prayer.prayerName == PrayerName.fajr,
          reciter: AdhanSettings(_prefs).reciter,
        );
      } else {
        await _adhanAlarms.cancel(id);
      }

      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: _getPrayerTitle(prayer.prayerName),
        body: 'حان وقت صلاة ${_getArabicPrayerName(prayer.prayerName)}',
        scheduledDate: tz.TZDateTime.from(prayer.time, tz.local),
        notificationDetails: NotificationDetails(
          android: NotificationSoundManager.androidDetails(
            NotificationSoundManager.prayerChannelFor(audioMode),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            // sound: 'adhan.aiff', // تم تعطيله مؤقتاً لعدم وجود الملف // TODO: add adhan file
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      inboxSchedules.add({
        'id': 'prayer_$id',
        'title': _getPrayerTitle(prayer.prayerName),
        'body': 'حان وقت صلاة ${_getArabicPrayerName(prayer.prayerName)}',
        'scheduledAt': prayer.time.toIso8601String(),
      });
    }
    await sl<NotificationInboxService>().replaceOneTimeSchedules(
      inboxSchedules,
    );
  }

  @override
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
    await _adhanAlarms.cancelAll();
  }

  @override
  Future<int> getScheduledCount() async {
    final pendingRequests = await _notificationsPlugin
        .pendingNotificationRequests();
    return pendingRequests.length;
  }

  int _generateDeterministicId(PrayerTime prayer) {
    // Format: YYYYMMDDN (where N is prayer index 1-5)
    final dateStr = DateFormat('yyyyMMdd').format(prayer.time);
    return int.parse('$dateStr${prayer.prayerIndex}');
  }

  String _getPrayerTitle(PrayerName name) {
    switch (name) {
      case PrayerName.fajr:
        return 'صلاة الفجر';
      case PrayerName.sunrise:
        return 'شروق الشمس';
      case PrayerName.dhuhr:
        return 'صلاة الظهر';
      case PrayerName.asr:
        return 'صلاة العصر';
      case PrayerName.maghrib:
        return 'صلاة المغرب';
      case PrayerName.isha:
        return 'صلاة العشاء';
    }
  }

  String _getArabicPrayerName(PrayerName name) {
    switch (name) {
      case PrayerName.fajr:
        return 'الفجر';
      case PrayerName.sunrise:
        return 'الشروق';
      case PrayerName.dhuhr:
        return 'الظهر';
      case PrayerName.asr:
        return 'العصر';
      case PrayerName.maghrib:
        return 'المغرب';
      case PrayerName.isha:
        return 'العشاء';
    }
  }
}
