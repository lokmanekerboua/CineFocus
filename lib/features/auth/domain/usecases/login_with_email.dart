import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmail {
  final AuthRepository repository;
  LoginWithEmail(this.repository);

  Future<AuthResponse> call({required String email, required String password}) async {
    return await repository.signInWithEmail(email: email, password: password);
  }
}
