import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/utils/log/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const FlexScheme kDefaultScheme = FlexScheme.money;

class ThemeNotifier extends StateNotifier<FlexScheme> {
  ThemeNotifier() : super(kDefaultScheme);

  Future<void> setScheme(FlexScheme newScheme) async {
    state = newScheme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("scheme_color", newScheme.name);
  }

  Future<void> loadScheme() async {
    final perfs = await SharedPreferences.getInstance();
    final themeColorValue = perfs.getString("scheme_color");
    if (themeColorValue != null){
      state = FlexScheme.values.byName(themeColorValue);
    } else {
      AppLogger.logger.e("حدثت مشكلة اثناء تحميل الثيم الخاص بالمستخدم");
    }
  }
}

final userThemeProvider = StateNotifierProvider<ThemeNotifier, FlexScheme>((ref) {
  return ThemeNotifier();
});

final lightThemeProvider = Provider<ThemeData>((ref) {
  final currentScheme =  ref.watch(userThemeProvider); // ref.watch(userThemeProvider);
  return FlexThemeData.light(
    scheme: currentScheme,

    subThemesData: const FlexSubThemesData(
      interactionEffects: true,

      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final currentScheme = ref.watch(userThemeProvider);
  return FlexThemeData.dark(
    scheme: currentScheme,

    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
});
