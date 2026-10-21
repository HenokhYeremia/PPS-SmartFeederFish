import 'package:flutter/material.dart';

import 'package:smart_fish_feeder/features/auth/auth_service.dart';

/// Placeholder foundation Step 03, dipakai setelah login pada Step 07.
///
/// Halaman ini BUKAN dashboard final dan TIDAK menampilkan data sensor.
/// Menampilkan UID kanonis pemilik data dan tombol logout Firebase Auth.
class FoundationPage extends StatelessWidget {
  const FoundationPage({super.key, AuthService? authService})
      : _authService = authService;

  final AuthService? _authService;

  @override
  Widget build(BuildContext context) {
    final authService = _authService ?? FirebaseAuthService();
    final user = authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Fish Feeder'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () => authService.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application foundation ready',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  user == null
                      ? 'Belum ada UID pada sesi ini.'
                      : 'UID pemilik data: ${user.uid}',
                ),
                if (user?.email != null)
                  Text('Email: ${user!.email}'),
                const SizedBox(height: 12),
                const Text(
                  'RTDB, BLE provisioning, dan monitoring '
                  'belum diimplementasikan pada tahap ini.',
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FoundationDetailsPage(),
                      ),
                    );
                  },
                  child: const Text('Open foundation details'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Halaman kedua minimal untuk membuktikan Navigator bawaan Flutter
/// tersedia tanpa router package.
class FoundationDetailsPage extends StatelessWidget {
  const FoundationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foundation details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('Entry point'),
            subtitle: Text('lib/main.dart -> SmartFishFeederApp'),
          ),
          ListTile(
            title: Text('Theme'),
            subtitle: Text('Material 3 light/dark foundation'),
          ),
          ListTile(
            title: Text('Data layer'),
            subtitle: Text('Belum tersedia pada Step 03'),
          ),
        ],
      ),
    );
  }
}
