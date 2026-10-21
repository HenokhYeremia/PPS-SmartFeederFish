import 'package:flutter/material.dart';

/// Theme foundation aplikasi Smart Fish Feeder.
///
/// Menggunakan Material 3 ([useMaterial3]) agar mengikuti Flutter
/// yang sudah terverifikasi pada Step 02.
///
/// Sengaja dibuat minimal: terang/gelap, readable, dan tidak memakai
/// layout fixed-size. Desain visual final dibuat pada step berikutnya.
class SmartFishFeederTheme {
  const SmartFishFeederTheme._();

  static const _seedColor = Colors.teal;

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.all(12),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.all(12),
      ),
    );
  }
}
