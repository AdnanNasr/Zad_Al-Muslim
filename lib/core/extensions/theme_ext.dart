import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/themes/theme_notifier.dart';
import 'package:zad_al_muslim/core/common/providers/theme_provider.dart';

extension SettingsExt on BuildContext {
  // get themeMode
  ThemeMode themeMode(WidgetRef ref) {
    return ref.watch(themeProvider);
  }

  // get app color
  Color themeColor(WidgetRef ref) {
    return ref.watch(userThemeProvider);
  }
}
