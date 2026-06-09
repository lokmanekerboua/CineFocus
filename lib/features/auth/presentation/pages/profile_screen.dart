import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _showSignOutConfirmation(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121E21),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          title: Text(
            'Sign Out',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of CineFocus?',
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) context.go('/login');
              },
              child: Text(
                'Sign Out',
                style: GoogleFonts.poppins(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Center(child: Text("Not logged in", style: TextStyle(color: Colors.white)));
    }

    final String? avatarUrl = user.userMetadata?['avatar_url'] ?? user.userMetadata?['picture'];
    final String name = user.userMetadata?['full_name'] ?? user.userMetadata?['username'] ?? 'User';
    final String email = user.email ?? '';

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: AppTheme.moodyGradientBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Profile",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              // Avatar with Glow
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: colorScheme.surface,
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl == null
                        ? Icon(Icons.person,
                            size: 64, color: colorScheme.primary.withOpacity(0.5))
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),

              // Info Cards
              _buildProfileItem(
                icon: Icons.movie_outlined,
                title: "My Watchlist",
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 16),
              _buildProfileItem(
                icon: Icons.settings_outlined,
                title: "Settings",
                colorScheme: colorScheme,
              ),

              const SizedBox(height: 40),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showSignOutConfirmation(context, ref),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text("Sign Out"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 16),
        ],
      ),
    );
  }
}
