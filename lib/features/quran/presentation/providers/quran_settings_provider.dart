import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/constants/enums/qrai_names_ayah_by_ayah.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class QuranSettings {
  final bool keepScreenAwake;
  final int ayahDelaySeconds;
  final QariModel selectedQari;
  final int readingBackgroundColorIndex;

  QuranSettings({
    required this.keepScreenAwake,
    required this.ayahDelaySeconds,
    required this.selectedQari,
    required this.readingBackgroundColorIndex,
  });

  QuranSettings copyWith({
    bool? keepScreenAwake,
    int? ayahDelaySeconds,
    QariModel? selectedQari,
    int? readingBackgroundColorIndex,
  }) {
    return QuranSettings(
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      ayahDelaySeconds: ayahDelaySeconds ?? this.ayahDelaySeconds,
      selectedQari: selectedQari ?? this.selectedQari,
      readingBackgroundColorIndex: readingBackgroundColorIndex ?? this.readingBackgroundColorIndex,
    );
  }
}

class QuranSettingsNotifier extends StateNotifier<QuranSettings> {
  final SharedPreferences _prefs;
  
  static const String _keepScreenAwakeKey = 'keep_screen_awake_key';
  static const String _ayahDelayKey = 'ayah_delay_key';
  static const String _selectedQariIdKey = 'selected_qari_id_key';
  static const String _readingBackgroundColorIndexKey = 'reading_background_color_index_key';

  QuranSettingsNotifier(this._prefs) : super(QuranSettings(
    keepScreenAwake: false, 
    ayahDelaySeconds: 0, 
    selectedQari: QariNamesAyahByAyah.masharyAlafassy,
    readingBackgroundColorIndex: 0,
  )) {
    _init();
  }

  void _init() {
    final keepAwake = _prefs.getBool(_keepScreenAwakeKey) ?? false;
    final ayahDelay = _prefs.getInt(_ayahDelayKey) ?? 0;
    final qariId = _prefs.getString(_selectedQariIdKey);
    final bgColorIndex = _prefs.getInt(_readingBackgroundColorIndexKey) ?? 0;
    
    QariModel selectedQari = QariNamesAyahByAyah.masharyAlafassy;
    if (qariId != null) {
      try {
        selectedQari = QariNamesAyahByAyah.allQaris.firstWhere((q) => q.id == qariId);
      } catch (e) {
        // إذا لم نجد القارئ (ربما تم تغييره أو حذفه)، نستخدم الافتراضي
      }
    }
    
    state = QuranSettings(
      keepScreenAwake: keepAwake, 
      ayahDelaySeconds: ayahDelay,
      selectedQari: selectedQari,
      readingBackgroundColorIndex: bgColorIndex,
    );
    
    // تفعيل إضاءة الشاشة إذا كانت الميزة مفعلة مسبقاً
    if (keepAwake) {
      WakelockPlus.enable();
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
}

final quranSettingsProvider = StateNotifierProvider<QuranSettingsNotifier, QuranSettings>((ref) {
  final prefs = sl<SharedPreferences>();
  return QuranSettingsNotifier(prefs);
});
