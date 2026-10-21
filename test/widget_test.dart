// Application authentication foundation tests.
//
// Tidak memakai kredensial nyata atau jaringan. Menguji pesan error
// aman-tampil dan UI login/register minimal.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_fish_feeder/app/app.dart';
import 'package:smart_fish_feeder/features/auth/auth_error_messages.dart';
import 'package:smart_fish_feeder/features/auth/auth_page.dart';
import 'package:smart_fish_feeder/data/ownership_rules_note.dart';
import 'package:smart_fish_feeder/data/user_database.dart';
import 'package:smart_fish_feeder/features/auth/auth_result.dart';
import 'package:smart_fish_feeder/features/auth/auth_service.dart';
import 'package:smart_fish_feeder/features/auth/auth_user.dart';

/// Auth palsu khusus pengujian UI. Tidak menyentuh Firebase.
class TestAuthService implements AuthService {
  @override
  Stream<AuthUser?> authStateChanges() =>
      Stream<AuthUser?>.value(null);

  @override
  AuthUser? get currentUser => null;

  @override
  String? get currentUid => null;

  @override
  Future<AuthResult> registerWithEmail({
    required String email,
    required String password,
  }) async =>
      AuthResult.failure('test-only');

  @override
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async =>
      AuthResult.failure('test-only');

  @override
  Future<void> signOut() async {}
}

void main() {
  test('friendlyAuthMessage maps common Firebase codes', () {
    expect(friendlyAuthMessage('invalid-email'), 'Format email tidak valid.');
    expect(friendlyAuthMessage('weak-password'), 'Password terlalu lemah.');
    expect(
      friendlyAuthMessage('email-already-in-use'),
      'Email sudah terdaftar. Silakan login.',
    );
    expect(
      friendlyAuthMessage('invalid-credential'),
      'Email atau password salah.',
    );
    expect(
      friendlyAuthMessage('network-request-failed'),
      'Jaringan bermasalah. Periksa koneksi internet.',
    );
    expect(
      friendlyAuthMessage('some-unknown-code').contains('some-unknown-code'),
      isTrue,
    );
    expect(
      friendlyAuthMessage('user-not-found').contains('user-not-found'),
      isFalse,
    );
  });

  testWidgets('AuthPage renders login form without Firebase', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthPage(authService: TestAuthService())),
    );

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('SmartFishFeederApp builds with injected auth', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      SmartFishFeederApp(authService: TestAuthService()),
    );
    await tester.pump();

    expect(find.text('Smart Fish Feeder'), findsWidgets);
  });

  test('UserDatabase returns null refs without login', () {
    final db = UserDatabase(authService: TestAuthService());

    expect(db.currentUid, isNull);
    expect(db.userRef(), isNull);
    expect(db.userDevicesRef(), isNull);
    expect(db.userDeviceRef('any-opaque-ref'), isNull);
  });

  test('ownership rules note stays scoped to users/{uid}', () {
    expect(proposedOwnershipRulesNote, contains('users/{uid}'));
  });
}

