import 'package:flutter/material.dart';

/// الهوية البصرية المركزية لتطبيق زاد المسلم.
///
/// يتغير [seed] باختيار المستخدم، بينما تبقى الألوان الدلالية الثانوية ثابتة
/// حتى تظل أقسام الصلاة والأذكار واضحة ومتسقة في جميع الثيمات.
class AppTheme {
  AppTheme._();

  static const Color defaultPrimary = Color(0xFF176B70);
  static const Color lightSecondary = Color(0xFFB7893E);
  static const Color darkSecondary = Color(0xFFD8B56A);
  static const Color lightTertiary = Color(0xFF557A5B);
  static const Color darkTertiary = Color(0xFF8DB493);

  static ThemeData light(Color seed) {
    const background = Color(0xFFF8F6F1);
    const surface = Color(0xFFFFFFFF);
    const surfaceContainer = Color(0xFFF0EEE8);
    const onSurface = Color(0xFF202523);
    const onSurfaceVariant = Color(0xFF66706C);
    const outline = Color(0xFF8D938F);
    const outlineVariant = Color(0xFFDDDCD5);

    final primary = _usablePrimary(seed, Brightness.light);
    final generated = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );
    final scheme = generated.copyWith(
      primary: primary,
      onPrimary: _onColor(primary),
      primaryContainer: _tint(primary, 0.84),
      onPrimaryContainer: _shade(primary, 0.28),
      secondary: lightSecondary,
      onSecondary: _onColor(lightSecondary),
      secondaryContainer: const Color(0xFFF5E7C8),
      onSecondaryContainer: const Color(0xFF3D2D0D),
      tertiary: lightTertiary,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFD8E8D7),
      onTertiaryContainer: const Color(0xFF18351D),
      error: const Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: const Color(0xFF1D2925),
      surfaceTint: primary,
      surfaceContainerLowest: background,
      surfaceContainerLow: const Color(0xFFFBF9F4),
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: const Color(0xFFEAE8E2),
      surfaceContainerHighest: const Color(0xFFE4E2DC),
    );

    return _baseTheme(
      scheme: scheme,
      scaffoldBackground: background,
      cardColor: surface,
    );
  }

  static ThemeData dark(Color seed) {
    const background = Color(0xFF101716);
    const surface = Color(0xFF18211F);
    const surfaceLow = Color(0xFF151D1B);
    const surfaceContainer = Color(0xFF202C29);
    const onSurface = Color(0xFFEDF3F0);
    const onSurfaceVariant = Color(0xFFABB9B4);
    const outline = Color(0xFF71807A);
    const outlineVariant = Color(0xFF34423E);

    final primary = _usablePrimary(seed, Brightness.dark);
    final generated = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    );
    final scheme = generated.copyWith(
      primary: primary,
      onPrimary: _onColor(primary),
      primaryContainer: _shade(primary, 0.42),
      onPrimaryContainer: _tint(primary, 0.72),
      secondary: darkSecondary,
      onSecondary: const Color(0xFF3D2D0D),
      secondaryContainer: const Color(0xFF594516),
      onSecondaryContainer: const Color(0xFFF5E7C8),
      tertiary: darkTertiary,
      onTertiary: const Color(0xFF17351D),
      tertiaryContainer: const Color(0xFF294B31),
      onTertiaryContainer: const Color(0xFFD8E8D7),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      surfaceTint: primary,
      inverseSurface: onSurface,
      onInverseSurface: const Color(0xFF28312E),
      surfaceContainerLowest: background,
      surfaceContainerLow: surfaceLow,
      surfaceContainer: surface,
      surfaceContainerHigh: surfaceContainer,
      surfaceContainerHighest: const Color(0xFF293633),
    );

    return _baseTheme(
      scheme: scheme,
      scaffoldBackground: background,
      cardColor: surface,
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme scheme,
    required Color scaffoldBackground,
    required Color cardColor,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      cardColor: cardColor,
      dividerColor: scheme.outlineVariant,
      fontFamily: 'Cairo',
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 0 : 1,
        shadowColor: scheme.shadow.withValues(alpha: 0.08),
        shape: shape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: shape,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        modalBackgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainer,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: scheme.onInverseSurface,
          fontFamily: 'Cairo',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: shape,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// يمنع ألوان المستخدم شديدة السطوع أو الظلمة من إضعاف قابلية القراءة.
  static Color _usablePrimary(Color color, Brightness brightness) {
    final hsl = HSLColor.fromColor(color);
    final lightness = brightness == Brightness.light
        ? hsl.lightness.clamp(0.28, 0.48)
        : hsl.lightness.clamp(0.62, 0.74);
    return hsl.withLightness(lightness).toColor();
  }

  static Color _onColor(Color background) =>
      background.computeLuminance() > 0.48 ? Colors.black : Colors.white;

  static Color _tint(Color color, double amount) =>
      Color.lerp(color, Colors.white, amount)!;

  static Color _shade(Color color, double amount) =>
      Color.lerp(color, Colors.black, amount)!;
}
