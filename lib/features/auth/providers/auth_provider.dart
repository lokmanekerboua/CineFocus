import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';

/// Stream of auth state changes from Supabase
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Current user that updates reactively when the auth state changes
final userProvider = Provider<User?>((ref) {
  // We watch the stream provider so this provider rebuilds on every auth event
  // In Supabase, the user is accessible via the session property of AuthState
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user ?? ref.watch(authServiceProvider).currentUser;
});
