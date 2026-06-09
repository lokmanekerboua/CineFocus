import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository repository;
  SignUpWithEmail(this.repository);

  Future<AuthResponse> call({
    required String email,
    required String password,
    required String username,
  }) async {
    return await repository.signUpWithEmail(
      email: email,
      password: password,
      username: username,
    );
  }
}
