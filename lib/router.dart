import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/signup_screen.dart';
import 'features/main_screen.dart';
import 'features/movies/presentation/pages/movie_details_screen.dart';
import 'features/movies/domain/entities/movie.dart';

/// A simple listenable that notifies GoRouter when the auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (AuthState state) => notifyListeners(),
    );
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final router = GoRouter(
  initialLocation: Supabase.instance.client.auth.currentSession != null ? '/home' : '/login',
  
  refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    if (session == null) {
      return isLoggingIn ? null : '/login';
    }

    if (isLoggingIn) {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(path: '/login',  builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/home',   builder: (context, state) => const MainScreen()),
    GoRoute(
      path: '/details',
      builder: (context, state) => MovieDetailsScreen(movie: state.extra as Movie),
    ),
  ],
);
