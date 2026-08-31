import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/notification_sound/notification_sound_manager.dart';
import 'package:zad_al_muslim/features/adhan/data/reciter_catalog.dart';
import 'package:zad_al_muslim/features/adhan/services/adhan_settings.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/pray_times_provider.dart';
import 'package:zad_al_muslim/features/settings/presentation/providers/app_settings_provider.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../domain/usecases/schedule_notifications_usecase.dart';

class PrayerNotificationSelectionDialog extends ConsumerStatefulWidget {
  final AdhanSettings? _settings;
  final PrayerNotificationAudioMode? _mode;
  String? reciterId;

  PrayerNotificationSelectionDialog({
    super.key,
    AdhanSettings? settings,
    PrayerNotificationAudioMode? mode,
    String? reciterId,
  }) : _settings = settings,
       _mode = mode,
       reciterId = reciterId;

  @override
  ConsumerState<PrayerNotificationSelectionDialog> createState() =>
      _PrayerNotificationSelectionDialogState();
}

class _PrayerNotificationSelectionDialogState
    extends ConsumerState<PrayerNotificationSelectionDialog> {
  Future<void> _save() async {
    if (widget._settings != null &&
        widget._mode != null &&
        widget.reciterId != null) {
      await widget._settings?.setMode(widget._mode!);
      await widget._settings?.setReciter(
        AdhanReciterCatalog.byId(widget.reciterId),
      );
      await sl<ScheduleNotificationsUseCase>()(force: true);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsProvider);
    final appSettingsNotifier = ref.read(appSettingsProvider.notifier);

    final isAdhanMode = widget._mode == PrayerNotificationAudioMode.adhan;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      title: const Text(
        'تخصيص إشعارات الصلوات',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCheckboxTile(
              context,
              title: 'صلاة الفجر',
              value: appSettings.fajrNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleFajrNotification();
                _invalidateProviders(ref);
              },
            ),

            _buildCheckboxTile(
              context,
              title: 'شروق الشمس',
              value: appSettings.sunriseNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleSunriseNotification();
                _invalidateProviders(ref);
              },
            ),

            _buildCheckboxTile(
              context,
              title: 'صلاة الظهر',
              value: appSettings.dhuhrNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleDhuhrNotification();
                _invalidateProviders(ref);
              },
            ),

            _buildCheckboxTile(
              context,
              title: 'صلاة العصر',
              value: appSettings.asrNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleAsrNotification();
                _invalidateProviders(ref);
              },
            ),

            _buildCheckboxTile(
              context,
              title: 'صلاة المغرب',
              value: appSettings.maghribNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleMaghribNotification();
                _invalidateProviders(ref);
              },
            ),

            _buildCheckboxTile(
              context,
              title: 'صلاة العشاء',
              value: appSettings.ishaNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleIshaNotification();
                _invalidateProviders(ref);
              },
            ),

            if (isAdhanMode) ...[
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: widget.reciterId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'المؤذن',
                  border: OutlineInputBorder(),
                ),
                items: AdhanReciterCatalog.reciters
                    .map(
                      (reciter) => DropdownMenuItem<String>(
                        value: reciter.id,
                        child: Text(
                          reciter.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    widget.reciterId = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll<Color>(
              context.color.onSurface,
            ),
          ),
          onPressed: () {
            _save();
            Navigator.pop(context);
          },
          child: const Text(
            'إغلاق',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxTile(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: context.color.primary,
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  void _invalidateProviders(WidgetRef ref) {
    ref.invalidate(todayPrayerTimesProvider);
    ref.invalidate(selectedDatePrayerTimesProvider);
  }
}
