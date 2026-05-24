import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/features/settings/presentation/providers/schedule_adkar_notification.dart';


class AppSettings {
  final double adkarFontSize;
  final bool use24HourFormat;
  final bool hapticFeedbackEnabled;
  final bool prayerNotificationsEnabled;
  final int calculationMethodIndex; // 0: Auto, 1-13: specific methods
  final int madhabIndex; // 0: Shafi/Standard, 1: Hanafi
  final bool morningAdkarReminder;
  final String? morningAdkarTime;
  final bool eveningAdkarReminder;
  final String? eveningAdkarTime;
  
  // Custom prayer notifications
  final bool fajrNotificationEnabled;
  final bool sunriseNotificationEnabled;
  final bool dhuhrNotificationEnabled;
  final bool asrNotificationEnabled;
  final bool maghribNotificationEnabled;
  final bool ishaNotificationEnabled;

  AppSettings({
    required this.adkarFontSize,
    required this.use24HourFormat,
    required this.hapticFeedbackEnabled,
    required this.prayerNotificationsEnabled,
    required this.calculationMethodIndex,
    required this.madhabIndex,
    required this.morningAdkarReminder,
    this.morningAdkarTime,
    required this.eveningAdkarReminder,
    this.eveningAdkarTime,
    required this.fajrNotificationEnabled,
    required this.sunriseNotificationEnabled,
    required this.dhuhrNotificationEnabled,
    required this.asrNotificationEnabled,
    required this.maghribNotificationEnabled,
    required this.ishaNotificationEnabled,
  });

  AppSettings copyWith({
    double? adkarFontSize,
    bool? use24HourFormat,
    bool? hapticFeedbackEnabled,
    bool? prayerNotificationsEnabled,
    int? calculationMethodIndex,
    int? madhabIndex,
    bool? morningAdkarReminder,
    String? morningAdkarTime,
    bool? eveningAdkarReminder,
    String? eveningAdkarTime,
    bool? fajrNotificationEnabled,
    bool? sunriseNotificationEnabled,
    bool? dhuhrNotificationEnabled,
    bool? asrNotificationEnabled,
    bool? maghribNotificationEnabled,
    bool? ishaNotificationEnabled,
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
      morningAdkarTime: morningAdkarTime ?? this.morningAdkarTime,
      eveningAdkarReminder: eveningAdkarReminder ?? this.eveningAdkarReminder,
      eveningAdkarTime: eveningAdkarTime ?? this.eveningAdkarTime,
      fajrNotificationEnabled: fajrNotificationEnabled ?? this.fajrNotificationEnabled,
      sunriseNotificationEnabled: sunriseNotificationEnabled ?? this.sunriseNotificationEnabled,
      dhuhrNotificationEnabled: dhuhrNotificationEnabled ?? this.dhuhrNotificationEnabled,
      asrNotificationEnabled: asrNotificationEnabled ?? this.asrNotificationEnabled,
      maghribNotificationEnabled: maghribNotificationEnabled ?? this.maghribNotificationEnabled,
      ishaNotificationEnabled: ishaNotificationEnabled ?? this.ishaNotificationEnabled,
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
  static const String _morningAdkarTimeKey = 'morning_adkar_time_key';
  static const String _eveningAdkarTimeKey = 'evening_adkar_time_key';
  
  static const String _fajrNotifKey = 'fajr_notif_key';
  static const String _sunriseNotifKey = 'sunrise_notif_key';
  static const String _dhuhrNotifKey = 'dhuhr_notif_key';
  static const String _asrNotifKey = 'asr_notif_key';
  static const String _maghribNotifKey = 'maghrib_notif_key';
  static const String _ishaNotifKey = 'isha_notif_key';

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
          morningAdkarTime: null,
          eveningAdkarReminder: false,
          eveningAdkarTime: null,
          fajrNotificationEnabled: true,
          sunriseNotificationEnabled: false,
          dhuhrNotificationEnabled: true,
          asrNotificationEnabled: true,
          maghribNotificationEnabled: true,
          ishaNotificationEnabled: true,
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
    final morningAdkarTime = _prefs.getString(_morningAdkarTimeKey);
    final eveningAdkar = _prefs.getBool(_eveningAdkarKey) ?? false;
    final eveningAdkarTime = _prefs.getString(_eveningAdkarTimeKey);

    final fajrNotif = _prefs.getBool(_fajrNotifKey) ?? true;
    final sunriseNotif = _prefs.getBool(_sunriseNotifKey) ?? false;
    final dhuhrNotif = _prefs.getBool(_dhuhrNotifKey) ?? true;
    final asrNotif = _prefs.getBool(_asrNotifKey) ?? true;
    final maghribNotif = _prefs.getBool(_maghribNotifKey) ?? true;
    final ishaNotif = _prefs.getBool(_ishaNotifKey) ?? true;

    state = AppSettings(
      adkarFontSize: fontSize,
      use24HourFormat: use24h,
      hapticFeedbackEnabled: haptic,
      prayerNotificationsEnabled: prayerNotif,
      calculationMethodIndex: calcMethod,
      madhabIndex: madhab,
      morningAdkarReminder: morningAdkar,
      morningAdkarTime: morningAdkarTime,
      eveningAdkarReminder: eveningAdkar,
      eveningAdkarTime: eveningAdkarTime,
      fajrNotificationEnabled: fajrNotif,
      sunriseNotificationEnabled: sunriseNotif,
      dhuhrNotificationEnabled: dhuhrNotif,
      asrNotificationEnabled: asrNotif,
      maghribNotificationEnabled: maghribNotif,
      ishaNotificationEnabled: ishaNotif,
    );

    if (morningAdkar) {
      ScheduleAdkarNotification.updateMorningSchedule(
        isEnabled: true,
        timeString: morningAdkarTime,
      );
    }
    if (eveningAdkar) {
      ScheduleAdkarNotification.updateEveningSchedule(
        isEnabled: true,
        timeString: eveningAdkarTime,
      );
    }
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

  Future<void> toggleFajrNotification() async {
    final newValue = !state.fajrNotificationEnabled;
    await _prefs.setBool(_fajrNotifKey, newValue);
    state = state.copyWith(fajrNotificationEnabled: newValue);
  }

  Future<void> toggleSunriseNotification() async {
    final newValue = !state.sunriseNotificationEnabled;
    await _prefs.setBool(_sunriseNotifKey, newValue);
    state = state.copyWith(sunriseNotificationEnabled: newValue);
  }

  Future<void> toggleDhuhrNotification() async {
    final newValue = !state.dhuhrNotificationEnabled;
    await _prefs.setBool(_dhuhrNotifKey, newValue);
    state = state.copyWith(dhuhrNotificationEnabled: newValue);
  }

  Future<void> toggleAsrNotification() async {
    final newValue = !state.asrNotificationEnabled;
    await _prefs.setBool(_asrNotifKey, newValue);
    state = state.copyWith(asrNotificationEnabled: newValue);
  }

  Future<void> toggleMaghribNotification() async {
    final newValue = !state.maghribNotificationEnabled;
    await _prefs.setBool(_maghribNotifKey, newValue);
    state = state.copyWith(maghribNotificationEnabled: newValue);
  }

  Future<void> toggleIshaNotification() async {
    final newValue = !state.ishaNotificationEnabled;
    await _prefs.setBool(_ishaNotifKey, newValue);
    state = state.copyWith(ishaNotificationEnabled: newValue);
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

    await ScheduleAdkarNotification.updateMorningSchedule(
      isEnabled: newValue,
      timeString: state.morningAdkarTime,
    );
  }

  Future<void> setMorningAdkarTime(String? time) async {
    if (time != null) {
      await _prefs.setString(_morningAdkarTimeKey, time);
    } else {
      await _prefs.remove(_morningAdkarTimeKey);
    }
    state = state.copyWith(morningAdkarTime: time);

    if (state.morningAdkarReminder) {
      await ScheduleAdkarNotification.updateMorningSchedule(
        isEnabled: true,
        timeString: time,
      );
    }
  }

  Future<void> toggleEveningAdkarReminder() async {
    final newValue = !state.eveningAdkarReminder;
    await _prefs.setBool(_eveningAdkarKey, newValue);
    state = state.copyWith(eveningAdkarReminder: newValue);

    await ScheduleAdkarNotification.updateEveningSchedule(
      isEnabled: newValue,
      timeString: state.eveningAdkarTime,
    );
  }

  Future<void> setEveningAdkarTime(String? time) async {
    if (time != null) {
      await _prefs.setString(_eveningAdkarTimeKey, time);
    } else {
      await _prefs.remove(_eveningAdkarTimeKey);
    }
    state = state.copyWith(eveningAdkarTime: time);

    if (state.eveningAdkarReminder) {
      await ScheduleAdkarNotification.updateEveningSchedule(
        isEnabled: true,
        timeString: time,
      );
    }
  }

  Future<void> resetSettings() async {
    await _prefs.remove(_adkarFontSizeKey);
    await _prefs.remove(_use24HourFormatKey);
    await _prefs.remove(_hapticFeedbackEnabledKey);
    await _prefs.remove('prayer_notifications_enabled_key');
    await _prefs.remove(_calculationMethodKey);
    await _prefs.remove(_madhabKey);
    await _prefs.remove(_morningAdkarKey);
    await _prefs.remove(_morningAdkarTimeKey);
    await _prefs.remove(_eveningAdkarKey);
    await _prefs.remove(_eveningAdkarTimeKey);
    
    await _prefs.remove(_fajrNotifKey);
    await _prefs.remove(_sunriseNotifKey);
    await _prefs.remove(_dhuhrNotifKey);
    await _prefs.remove(_asrNotifKey);
    await _prefs.remove(_maghribNotifKey);
    await _prefs.remove(_ishaNotifKey);
    
    state = AppSettings(
      adkarFontSize: 24.0,
      use24HourFormat: false,
      hapticFeedbackEnabled: true,
      prayerNotificationsEnabled: true,
      calculationMethodIndex: 0,
      madhabIndex: 0,
      morningAdkarReminder: false,
      morningAdkarTime: null,
      eveningAdkarReminder: false,
      eveningAdkarTime: null,
      fajrNotificationEnabled: true,
      sunriseNotificationEnabled: false,
      dhuhrNotificationEnabled: true,
      asrNotificationEnabled: true,
      maghribNotificationEnabled: true,
      ishaNotificationEnabled: true,
    );
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
      final prefs = sl<SharedPreferences>();
      return AppSettingsNotifier(prefs);
    });
