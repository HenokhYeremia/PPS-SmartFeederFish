import 'package:smart_fish_feeder/features/auth/auth_user.dart';

/// Hasil operasi autentikasi email/password.
///
/// [user] hanya terisi ketika Firebase Auth mengonfirmasi operasi
/// berhasil. [message] berisi pesan aman-tampil untuk UI.
class AuthResult {
  const AuthResult._({required this.user, required this.message});

  factory AuthResult.success(AuthUser user) =>
      AuthResult._(user: user, message: '');

  factory AuthResult.failure(String message) =>
      AuthResult._(user: null, message: message);

  final AuthUser? user;
  final String message;

  bool get succeeded => user != null;
}
