import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/constants/enums/qrai_names_ayah_by_ayah.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/quran/presentation/providers/schedule_quran_reading_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum QuranViewType { fixed, zoomable }

class QuranSettings {
  final bool keepScreenAwake;
  final int ayahDelaySeconds;
  final QariModel selectedQari;
  final int readingBackgroundColorIndex;
  final bool autoScrollWithAudio;
  final bool isDailyReminderEnabled;
  final String? dailyReminderTime;
  final QuranViewType quranViewType;
  final double quranVerticalFontSize;

  QuranSettings({
    required this.keepScreenAwake,
    required this.ayahDelaySeconds,
    required this.selectedQari,
    required this.readingBackgroundColorIndex,
    required this.autoScrollWithAudio,
    required this.isDailyReminderEnabled,
    this.dailyReminderTime,
    this.quranViewType = QuranViewType.fixed,
    this.quranVerticalFontSize = 22.0,
  });

  QuranSettings copyWith({
    bool? keepScreenAwake,
    int? ayahDelaySeconds,
    QariModel? selectedQari,
    int? readingBackgroundColorIndex,
    bool? autoScrollWithAudio,
    bool? isDailyReminderEnabled,
    String? dailyReminderTime,
    QuranViewType? quranViewType,
    double? quranVerticalFontSize,
  }) {
    return QuranSettings(
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      ayahDelaySeconds: ayahDelaySeconds ?? this.ayahDelaySeconds,
      selectedQari: selectedQari ?? this.selectedQari,
      readingBackgroundColorIndex:
          readingBackgroundColorIndex ?? this.readingBackgroundColorIndex,
      autoScrollWithAudio: autoScrollWithAudio ?? this.autoScrollWithAudio,
      isDailyReminderEnabled:
          isDailyReminderEnabled ?? this.isDailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      quranViewType: quranViewType ?? this.quranViewType,
      quranVerticalFontSize:
          quranVerticalFontSize ?? this.quranVerticalFontSize,
    );
  }
}

class QuranSettingsNotifier extends StateNotifier<QuranSettings> {
  final SharedPreferences _prefs;

  static const String _keepScreenAwakeKey = 'keep_screen_awake_key';
  static const String _ayahDelayKey = 'ayah_delay_key';
  static const String _selectedQariIdKey = 'selected_qari_id_key';
  static const String _readingBackgroundColorIndexKey =
      'reading_background_color_index_key';
  static const String _autoScrollWithAudioKey = 'auto_scroll_with_audio_key';
  static const String _isDailyReminderEnabledKey =
      'is_daily_reminder_enabled_key';
  static const String _dailyReminderTimeKey = 'daily_reminder_time_key';
  static const String _quranViewTypeKey = 'quran_view_type_key';
  static const String _quranVerticalFontSizeKey =
      'quran_vertical_font_size_key';

  QuranSettingsNotifier(this._prefs)
    : super(
        QuranSettings(
          keepScreenAwake: false,
          ayahDelaySeconds: 0,
          selectedQari: QariNamesAyahByAyah.masharyAlafassy,
          readingBackgroundColorIndex: 0,
          autoScrollWithAudio: true,
          isDailyReminderEnabled: false,
          dailyReminderTime: null,
          quranViewType: QuranViewType.fixed,
          quranVerticalFontSize: 22.0,
        ),
      ) {
    _init();
  }

  void _init() {
    final keepAwake = _prefs.getBool(_keepScreenAwakeKey) ?? true;
    final ayahDelay = _prefs.getInt(_ayahDelayKey) ?? 0;
    final qariId = _prefs.getString(_selectedQariIdKey);
    final bgColorIndex = _prefs.getInt(_readingBackgroundColorIndexKey) ?? 0;
    final autoScroll = _prefs.getBool(_autoScrollWithAudioKey) ?? true;
    final isDailyReminderEnabled =
        _prefs.getBool(_isDailyReminderEnabledKey) ?? false;
    final dailyReminderTime = _prefs.getString(_dailyReminderTimeKey);
    final viewTypeIndex = _prefs.getInt(_quranViewTypeKey) ?? 0;
    final quranViewType = QuranViewType.values[viewTypeIndex];
    final quranVerticalFontSize =
        _prefs.getDouble(_quranVerticalFontSizeKey) ?? 22.0;

    QariModel selectedQari = QariNamesAyahByAyah.masharyAlafassy;
    if (qariId != null) {
      try {
        selectedQari = QariNamesAyahByAyah.allQaris.firstWhere(
          (q) => q.id == qariId,
        );
      } catch (e) {
        // إذا لم نجد القارئ (ربما تم تغييره أو حذفه)، نستخدم الافتراضي
      }
    }

    state = QuranSettings(
      keepScreenAwake: keepAwake,
      ayahDelaySeconds: ayahDelay,
      selectedQari: selectedQari,
      readingBackgroundColorIndex: bgColorIndex,
      autoScrollWithAudio: autoScroll,
      isDailyReminderEnabled: isDailyReminderEnabled,
      dailyReminderTime: dailyReminderTime,
      quranViewType: quranViewType,
      quranVerticalFontSize: quranVerticalFontSize,
    );

    // تفعيل إضاءة الشاشة إذا كانت الميزة مفعلة مسبقاً
    if (keepAwake) {
      WakelockPlus.enable();
    }

    // تفعيل مهام التذكير المجدولة إذا كانت مفعلة
    if (isDailyReminderEnabled) {
      ScheduleQuranReadingNotification.updateSchedule(
        isEnabled: true,
        timeString: dailyReminderTime,
      );
    }
  }

  Future<void> toggleKeepScreenAwake() async {
    final newValue = !state.keepScreenAwake;
    await _prefs.setBool(_keepScreenAwakeKey, newValue);
    state = state.copyWith(keepScreenAwake: newValue);

    if (newValue) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  Future<void> setAyahDelay(int seconds) async {
    await _prefs.setInt(_ayahDelayKey, seconds);
    state = state.copyWith(ayahDelaySeconds: seconds);
  }

  Future<void> setSelectedQari(QariModel qari) async {
    await _prefs.setString(_selectedQariIdKey, qari.id);
    state = state.copyWith(selectedQari: qari);
  }

  Future<void> setReadingBackgroundColorIndex(int index) async {
    await _prefs.setInt(_readingBackgroundColorIndexKey, index);
    state = state.copyWith(readingBackgroundColorIndex: index);
  }

  Future<void> toggleAutoScrollWithAudio() async {
    final newValue = !state.autoScrollWithAudio;
    await _prefs.setBool(_autoScrollWithAudioKey, newValue);
    state = state.copyWith(autoScrollWithAudio: newValue);
  }

  Future<void> toggleDailyReminder() async {
    final newValue = !state.isDailyReminderEnabled;
    await _prefs.setBool(_isDailyReminderEnabledKey, newValue);
    state = state.copyWith(isDailyReminderEnabled: newValue);

    await ScheduleQuranReadingNotification.updateSchedule(
      isEnabled: newValue,
      timeString: state.dailyReminderTime,
    );
  }

  Future<void> setDailyReminderTime(String? time) async {
    if (time != null) {
      await _prefs.setString(_dailyReminderTimeKey, time);
    } else {
      await _prefs.remove(_dailyReminderTimeKey);
    }
    state = state.copyWith(dailyReminderTime: time);

    if (state.isDailyReminderEnabled) {
      await ScheduleQuranReadingNotification.updateSchedule(
        isEnabled: true,
        timeString: time,
      );
    }
  }

  Future<void> setQuranViewType(QuranViewType type) async {
    await _prefs.setInt(_quranViewTypeKey, type.index);
    state = state.copyWith(quranViewType: type);
  }

  Future<void> setQuranVerticalFontSize(double size) async {
    final clamped = size.clamp(14.0, 40.0);
    await _prefs.setDouble(_quranVerticalFontSizeKey, clamped);
    state = state.copyWith(quranVerticalFontSize: clamped);
  }
}

final quranSettingsProvider =
    StateNotifierProvider<QuranSettingsNotifier, QuranSettings>((ref) {
      final prefs = sl<SharedPreferences>();
      return QuranSettingsNotifier(prefs);
    });
