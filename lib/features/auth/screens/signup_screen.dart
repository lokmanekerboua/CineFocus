import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/auth_service.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  static const Color _darkBg1  = Color(0xFF1A1333);
  static const Color _darkBg2  = Color(0xFF0D0B14);
  static const Color _lightBg1 = Color(0xFFEDE7FF);
  static const Color _lightBg2 = Color(0xFFF5F3FF);

  final _usernameCtrl        = TextEditingController();
  final _emailCtrl           = TextEditingController();
  final _passwordCtrl        = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _isLoadingEmail  = false;
  bool _isLoadingGoogle = false;
  bool _obscurePassword        = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _handleEmailSignUp() async {
    final username        = _usernameCtrl.text.trim();
    final email           = _emailCtrl.text.trim();
    final password        = _passwordCtrl.text;
    final confirmPassword = _confirmPasswordCtrl.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('Veuillez remplir tous les champs.');
      return;
    }
    if (password != confirmPassword) {
      _showError('Les mots de passe ne correspondent pas.');
      return;
    }
    if (password.length < 6) {
      _showError('Le mot de passe doit contenir au moins 6 caractères.');
      return;
    }

    setState(() => _isLoadingEmail = true);
    try {
      await ref.read(authServiceProvider).signUpWithEmail(
        email:    email,
        password: password,
        username: username,
      );
      if (mounted) {
        _showSuccess('Compte créé ! Vérifie ton email pour confirmer ton inscription.');
        context.go('/login');
      }
    } on Exception catch (e) {
      _showError(_friendlyError(e));
    } finally {
      if (mounted) setState(() => _isLoadingEmail = false);
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoadingGoogle = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      if (mounted) context.go('/home');
    } on Exception catch (e) {
      _showError(_friendlyError(e));
    } finally {
      if (mounted) setState(() => _isLoadingGoogle = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  String _friendlyError(Exception e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('user already registered')) return 'Un compte existe déjà avec cet email.';
    if (msg.contains('password'))                return 'Mot de passe trop faible.';
    if (msg.contains('email'))                   return 'Adresse email invalide.';
    if (msg.contains('annulé'))                  return 'Connexion Google annulée.';
    return 'Une erreur est survenue. Réessaie.';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme       = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark      = theme.brightness == Brightness.dark;

    final gradientColors = isDark
        ? const [_darkBg1, _darkBg2]
        : const [_lightBg1, _lightBg2];

    final isAnyLoading = _isLoadingEmail || _isLoadingGoogle;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Back button ────────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: isAnyLoading ? null : () => context.pop(),
                    icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Titre ──────────────────────────────────────────────────
                Text(
                  "Create account",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join CineFocus and track what you love",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),

                // ── Username ───────────────────────────────────────────────
                TextField(
                  controller: _usernameCtrl,
                  enabled: !isAnyLoading,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
                    hintText: 'Username',
                  ),
                ),
                const SizedBox(height: 16),

                // ── Email ──────────────────────────────────────────────────
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isAnyLoading,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: colorScheme.onSurfaceVariant),
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 16),

                // ── Password ───────────────────────────────────────────────
                TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  enabled: !isAnyLoading,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: colorScheme.onSurfaceVariant),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Confirm password ───────────────────────────────────────
                TextField(
                  controller: _confirmPasswordCtrl,
                  obscureText: _obscureConfirmPassword,
                  enabled: !isAnyLoading,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: colorScheme.onSurfaceVariant),
                    hintText: 'Confirm password',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Sign Up button ─────────────────────────────────────────
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: isAnyLoading ? null : _handleEmailSignUp,
                  child: _isLoadingEmail
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text(
                    "Create Account",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Divider ────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("or", style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    ),
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Google ─────────────────────────────────────────────────
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: colorScheme.onSurface,
                    side: BorderSide(color: colorScheme.outlineVariant),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: isAnyLoading ? null : _handleGoogleSignUp,
                  icon: _isLoadingGoogle
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary),
                  )
                      : Icon(Icons.g_mobiledata, size: 28, color: colorScheme.primary),
                  label: const Text("Sign up with Google"),
                ),
                const SizedBox(height: 24),

                // ── Lien vers Login ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    TextButton(
                      onPressed: isAnyLoading ? null : () => context.pop(),
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}