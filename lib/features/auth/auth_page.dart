import 'package:flutter/material.dart';

import 'package:smart_fish_feeder/app/design_tokens.dart';
import 'package:smart_fish_feeder/features/auth/auth_service.dart';

/// UI autentikasi — versi premium sesuai docs/04-design-system.md §6.2.
///
/// Perilaku sama dengan versi fondasi Step 07 (login/register, validasi
/// wajib-isi, busy state, hasil sukses/gagal, toggle mode); yang berubah
/// adalah visual dan kejelasan state, bukan logikanya.
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
  bool _obscurePassword = true;
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

  void _switchMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _statusMessage = null;
      _lastSucceeded = false;
    });
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    final palette = SfPalette.of(Theme.of(context).brightness);
    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: SfSpacing.xl,
              vertical: SfSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _AuthHeader(),
                  const SizedBox(height: SfSpacing.xl),
                  _AuthCard(
                    palette: palette,
                    isRegisterMode: _isRegisterMode,
                    isBusy: _isBusy,
                    statusMessage: _statusMessage,
                    lastSucceeded: _lastSucceeded,
                    obscurePassword: _obscurePassword,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                    onSubmit: _isBusy ? null : _submit,
                    onSwitchMode: _isBusy ? null : _switchMode,
                    onTogglePassword: _togglePasswordVisibility,
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

/// Header merek: logo, nama, tagline.
class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    final palette = SfPalette.of(Theme.of(context).brightness);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: palette.primarySoft,
            borderRadius: BorderRadius.circular(SfRadius.lg),
          ),
          child: Icon(
            Icons.set_meal,
            color: palette.primary,
            size: 32,
          ),
        ),
        const SizedBox(height: SfSpacing.lg),
        Text(
          'Smart Fish Feeder',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: SfSpacing.sm),
        Text(
          'Jadwal pakannya, air tetap jernih. Pantau kolam Anda '
          'dari mana saja.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Kartu form (login ↔ register).
class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.palette,
    required this.isRegisterMode,
    required this.isBusy,
    required this.statusMessage,
    required this.lastSucceeded,
    required this.obscurePassword,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.onSubmit,
    required this.onSwitchMode,
    required this.onTogglePassword,
  });

  final SfPalette palette;
  final bool isRegisterMode;
  final bool isBusy;
  final String? statusMessage;
  final bool lastSucceeded;
  final bool obscurePassword;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onSubmit;
  final VoidCallback? onSwitchMode;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SfSpacing.xl),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(SfRadius.xl),
        boxShadow: SfShadow.card,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isRegisterMode ? 'Buat akun' : 'Login',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: SfSpacing.lg),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.alternate_email),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: SfSpacing.md),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) {
                if (!isBusy) onSubmit?.call();
              },
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  tooltip: obscurePassword
                      ? 'Tampilkan password'
                      : 'Sembunyikan password',
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password wajib diisi.';
                }
                if (isRegisterMode && value.length < 6) {
                  return 'Password minimal 6 karakter.';
                }
                return null;
              },
            ),
            if (statusMessage != null) ...[
              const SizedBox(height: SfSpacing.lg),
              _StatusBanner(
                palette: palette,
                success: lastSucceeded,
                message: statusMessage!,
              ),
            ],
            const SizedBox(height: SfSpacing.lg),
            FilledButton(
              onPressed: onSubmit,
              child: AnimatedSwitcher(
                duration: SfMotion.fast,
                child: isBusy
                    ? Row(
                        key: const ValueKey('busy'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: SfSpacing.md),
                          const Text('Memproses...'),
                        ],
                      )
                    : Text(
                        isRegisterMode ? 'Register' : 'Login',
                        key: const ValueKey('idle'),
                      ),
              ),
            ),
            const SizedBox(height: SfSpacing.sm),
            TextButton(
              onPressed: onSwitchMode,
              child: Text(
                isRegisterMode
                    ? 'Sudah punya akun? Login'
                    : 'Belum punya akun? Register',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner status (sukses = mint, gagal = merah) di atas tombol,
/// menggantikan Text kecil polos di versi fondasi.
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.palette,
    required this.success,
    required this.message,
  });

  final SfPalette palette;
  final bool success;
  final String message;

  @override
  Widget build(BuildContext context) {
    final color = success ? palette.success : palette.danger;
    final bgColor = success ? palette.successSoft : palette.dangerSoft;
    final fgColor =
        success ? palette.onSuccessSoft : palette.onDangerSoft;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SfSpacing.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(SfRadius.sm),
      ),
      child: Row(
        children: [
          Icon(
            success
                ? Icons.check_circle_outline
                : Icons.error_outline,
            color: color,
            size: 20,
          ),
          const SizedBox(width: SfSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: SfFonts.body,
                fontSize: 13,
                color: fgColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
