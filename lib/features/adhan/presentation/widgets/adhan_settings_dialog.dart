import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/notification_sound/notification_sound_manager.dart';
import 'package:zad_al_muslim/domain/usecases/schedule_notifications_usecase.dart';
import 'package:zad_al_muslim/features/adhan/data/reciter_catalog.dart';
import 'package:zad_al_muslim/features/adhan/services/adhan_settings.dart';

class AdhanSettingsDialog extends StatefulWidget {
  const AdhanSettingsDialog({super.key});

  @override
  State<AdhanSettingsDialog> createState() => _AdhanSettingsDialogState();
}

class _AdhanSettingsDialogState extends State<AdhanSettingsDialog> {
  late final AdhanSettings _settings;
  late PrayerNotificationAudioMode _mode;
  late String _reciterId;

  @override
  void initState() {
    super.initState();
    _settings = AdhanSettings(sl<SharedPreferences>());
    _mode = _settings.mode;
    _reciterId = _settings.reciter.id;
  }

  Future<void> _save() async {
    await _settings.setMode(_mode);
    await _settings.setReciter(AdhanReciterCatalog.byId(_reciterId));
    await sl<ScheduleNotificationsUseCase>()(force: true);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('أصوات الصلاة', style: TextStyle(fontFamily: 'Cairo')),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'طريقة التنبيه',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...PrayerNotificationAudioMode.values.map(
            (mode) => RadioListTile<PrayerNotificationAudioMode>(
              value: mode,
              groupValue: _mode,
              onChanged: (value) => setState(() => _mode = value!),
              title: Text(switch (mode) {
                PrayerNotificationAudioMode.adhan => 'صوت الأذان',
                PrayerNotificationAudioMode.notification => 'صوت إشعار',
                PrayerNotificationAudioMode.silentVibration => 'اهتزاز صامت',
              }, style: const TextStyle(fontFamily: 'Cairo')),
            ),
          ),
          if (_mode == PrayerNotificationAudioMode.adhan) ...[
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _reciterId,
              decoration: const InputDecoration(labelText: 'المؤذن'),
              items: AdhanReciterCatalog.reciters
                  .map(
                    (reciter) => DropdownMenuItem(
                      value: reciter.id,
                      child: Text(
                        reciter.name,
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _reciterId = value!),
            ),
          ],
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(onPressed: _save, child: const Text('حفظ')),
    ],
  );
}
