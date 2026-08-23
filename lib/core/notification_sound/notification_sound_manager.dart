import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The notification categories that currently exist in the application.
enum NotificationSoundCategory {
  prayerTimes,
  quranReading,
  morningAdkar,
  eveningAdkar,
}

/// Prayer audio is deliberately limited to notification delivery concerns.
/// The future adhan player can set [adhan] without this class playing audio.
enum PrayerNotificationAudioMode { adhan, notification, silentVibration }

class NotificationSoundChannel {
  const NotificationSoundChannel({
    required this.category,
    required this.id,
    required this.name,
    required this.description,
    this.playSound = true,
    this.enableVibration = true,
  });

  final NotificationSoundCategory category;
  final String id;
  final String name;
  final String description;
  final bool playSound;
  final bool enableVibration;
}

/// Android channel registry and Android-settings launcher.
///
/// Android owns a channel's sound once it is created. This service therefore
/// creates stable channels with the system default sound and sends users to
/// Android's channel settings to choose a different installed system sound.
class NotificationSoundManager {
  NotificationSoundManager._();

  static const _settingsChannel = MethodChannel(
    'com.zad_al_muslim.adnan/notification_sound_settings',
  );
  static const prayerAudioModePreferenceKey = 'prayer_notification_audio_mode';

  // Existing IDs are retained for installed users. Never rename them.
  static const prayerTimes = NotificationSoundChannel(
    category: NotificationSoundCategory.prayerTimes,
    id: 'prayer_times_channel',
    name: 'مواقيت الصلاة',
    description: 'إشعارات أوقات الصلاة',
  );
  static const quranReading = NotificationSoundChannel(
    category: NotificationSoundCategory.quranReading,
    id: 'quran_reading_id',
    name: 'تنبيهات الورد القرآني',
    description: 'تنبيهات الورد القرآني اليومي',
  );
  static const morningAdkar = NotificationSoundChannel(
    category: NotificationSoundCategory.morningAdkar,
    id: 'morning_adkar_id',
    name: 'أذكار الصباح',
    description: 'تنبيهات أذكار الصباح',
  );
  static const eveningAdkar = NotificationSoundChannel(
    category: NotificationSoundCategory.eveningAdkar,
    id: 'evening_adkar_id',
    name: 'أذكار المساء',
    description: 'تنبيهات أذكار المساء',
  );

  // These channels have separate, stable purposes: they prevent a normal
  // notification sound from being layered over a future adhan or silent mode.
  static const prayerTimesAdhan = NotificationSoundChannel(
    category: NotificationSoundCategory.prayerTimes,
    id: 'prayer_times_adhan',
    name: 'مواقيت الصلاة - الأذان',
    description: 'إشعار مرئي عند تشغيل الأذان',
    playSound: false,
    enableVibration: false,
  );
  static const prayerTimesSilent = NotificationSoundChannel(
    category: NotificationSoundCategory.prayerTimes,
    id: 'prayer_times_silent_vibration',
    name: 'مواقيت الصلاة - اهتزاز صامت',
    description: 'إشعارات صلاة بالاهتزاز فقط',
    playSound: false,
  );

  static const channels = <NotificationSoundChannel>[
    prayerTimes,
    quranReading,
    morningAdkar,
    eveningAdkar,
    prayerTimesAdhan,
    prayerTimesSilent,
  ];

  static Future<void> ensureChannels(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    if (!Platform.isAndroid) return;
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;

    for (final channel in channels) {
      await android.createNotificationChannel(
        AndroidNotificationChannel(
          channel.id,
          channel.name,
          description: channel.description,
          importance: Importance.max,
          playSound: channel.playSound,
          enableVibration: channel.enableVibration,
        ),
      );
    }
  }

  static PrayerNotificationAudioMode prayerAudioMode(SharedPreferences prefs) {
    return switch (prefs.getString(prayerAudioModePreferenceKey)) {
      'adhan' => PrayerNotificationAudioMode.adhan,
      'silent_vibration' => PrayerNotificationAudioMode.silentVibration,
      _ => PrayerNotificationAudioMode.notification,
    };
  }

  /// Integration point for the future adhan feature. It stores only the mode,
  /// never a sound choice, because Android is the source of truth for sounds.
  static Future<void> setPrayerAudioMode(
    SharedPreferences prefs,
    PrayerNotificationAudioMode mode,
  ) => prefs.setString(prayerAudioModePreferenceKey, switch (mode) {
    PrayerNotificationAudioMode.adhan => 'adhan',
    PrayerNotificationAudioMode.notification => 'notification',
    PrayerNotificationAudioMode.silentVibration => 'silent_vibration',
  });

  static NotificationSoundChannel prayerChannelFor(
    PrayerNotificationAudioMode mode,
  ) => switch (mode) {
    PrayerNotificationAudioMode.notification => prayerTimes,
    PrayerNotificationAudioMode.adhan => prayerTimesAdhan,
    PrayerNotificationAudioMode.silentVibration => prayerTimesSilent,
  };

  static AndroidNotificationDetails androidDetails(
    NotificationSoundChannel channel, {
    String? icon,
  }) => AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    importance: Importance.max,
    priority: Priority.high,
    playSound: channel.playSound,
    enableVibration: channel.enableVibration,
    icon: icon,
  );

  static Future<void> openAppNotificationSettings() async {
    if (Platform.isAndroid) {
      await _settingsChannel.invokeMethod<void>('openApp');
    }
  }

  static Future<void> openChannelNotificationSettings(
    NotificationSoundChannel channel,
  ) async {
    if (Platform.isAndroid) {
      await _settingsChannel.invokeMethod<void>('openChannel', {
        'channelId': channel.id,
      });
    }
  }
}
