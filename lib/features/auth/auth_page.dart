import 'package:flutter/material.dart';

import 'package:smart_fish_feeder/features/auth/auth_service.dart';

/// UI minimal Step 07 untuk validasi fondasi autentikasi.
///
/// Hanya login, register, dan logout. Bukan dashboard final.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key, AuthService? authService})
      : _authService = authService;

  final AuthService? _authService;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthService _authService;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegisterMode = false;
  bool _isBusy = false;
  String? _statusMessage;
  bool _lastSucceeded = false;

  @override
  void initState() {
    super.initState();
    _authService = widget._authService ?? FirebaseAuthService();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isBusy = true;
      _statusMessage = null;
      _lastSucceeded = false;
    });
    final result = _isRegisterMode
        ? await _authService.registerWithEmail(
            email: _emailController.text,
            password: _passwordController.text,
          )
        : await _authService.signInWithEmail(
            email: _emailController.text,
            password: _passwordController.text,
          );
    if (!mounted) return;
    setState(() {
      _isBusy = false;
      _lastSucceeded = result.succeeded;
      _statusMessage = result.succeeded
          ? (_isRegisterMode
              ? 'Pendaftaran berhasil. Selamat datang.'
              : 'Login berhasil. Selamat datang kembali.')
          : result.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Fish Feeder')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isRegisterMode ? 'Register' : 'Login',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi.';
                      }
                      if (_isRegisterMode && value.length < 6) {
                        return 'Password minimal 6 karakter.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _isBusy ? null : _submit,
                    child: Text(
                      _isBusy
                          ? 'Memproses...'
                          : (_isRegisterMode ? 'Register' : 'Login'),
                    ),
                  ),
                  TextButton(
                    onPressed: _isBusy
                        ? null
                        : () => setState(() {
                              _isRegisterMode = !_isRegisterMode;
                              _statusMessage = null;
                              _lastSucceeded = false;
                            }),
                    child: Text(
                      _isRegisterMode
                          ? 'Sudah punya akun? Login'
                          : 'Belum punya akun? Register',
                    ),
                  ),
                  if (_statusMessage != null)
                    Text(
                      _statusMessage!,
                      style: TextStyle(
                        color: _lastSucceeded
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
