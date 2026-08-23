import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/core/notification_sound/notification_sound_manager.dart';
import 'package:zad_al_muslim/features/adhan/data/reciter_catalog.dart';
import 'package:zad_al_muslim/features/adhan/domain/reciter.dart';

class AdhanSettings {
  AdhanSettings(this._prefs);

  static const reciterPreferenceKey = 'adhan_reciter_id';
  final SharedPreferences _prefs;

  PrayerNotificationAudioMode get mode =>
      NotificationSoundManager.prayerAudioMode(_prefs);

  AdhanReciter get reciter =>
      AdhanReciterCatalog.byId(_prefs.getString(reciterPreferenceKey));

  Future<void> setMode(PrayerNotificationAudioMode value) =>
      NotificationSoundManager.setPrayerAudioMode(_prefs, value);

  Future<void> setReciter(AdhanReciter value) =>
      _prefs.setString(reciterPreferenceKey, value.id);
}
