import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final _supabase = Supabase.instance.client;

  final _googleSignIn = GoogleSignIn(
    // Web Client ID créé dans Google Cloud Console (type "Web application")
    serverClientId: '216300574155-g6kvrvkb6eglnq0a9ljhvsg6j5rbkqd5.apps.googleusercontent.com',
  );

  // ── Google ────────────────────────────────────────────────────────────────

  Future<AuthResponse> signInWithGoogle() async {
    await _googleSignIn.signOut();

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in annulé');

    final googleAuth = await googleUser.authentication;
    final idToken    = googleAuth.idToken;

    if (idToken == null) throw Exception('Impossible de récupérer l\'ID token Google');

    return _supabase.auth.signInWithIdToken(
      provider:    OAuthProvider.google,
      idToken:     idToken,
      accessToken: googleAuth.accessToken,
    );
  }

  // ── Email / Password ──────────────────────────────────────────────────────

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _supabase.auth.signInWithPassword(email: email, password: password);

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) =>
      _supabase.auth.signUp(
        email:    email,
        password: password,
        data:     {'username': username},
      );

  // ── Session ───────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }

  User?                get currentUser       => _supabase.auth.currentUser;
  Stream<AuthState>    get authStateChanges   => _supabase.auth.onAuthStateChange;
}