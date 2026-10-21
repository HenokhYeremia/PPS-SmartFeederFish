/// Identitas perangkat Smart Fish Feeder.
///
/// Hanya berisi konsep umum yang didukung proposal.
/// Detail protokol belum dikunci, sehingga tidak ada:
/// - Firebase path,
/// - BLE UUID / nama perangkat,
/// - firmware command,
/// - format acknowledgement.
class Device {
  const Device({
    required this.id,
    required this.name,
  });

  /// Identifier logis perangkat.
  ///
  /// Format final (misalnya dari Firebase/ESP32) belum dikunci,
  /// sehingga field ini diperlakukan sebagai opaque string.
  final String id;

  /// Nama tampilan perangkat yang diberikan pengguna/aplikasi.
  final String name;
}
