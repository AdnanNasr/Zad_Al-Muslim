import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/pray_time/presentation/providers/pray_times_provider.dart';
import 'package:zad_al_muslim/features/settings/presentation/providers/app_settings_provider.dart';

class PrayerNotificationSelectionDialog extends ConsumerWidget {
  const PrayerNotificationSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);
    final appSettingsNotifier = ref.read(appSettingsProvider.notifier);

    return AlertDialog(
      title: const Text(
        "تخصيص إشعارات الصلوات",
        style: TextStyle(fontFamily: 'Cairo'),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCheckboxTile(
              context,
              title: "صلاة الفجر",
              value: appSettings.fajrNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleFajrNotification();
                _invalidateProviders(ref);
              },
            ),
            _buildCheckboxTile(
              context,
              title: "شروق الشمس",
              value: appSettings.sunriseNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleSunriseNotification();
                _invalidateProviders(ref);
              },
            ),
            _buildCheckboxTile(
              context,
              title: "صلاة الظهر",
              value: appSettings.dhuhrNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleDhuhrNotification();
                _invalidateProviders(ref);
              },
            ),
            _buildCheckboxTile(
              context,
              title: "صلاة العصر",
              value: appSettings.asrNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleAsrNotification();
                _invalidateProviders(ref);
              },
            ),
            _buildCheckboxTile(
              context,
              title: "صلاة المغرب",
              value: appSettings.maghribNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleMaghribNotification();
                _invalidateProviders(ref);
              },
            ),
            _buildCheckboxTile(
              context,
              title: "صلاة العشاء",
              value: appSettings.ishaNotificationEnabled,
              onChanged: (val) async {
                await appSettingsNotifier.toggleIshaNotification();
                _invalidateProviders(ref);
              },
            ),
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
          onPressed: () => Navigator.pop(context),
          child: const Text("إغلاق", style: TextStyle(fontFamily: 'Cairo')),
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
        style: TextStyle(fontFamily: 'Cairo', fontSize: 14.sp),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: context.color.primary,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  void _invalidateProviders(WidgetRef ref) {
    ref.invalidate(todayPrayerTimesProvider);
    ref.invalidate(selectedDatePrayerTimesProvider);
  }
}
