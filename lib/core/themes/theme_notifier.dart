import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/utils/log/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color kDefaultScheme = Colors.indigo;

class ThemeNotifier extends StateNotifier<Color> {
  ThemeNotifier() : super(kDefaultScheme);

  Future<void> setScheme(Color newColor) async {
    state = newColor;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("app_color", newColor.toARGB32());
  }

  Future<void> loadScheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeColorValue = prefs.getInt("app_color");
    if (themeColorValue != null) {
      state = Color(themeColorValue);
    } else {
      AppLogger.logger.e(
        "لم يتم العثور على لون محفوظ، سيتم استخدام اللون الافتراضي",
      );
    }
  }
}

final userThemeProvider = StateNotifierProvider<ThemeNotifier, Color>((ref) {
  return ThemeNotifier();
});

final appColorProvider = Provider<Color>((ref) {
  return const Color(0xFF2E2E2E);
});
