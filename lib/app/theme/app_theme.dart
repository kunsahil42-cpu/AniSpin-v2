import 'package:flutter/material.dart';
import '../../features/settings/models/app_settings.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF7C4DFF);
  static const Color secondary = Color(0xFF00E5FF);

  static final ThemeData light = buildTheme(
    brightness: Brightness.light,
    settings: AppSettings.defaultSettings(),
  );

  static final ThemeData dark = buildTheme(
    brightness: Brightness.dark,
    settings: AppSettings.defaultSettings(),
  );

  static ThemeData buildTheme({
    required Brightness brightness,
    required AppSettings settings,
  }) {
    // 1. Accent Color
    Color accentColor = primary;
    switch (settings.accentColor) {
      case AccentColorOption.blue:
        accentColor = Colors.blue;
        break;
      case AccentColorOption.purple:
        accentColor = primary;
        break;
      case AccentColorOption.green:
        accentColor = Colors.green;
        break;
      case AccentColorOption.orange:
        accentColor = Colors.orange;
        break;
      case AccentColorOption.red:
        accentColor = Colors.red;
        break;
      case AccentColorOption.pink:
        accentColor = Colors.pink;
        break;
      case AccentColorOption.cyan:
        accentColor = Colors.cyan;
        break;
      case AccentColorOption.dynamicColor:
        accentColor = primary; // Fallback for platforms without dynamic_color package
        break;
    }

    final isDark = brightness == Brightness.dark;

    // 2. Generate ColorScheme
    ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: brightness,
    );

    // 3. AMOLED Theme adjustments (pure black background)
    Color scaffoldBg;
    if (isDark && settings.amoledTheme) {
      scaffoldBg = Colors.black;
      scheme = scheme.copyWith(
        surface: Colors.black,
      );
    } else {
      scaffoldBg = isDark ? const Color(0xFF0F1117) : Colors.grey.shade50;
    }

    // 4. UI Density Selection
    VisualDensity visualDensity;
    switch (settings.uiDensity) {
      case UiDensityOption.compact:
        visualDensity = VisualDensity.compact;
        break;
      case UiDensityOption.spacious:
        visualDensity = const VisualDensity(horizontal: 2.0, vertical: 2.0);
        break;
      case UiDensityOption.comfortable:
        visualDensity = VisualDensity.standard;
        break;
    }

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      visualDensity: visualDensity,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      cardTheme: CardThemeData(
        elevation: isDark ? (settings.amoledTheme ? 2 : 8) : 4,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1B1F2A) : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}