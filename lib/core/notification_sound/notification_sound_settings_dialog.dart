import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';

import 'notification_sound_manager.dart';

class NotificationSoundSettingsDialog extends StatelessWidget {
  const NotificationSoundSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = NotificationSoundManager.prayerAudioMode(
      sl<SharedPreferences>(),
    );
    final entries =
        <({NotificationSoundChannel channel, String title, String subtitle})>[
          (
            channel: NotificationSoundManager.prayerChannelFor(mode),
            title: 'مواقيت الصلاة',
            subtitle: switch (mode) {
              PrayerNotificationAudioMode.adhan =>
                'صوت الأذان: لا يُضاف صوت إشعار',
              PrayerNotificationAudioMode.silentVibration =>
                'اهتزاز صامت: لا يُشغّل صوت',
              PrayerNotificationAudioMode.notification =>
                'صوت إشعار: يحدده نظام Android',
            },
          ),
          (
            channel: NotificationSoundManager.quranReading,
            title: 'الورد القرآني',
            subtitle: 'يحدده نظام Android',
          ),
          (
            channel: NotificationSoundManager.morningAdkar,
            title: 'أذكار الصباح',
            subtitle: 'يحدده نظام Android',
          ),
          (
            channel: NotificationSoundManager.eveningAdkar,
            title: 'أذكار المساء',
            subtitle: 'يحدده نظام Android',
          ),
        ];

    return AlertDialog(
      title: const Text(
        'أصوات الإشعارات',
        style: TextStyle(fontFamily: 'Cairo'),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              'يُدار اختيار الصوت من إعدادات Android الخاصة بكل نوع إشعار.',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 8),
            ...entries.map(
              (entry) => ListTile(
                title: Text(
                  entry.title,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                subtitle: Text(
                  entry.subtitle,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                trailing: const Icon(Icons.open_in_new_rounded),
                onTap: () =>
                    NotificationSoundManager.openChannelNotificationSettings(
                      entry.channel,
                    ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        const TextButton(
          onPressed: NotificationSoundManager.openAppNotificationSettings,
          child: Text('إعدادات إشعارات التطبيق'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}
