/// Status stok pakan pada tingkat domain.
///
/// Hanya jumlah generik tanpa satuan yang diasumsikan.
/// Batas minimum, sensor HC-SR04 mapping, dan Firebase path
/// belum dikunci sehingga tidak dimodelkan di sini.
class FeedStock {
  const FeedStock({
    required this.amount,
    required this.updatedAt,
  });

  /// Jumlah stok generik. Tidak diasumsikan persen/gram.
  final double amount;

  /// Waktu terakhir status stok diperbarui.
  final DateTime updatedAt;
}
