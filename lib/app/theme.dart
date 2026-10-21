import 'package:flutter/material.dart';

import 'package:smart_fish_feeder/app/design_tokens.dart';

/// Theme "Lagoon" aplikasi Smart Fish Feeder.
///
/// Dirancang eksplisit dari design tokens (docs/04-design-system.md
/// §3–§4): light dan dark dua-duanya didesain, bukan sekadar hasil
/// seed otomatis angau. Semua warna berasal dari [SfPalette]; nilai
/// ukuran dari token spacing/radius supaya konsisten lintas layar.
class SmartFishFeederTheme {
  const SmartFishFeederTheme._();

  static ThemeData light() => _from(SfPalette.light);

  static ThemeData dark() => _from(SfPalette.dark);

  static ThemeData _from(SfPalette p) {
    final scheme = ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: p.brightness,
    ).copyWith(
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.primarySoft,
      onPrimaryContainer: p.onPrimaryContainer,
      secondary: p.accentFeed,
      onSecondary: p.onAccentFeed,
      secondaryContainer: p.accentSoft,
      onSecondaryContainer: p.onAccentSoft,
      error: p.danger,
      onError: p.onDanger,
      errorContainer: p.dangerSoft,
      onErrorContainer: p.onDangerSoft,
      surface: p.surface,
      onSurface: p.textPrimary,
      onSurfaceVariant: p.textSecondary,
      surfaceContainerHighest: p.surfaceAlt,
      outline: p.outline,
      inverseSurface: p.textPrimary,
      onInverseSurface:
          p.brightness == Brightness.light ? p.surface : p.bg,
      inversePrimary: p.primarySoft,
    );

    final textTheme = TextTheme(
      displaySmall: _display(p, 28, 34 / 28, -0.5, FontWeight.w700),
      headlineMedium: _display(p, 24, 32 / 24, -0.4, FontWeight.w700),
      headlineSmall: _display(p, 20, 28 / 20, -0.2, FontWeight.w600),
      titleLarge: _display(p, 18, 26 / 18, -0.2, FontWeight.w600),
      titleMedium: TextStyle(
        fontFamily: SfFonts.body,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        color: p.textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: SfFonts.body,
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: p.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: SfFonts.body,
        fontSize: 15,
        height: 22 / 15,
        color: p.textPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      bodyMedium: TextStyle(
        fontFamily: SfFonts.body,
        fontSize: 14,
        height: 20 / 14,
        color: p.textSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: SfFonts.body,
        fontSize: 12,
        height: 16 / 12,
        color: p.textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: SfFonts.body,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: p.textPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: SfFonts.body,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: p.textSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: SfFonts.body,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: p.textSecondary,
      ),
    );

    OutlineInputBorder inputBorder(Color color, double width) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(SfRadius.md),
          borderSide: width <= 0
              ? BorderSide.none
              : BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: SfFonts.body,
      scaffoldBackgroundColor: p.bg,
      textTheme: textTheme,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: p.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: SfFonts.display,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: p.textPrimary,
        ),
        iconTheme: IconThemeData(color: p.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: const EdgeInsets.all(SfSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SfRadius.lg),
        ),
        shadowColor: SfShadow.cardColor,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: p.surfaceAlt,
          disabledForegroundColor: p.textSecondary,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SfRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: SfFonts.body,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          side: BorderSide(color: p.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SfRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: SfFonts.body,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SfRadius.sm),
          ),
          textStyle: const TextStyle(
            fontFamily: SfFonts.body,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SfSpacing.lg,
          vertical: 14,
        ),
        prefixIconColor: p.textSecondary,
        suffixIconColor: p.textSecondary,
        labelStyle: TextStyle(
          fontFamily: SfFonts.body,
          fontSize: 14,
          color: p.textSecondary,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: SfFonts.body,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: p.primary,
        ),
        border: inputBorder(Colors.transparent, 0),
        enabledBorder: inputBorder(p.outline, 1),
        focusedBorder: inputBorder(p.primary, 1.6),
        errorBorder: inputBorder(p.danger, 1),
        focusedErrorBorder: inputBorder(p.danger, 1.6),
        errorStyle: TextStyle(
          fontFamily: SfFonts.body,
          fontSize: 12,
          color: p.danger,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surfaceAlt,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: TextStyle(
          fontFamily: SfFonts.body,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: p.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: SfSpacing.md,
          vertical: 6,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.textPrimary,
        contentTextStyle: TextStyle(
          fontFamily: SfFonts.body,
          fontSize: 14,
          color:
              p.brightness == Brightness.light ? p.surface : p.bg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SfRadius.md),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SfRadius.xl),
        ),
        titleTextStyle: TextStyle(
          fontFamily: SfFonts.display,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: p.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: SfFonts.body,
          fontSize: 14,
          color: p.textSecondary,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(SfRadius.xl),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.textSecondary,
        titleTextStyle: TextStyle(
          fontFamily: SfFonts.body,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: p.textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: SfFonts.body,
          fontSize: 13,
          color: p.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SfRadius.md),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.outline, thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.primary,
        linearTrackColor: p.outline,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.primary,
        selectionColor: p.primarySoft,
        selectionHandleColor: p.primary,
      ),
    );
  }

  /// Gaya display Plus Jakarta Sans.
  static TextStyle _display(
    SfPalette p,
    double fontSize,
    double height,
    double letterSpacing,
    FontWeight fontWeight,
  ) =>
      TextStyle(
        fontFamily: SfFonts.display,
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        color: p.textPrimary,
      );
}
