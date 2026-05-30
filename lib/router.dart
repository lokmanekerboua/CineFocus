import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'features/movies/screens/home_screen.dart';
import 'features/movies/screens/movie_details_screen.dart';
import 'features/movies/models/movie_model.dart';

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
  
  // This is the key: it tells GoRouter to re-run the redirect logic whenever auth changes
  refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    if (session == null) {
      // Not logged in -> force login unless already on login/signup
      return isLoggingIn ? null : '/login';
    }

    // Logged in -> prevent going to login/signup pages
    if (isLoggingIn) {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(path: '/login',  builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/home',   builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
      path: '/details',
      builder: (context, state) => MovieDetailsScreen(movie: state.extra as Movie),
    ),
  ],
);
