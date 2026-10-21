import 'package:flutter/material.dart';

import 'package:smart_fish_feeder/features/auth/auth_page.dart';
import 'package:smart_fish_feeder/features/auth/auth_service.dart';
import 'package:smart_fish_feeder/features/foundation/foundation_page.dart';

/// Gerbang status autentikasi Step 07.
///
/// - Pengguna belum login: menampilkan halaman login/register.
/// - Pengguna sudah login: menampilkan foundation yang sudah ada.
/// Tidak memakai package state-management; hanya [StreamBuilder].
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, AuthService? authService})
      : _authService = authService;

  final AuthService? _authService;

  @override
  Widget build(BuildContext context) {
    final authService = _authService ?? FirebaseAuthService();
    return StreamBuilder(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return FoundationPage(authService: authService);
        }
        return AuthPage(authService: authService);
      },
    );
  }
}
