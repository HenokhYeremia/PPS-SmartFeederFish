import 'package:firebase_database/firebase_database.dart';

import 'package:smart_fish_feeder/features/auth/auth_service.dart';

/// Akses RTDB minimal berlingkup user yang sedang login.
///
/// - UID diambil dari Firebase Authentication saat dipanggil.
/// - Tidak ada UID hardcoded, URL hardcoded, atau device ID.
/// - Tidak ada tulis/baca data demo; hanya menyediakan referensi
///   `/users/{uid}` dan `/users/{uid}/devices` untuk langkah berikutnya.
/// - `deviceRef` diperlakukan opaque sampai format device ID dikunci.
class UserDatabase {
  UserDatabase({AuthService? authService, FirebaseDatabase? database})
      : _authService = authService,
        _database = database;

  final AuthService? _authService;
  final FirebaseDatabase? _database;

  FirebaseDatabase get _effectiveDatabase =>
      _database ?? FirebaseDatabase.instance;

  /// UID kanonis pemilik data. Null bila belum login.
  String? get currentUid => _authService?.currentUid;

  /// Referensi `/users/{uid}`. Null bila belum login.
  DatabaseReference? userRef() {
    final uid = currentUid;
    if (uid == null || uid.isEmpty) return null;
    return _effectiveDatabase.ref('users/$uid');
  }

  /// Referensi `/users/{uid}/devices`. Null bila belum login.
  ///
  /// Child `deviceRef` tetap opaque; mapping device final = TBD.
  DatabaseReference? userDevicesRef() => userRef()?.child('devices');

  /// Referensi satu device milik user. Null bila belum login atau
  /// [deviceRef] kosong. Tidak memvalidasi format device ID.
  DatabaseReference? userDeviceRef(String deviceRef) {
    if (deviceRef.isEmpty) return null;
    return userDevicesRef()?.child(deviceRef);
  }
}
