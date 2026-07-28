import 'package:shared_preferences/shared_preferences.dart';

class OnboardingInit {
  static const _key = 'has_seen_onboarding';
  static const _locationPromptSkippedKey = 'location_prompt_skipped';

  static Future<void> markAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  static Future<bool> hasSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> markLocationPromptSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationPromptSkippedKey, true);
  }

  static Future<bool> hasSkippedLocationPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationPromptSkippedKey) ?? false;
  }
}
