import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle {
  final AuthRepository repository;
  LoginWithGoogle(this.repository);

  Future<AuthResponse> call() async {
    return await repository.signInWithGoogle();
  }
}
