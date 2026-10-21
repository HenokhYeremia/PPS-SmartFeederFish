/// Pesan error autentikasi yang aman ditampilkan ke pengguna.
///
/// Tanpa stack trace, token, password, atau secret Firebase.
/// Fungsi murni agar dapat diuji tanpa backend Firebase.
String friendlyAuthMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Format email tidak valid.';
    case 'weak-password':
      return 'Password terlalu lemah.';
    case 'email-already-in-use':
      return 'Email sudah terdaftar. Silakan login.';
    case 'user-not-found':
      return 'Akun tidak ditemukan untuk email tersebut.';
    case 'wrong-password':
      return 'Password salah. Silakan coba lagi.';
    case 'invalid-credential':
      return 'Email atau password salah.';
    case 'user-disabled':
      return 'Akun ini dinonaktifkan.';
    case 'too-many-requests':
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    case 'network-request-failed':
      return 'Jaringan bermasalah. Periksa koneksi internet.';
    case 'operation-not-allowed':
      return 'Login email/password belum diaktifkan di Firebase.';
    default:
      return 'Autentikasi gagal ($code). Silakan coba lagi.';
  }
}
