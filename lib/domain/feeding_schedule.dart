import 'package:flutter/material.dart';

/// Perintah/jadwal pemberian pakan pada tingkat domain.
///
/// Hanya memodelkan kapan pemberian dijadwalkan dan apakah aktif.
/// Mekanisme eksekusi di ESP32, fuzzy logic, perintah servo,
/// dan contract Firebase belum dikunci sehingga tidak ada di sini.
class FeedingSchedule {
  const FeedingSchedule({
    required this.id,
    required this.timeOfDay,
    required this.isEnabled,
  });

  /// Identifier logis jadwal. Format final belum dikunci.
  final String id;

  /// Waktu pemberian dalam sehari, tanpa zona waktu implisit.
  final TimeOfDay timeOfDay;

  /// Apakah jadwal ini aktif.
  final bool isEnabled;
}
