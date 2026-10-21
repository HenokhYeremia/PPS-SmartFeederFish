import 'package:firebase_auth/firebase_auth.dart';

import 'package:smart_fish_feeder/features/auth/auth_error_messages.dart';
import 'package:smart_fish_feeder/features/auth/auth_result.dart';
import 'package:smart_fish_feeder/features/auth/auth_user.dart';

/// Kontrak autentikasi aplikasi.
///
/// Implementasi produksi adalah [FirebaseAuthService] dengan Firebase
/// Authentication sebagai source of truth. Tidak ada user hardcoded,
/// tidak ada penyimpanan password lokal, dan tidak ada token custom.
abstract class AuthService {
  Stream<AuthUser?> authStateChanges();

  /// User yang sedang login menurut backend auth, jika ada.
  AuthUser? get currentUser;

  /// UID kanonis untuk kepemilikan data pada langkah berikutnya.
  String? get currentUid;

  Future<AuthResult> registerWithEmail({
    required String email,
    required String password,
  });

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

/// Lapisan autentikasi email/password berbasis Firebase Authentication.
class FirebaseAuthService extends AuthService {
  FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  static AuthUser _toAuthUser(User user) =>
      AuthUser(uid: user.uid, email: user.email);

  @override
  Stream<AuthUser?> authStateChanges() =>
      _firebaseAuth.authStateChanges().map(
            (user) => user == null ? null : _toAuthUser(user),
          );

  @override
  AuthUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : _toAuthUser(user);
  }

  @override
  String? get currentUid => _firebaseAuth.currentUser?.uid;

  @override
  Future<AuthResult> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return AuthResult.failure(
          'Pendaftaran tidak dapat dikonfirmasi. Silakan coba lagi.',
        );
      }
      return AuthResult.success(_toAuthUser(user));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(friendlyAuthMessage(e.code));
    }
  }

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        return AuthResult.failure(
          'Login tidak dapat dikonfirmasi. Silakan coba lagi.',
        );
      }
      return AuthResult.success(_toAuthUser(user));
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(friendlyAuthMessage(e.code));
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}

