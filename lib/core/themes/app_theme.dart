import 'package:flutter/material.dart';

/// يبني ثيمات التطبيق (فاتح/داكن) بشكل مخصّص بدل الاعتماد الكلي على
/// ColorScheme.fromSeed، لضمان تحكّم كامل بجودة الوضع الداكن.
class AppTheme {
  AppTheme._();

  // ─── الوضع الفاتح ────────────────────────────────────────────
  static ThemeData light(Color seed) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ).copyWith(primary: seed, onPrimary: _onColor(seed));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFFAF9F7),
      fontFamily: "Cairo",
    );
  }

  // ─── الوضع الداكن — مخصّص بالكامل ────────────────────────────
  static ThemeData dark(Color seed) {
    // درجات رمادي داكن دافئة، متدرجة الارتفاع (بدل الأسود الخالص القاسي)
    const bg = Color(0xFF121212); // خلفية الشاشة
    const surface = Color(0xFF1C1C1E); // البطاقات العادية
    const surfaceHigh = Color(0xFF242426); // عناصر مرتفعة (حوارات، شرائح)
    const outline = Color(0xFF3A3A3C);
    const outlineVariant = Color(0xFF2C2C2E);
    const onSurface = Color(0xFFEDEDEE);
    const onSurfaceVariant = Color(0xFFB0B0B3);

    final onPrimary = _onColor(seed);

    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: seed,
      onPrimary: onPrimary,
      primaryContainer: seed.withValues(alpha: 0.22),
      onPrimaryContainer: _lighten(seed, 0.45),
      secondary: seed,
      onSecondary: onPrimary,
      secondaryContainer: seed.withValues(alpha: 0.16),
      onSecondaryContainer: _lighten(seed, 0.45),
      tertiary: seed,
      onTertiary: onPrimary,
      tertiaryContainer: seed.withValues(alpha: 0.16),
      onTertiaryContainer: _lighten(seed, 0.45),
      error: const Color(0xFFCF6679),
      onError: Colors.black,
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceHigh,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: onSurface,
      onInverseSurface: surface,
      inversePrimary: seed,
      surfaceTint: seed,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      cardColor: surface,
      dividerColor: outline,
      fontFamily: "Cairo",
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: surface),
      dialogTheme: const DialogThemeData(backgroundColor: surface),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: surfaceHigh,
        contentTextStyle: TextStyle(color: onSurface),
      ),
      popupMenuTheme: const PopupMenuThemeData(color: surfaceHigh),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
      ),
    );
  }

  /// يختار أبيض أو أسود تلقائياً حسب سطوع اللون لضمان تباين جيد
  /// (مهم لأن userColor قد يكون فاتحاً كالأصفر أو داكناً كالأزرق الغامق)
  static Color _onColor(Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}
