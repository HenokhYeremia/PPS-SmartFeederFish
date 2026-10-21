import 'package:flutter/material.dart';

/// ============================================================
/// Smart Fish Feeder — Design Tokens "Lagoon"
/// ============================================================
/// Sumber tunggal identitas visual (docs/04-design-system.md §3).
///
/// Aturan penggunaan:
/// - Theme (`theme.dart`) membaca SEMUA warna dari [SfPalette].
/// - UI membaca spacing/radius/motion dari kelas di file ini.
/// - Dilarang menulis hex atau angka ajaib di file lain.
/// ============================================================

/// Keluarga font terbundel (daftar di pubspec.yaml → flutter.fonts).
abstract final class SfFonts {
  /// Untuk judul/display — Plus Jakarta Sans (variable, wght 200-800).
  static const String display = 'PlusJakartaSans';

  /// Untuk teks/body — Inter (variable, opsz+wght).
  static const String body = 'Inter';
}

/// Spacing grid 4-px (docs/04 §3.3).
abstract final class SfSpacing {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Radius konsisten: sm=chip/badge, md=field/tombol, lg=card,
/// xl=sheet/hero-card, full=pill.
abstract final class SfRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double full = 999;
}

/// Motion (docs/04 §3.4). Animasi hanya untuk feedback, bukan dekorasi.
abstract final class SfMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);

  /// Kurva khas aplikasi.
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
}

/// Bayangan lembut khas card (bukan elevation bawaan yang keras).
class SfShadow {
  const SfShadow._();

  /// rgba(12,58,54,0.08).
  static const Color cardColor = Color(0x140C3A36);

  /// Versi lebih pekat untuk elemen melayang (sheet, FAB).
  static const Color floatingColor = Color(0x1F0C3A36);

  static List<BoxShadow> get card => const [
        BoxShadow(
          color: cardColor,
          offset: Offset(0, 8),
          blurRadius: 24,
        ),
      ];

  static List<BoxShadow> get floating => const [
        BoxShadow(
          color: floatingColor,
          offset: Offset(0, 4),
          blurRadius: 16,
        ),
      ];
}

/// Palet "Lagoon" lengkap per brightness (docs/04 §3.1).
///
/// Semua warna final: UI mengambil via [SfPalette.of] agar Otomatis
/// mengikuti light/dark tanpa hex mentah di layar.
class SfPalette {
  SfPalette._({
    required this.brightness,
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.outline,
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.onPrimaryContainer,
    required this.accentFeed,
    required this.onAccentFeed,
    required this.accentSoft,
    required this.onAccentSoft,
    required this.danger,
    required this.onDanger,
    required this.dangerSoft,
    required this.onDangerSoft,
    required this.success,
    required this.successSoft,
    required this.onSuccessSoft,
    required this.textPrimary,
    required this.textSecondary,
  });

  /// Palet terang — instance tunggal.
  /// Catatan: dipakai pola `static final` (bukan const redirect)
  /// karena evaluasi konstanta `Color(...)` di dalam redirect
  /// constructor tidak didukung analyzer SDK ini.
  static final SfPalette light = SfPalette._(
    brightness: Brightness.light,
    bg: Color(0xFFF3F7F6),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEEF4F3),
    outline: Color(0xFFDCE7E5),
    primary: Color(0xFF0E7A6C),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFFD8F1EB),
    onPrimaryContainer: Color(0xFF06443C),
    accentFeed: Color(0xFFF59E0B),
    onAccentFeed: Color(0xFF3F2A02),
    accentSoft: Color(0xFFFEF3C7),
    onAccentSoft: Color(0xFF78350F),
    danger: Color(0xFFDC2626),
    onDanger: Color(0xFFFFFFFF),
    dangerSoft: Color(0xFFFEE2E2),
    onDangerSoft: Color(0xFF7F1D1D),
    success: Color(0xFF16A34A),
    successSoft: Color(0xFFDCFCE7),
    onSuccessSoft: Color(0xFF14532D),
    textPrimary: Color(0xFF0F2A27),
    textSecondary: Color(0xFF5B7370),
  );

  /// Palet gelap — didesain terpisah (teal-tinted), bukan hasil seed.
  static final SfPalette dark = SfPalette._(
    brightness: Brightness.dark,
    bg: Color(0xFF0C1719),
    surface: Color(0xFF112124),
    surfaceAlt: Color(0xFF16292C),
    outline: Color(0xFF23433F),
    primary: Color(0xFF2BB69B),
    onPrimary: Color(0xFF052E27),
    primarySoft: Color(0xFF0E3B34),
    onPrimaryContainer: Color(0xFFBFEFE6),
    accentFeed: Color(0xFFFBBF24),
    onAccentFeed: Color(0xFF432B04),
    accentSoft: Color(0xFF3B2F0B),
    onAccentSoft: Color(0xFFFDE68A),
    danger: Color(0xFFF87171),
    onDanger: Color(0xFF3B1212),
    dangerSoft: Color(0xFF3B1212),
    onDangerSoft: Color(0xFFFECACA),
    success: Color(0xFF4ADE80),
    successSoft: Color(0xFF064E3B),
    onSuccessSoft: Color(0xFFBBF7D0),
    textPrimary: Color(0xFFE6F2F0),
    textSecondary: Color(0xFF93AAA7),
  );

  final Brightness brightness;
  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color outline;
  final Color primary;
  final Color onPrimary;
  final Color primarySoft;
  final Color onPrimaryContainer;
  final Color accentFeed;
  final Color onAccentFeed;
  final Color accentSoft;
  final Color onAccentSoft;
  final Color danger;
  final Color onDanger;
  final Color dangerSoft;
  final Color onDangerSoft;
  final Color success;
  final Color successSoft;
  final Color onSuccessSoft;
  final Color textPrimary;
  final Color textSecondary;

  /// Palet sesuai brightness tema aktif.
  factory SfPalette.of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}
