import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.light);

  // change current theme
  Future<void> toggleTheme(ThemeMode currentThemeMode) async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setBool("darkmode", true);
    } else {
      state = ThemeMode.light;
      await prefs.setBool("darkmode", false);
    }
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool("darkmode");
    if (value != null) {
      state = value ? ThemeMode.dark : ThemeMode.light;
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeMode>((ref) {
  return ThemeProvider();
});
