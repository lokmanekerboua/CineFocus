import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl(this._supabase, this._googleSignIn);

  @override
  Future<AuthResponse> signInWithGoogle() async {
    await _googleSignIn.signOut();

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in annulé');

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) throw Exception('Impossible de récupérer l\'ID token Google');

    return _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
  }

  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _supabase.auth.signInWithPassword(email: email, password: password);

  @override
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) =>
      _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
  }

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
