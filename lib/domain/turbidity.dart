/// Hasil pembacaan kekeruhan air.
///
/// Hanya menyimpan nilai generik plus waktu pencatatan.
/// Satuan, rentang valid, kalibrasi sensor, dan mapping Firebase
/// belum dikunci sehingga sengaja tidak dimodelkan di sini.
class TurbidityReading {
  const TurbidityReading({
    required this.value,
    required this.recordedAt,
  });

  /// Nilai kekeruhan mentah/generik. Tidak diasumsikan satuannya.
  final double value;

  /// Waktu pembacaan dicatat oleh aplikasi.
  final DateTime recordedAt;
}
