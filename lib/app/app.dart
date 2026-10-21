import 'package:flutter/material.dart';

import 'package:smart_fish_feeder/app/theme.dart';
import 'package:smart_fish_feeder/features/auth/auth_gate.dart';
import 'package:smart_fish_feeder/features/auth/auth_service.dart';

/// Root widget aplikasi Smart Fish Feeder.
///
/// Step 07: Firebase Auth menjadi gerbang status login.
/// Firebase Auth UID adalah identitas kanonis pemilik data.
/// RTDB, BLE, dan fitur IoT tetap belum diimplementasikan.
class SmartFishFeederApp extends StatelessWidget {
  const SmartFishFeederApp({super.key, AuthService? authService})
      : _authService = authService;

  final AuthService? _authService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Fish Feeder',
      debugShowCheckedModeBanner: false,
      theme: SmartFishFeederTheme.light(),
      darkTheme: SmartFishFeederTheme.dark(),
      themeMode: ThemeMode.system,
      home: _authService == null
          ? const AuthGate()
          : AuthGate(authService: _authService),
    );
  }
}
