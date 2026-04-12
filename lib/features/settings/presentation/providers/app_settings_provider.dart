import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final double adkarFontSize;
  final bool use24HourFormat;
  final bool hapticFeedbackEnabled;
  final bool prayerNotificationsEnabled;
  final int calculationMethodIndex; // 0: Auto, 1-13: specific methods
  final int madhabIndex; // 0: Shafi/Standard, 1: Hanafi
  final bool morningAdkarReminder;
  final bool eveningAdkarReminder;

  AppSettings({
    required this.adkarFontSize,
    required this.use24HourFormat,
    required this.hapticFeedbackEnabled,
    required this.prayerNotificationsEnabled,
    required this.calculationMethodIndex,
    required this.madhabIndex,
    required this.morningAdkarReminder,
    required this.eveningAdkarReminder,
  });

  AppSettings copyWith({
    double? adkarFontSize,
    bool? use24HourFormat,
    bool? hapticFeedbackEnabled,
    bool? prayerNotificationsEnabled,
    int? calculationMethodIndex,
    int? madhabIndex,
    bool? morningAdkarReminder,
    bool? eveningAdkarReminder,
  }) {
    return AppSettings(
      adkarFontSize: adkarFontSize ?? this.adkarFontSize,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      prayerNotificationsEnabled:
          prayerNotificationsEnabled ?? this.prayerNotificationsEnabled,
      calculationMethodIndex:
          calculationMethodIndex ?? this.calculationMethodIndex,
      madhabIndex: madhabIndex ?? this.madhabIndex,
      morningAdkarReminder: morningAdkarReminder ?? this.morningAdkarReminder,
      eveningAdkarReminder: eveningAdkarReminder ?? this.eveningAdkarReminder,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;

  static const String _adkarFontSizeKey = 'adkar_font_size_key';
  static const String _use24HourFormatKey = 'use_24_hour_format_key';
  static const String _hapticFeedbackEnabledKey = 'haptic_feedback_enabled_key';
  static const String _calculationMethodKey = 'calculation_method_key';
  static const String _madhabKey = 'madhab_key';
  static const String _morningAdkarKey = 'morning_adkar_key';
  static const String _eveningAdkarKey = 'evening_adkar_key';

  AppSettingsNotifier(this._prefs)
    : super(
        AppSettings(
          adkarFontSize: 24.0,
          use24HourFormat: false,
          hapticFeedbackEnabled: true,
          prayerNotificationsEnabled: true,
          calculationMethodIndex: 0,
          madhabIndex: 0,
          morningAdkarReminder: false,
          eveningAdkarReminder: false,
        ),
      ) {
    _init();
  }

  void _init() {
    final fontSize = _prefs.getDouble(_adkarFontSizeKey) ?? 24.0;
    final use24h = _prefs.getBool(_use24HourFormatKey) ?? false;
    final haptic = _prefs.getBool(_hapticFeedbackEnabledKey) ?? true;
    final prayerNotif =
        _prefs.getBool('prayer_notifications_enabled_key') ?? true;
    final calcMethod = _prefs.getInt(_calculationMethodKey) ?? 0;
    final madhab = _prefs.getInt(_madhabKey) ?? 0;
    final morningAdkar = _prefs.getBool(_morningAdkarKey) ?? false;
    final eveningAdkar = _prefs.getBool(_eveningAdkarKey) ?? false;

    state = AppSettings(
      adkarFontSize: fontSize,
      use24HourFormat: use24h,
      hapticFeedbackEnabled: haptic,
      prayerNotificationsEnabled: prayerNotif,
      calculationMethodIndex: calcMethod,
      madhabIndex: madhab,
      morningAdkarReminder: morningAdkar,
      eveningAdkarReminder: eveningAdkar,
    );
  }

  Future<void> setAdkarFontSize(double size) async {
    await _prefs.setDouble(_adkarFontSizeKey, size);
    state = state.copyWith(adkarFontSize: size);
  }

  Future<void> toggle24HourFormat() async {
    final newValue = !state.use24HourFormat;
    await _prefs.setBool(_use24HourFormatKey, newValue);
    state = state.copyWith(use24HourFormat: newValue);
  }

  Future<void> toggleHapticFeedback() async {
    final newValue = !state.hapticFeedbackEnabled;
    await _prefs.setBool(_hapticFeedbackEnabledKey, newValue);
    state = state.copyWith(hapticFeedbackEnabled: newValue);
  }

  Future<void> togglePrayerNotifications() async {
    final newValue = !state.prayerNotificationsEnabled;
    await _prefs.setBool('prayer_notifications_enabled_key', newValue);
    state = state.copyWith(prayerNotificationsEnabled: newValue);
  }

  Future<void> setCalculationMethod(int methodIndex) async {
    await _prefs.setInt(_calculationMethodKey, methodIndex);
    state = state.copyWith(calculationMethodIndex: methodIndex);
  }

  Future<void> setMadhab(int madhabIndex) async {
    await _prefs.setInt(_madhabKey, madhabIndex);
    state = state.copyWith(madhabIndex: madhabIndex);
  }

  Future<void> toggleMorningAdkarReminder() async {
    final newValue = !state.morningAdkarReminder;
    await _prefs.setBool(_morningAdkarKey, newValue);
    state = state.copyWith(morningAdkarReminder: newValue);
  }

  Future<void> toggleEveningAdkarReminder() async {
    final newValue = !state.eveningAdkarReminder;
    await _prefs.setBool(_eveningAdkarKey, newValue);
    state = state.copyWith(eveningAdkarReminder: newValue);
  }

  Future<void> resetSettings() async {
    await _prefs.remove(_adkarFontSizeKey);
    await _prefs.remove(_use24HourFormatKey);
    await _prefs.remove(_hapticFeedbackEnabledKey);
    await _prefs.remove('prayer_notifications_enabled_key');
    await _prefs.remove(_calculationMethodKey);
    await _prefs.remove(_madhabKey);
    await _prefs.remove(_morningAdkarKey);
    await _prefs.remove(_eveningAdkarKey);
    state = AppSettings(
      adkarFontSize: 24.0,
      use24HourFormat: false,
      hapticFeedbackEnabled: true,
      prayerNotificationsEnabled: true,
      calculationMethodIndex: 0,
      madhabIndex: 0,
      morningAdkarReminder: false,
      eveningAdkarReminder: false,
    );
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
      final prefs = sl<SharedPreferences>();
      return AppSettingsNotifier(prefs);
    });
