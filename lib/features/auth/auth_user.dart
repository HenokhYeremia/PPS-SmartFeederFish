/// Representasi user terautentikasi pada application layer.
///
/// Hanya berisi identitas kanonis (UID) dan email tampilan.
/// Bukan model Firebase; UID berasal dari Firebase Auth pada runtime.
class AuthUser {
  const AuthUser({required this.uid, this.email});

  /// Firebase Auth UID, identitas kanonis pemilik data.
  final String uid;

  /// Email tampilan, jika tersedia.
  final String? email;
}
