import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movies/presentation/pages/home_screen.dart';
import 'tv/presentation/pages/tv_home_screen.dart';
import 'auth/presentation/pages/profile_screen.dart';

class NavigationIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final navigationIndexProvider = NotifierProvider<NavigationIndexNotifier, int>(NavigationIndexNotifier.new);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final List<Widget> pages = [
      const HomeScreen(),
      const TVHomeScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Center(
            heightFactor: 1,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF121E21).withOpacity(0.95),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BottomNavItem(
                    icon: Icons.movie_filter_outlined,
                    selectedIcon: Icons.movie_filter_rounded,
                    isSelected: selectedIndex == 0,
                    onTap: () => ref.read(navigationIndexProvider.notifier).setIndex(0),
                  ),
                  const SizedBox(width: 8),
                  _BottomNavItem(
                    icon: Icons.tv_outlined,
                    selectedIcon: Icons.tv_rounded,
                    isSelected: selectedIndex == 1,
                    onTap: () => ref.read(navigationIndexProvider.notifier).setIndex(1),
                  ),
                  const SizedBox(width: 8),
                  _BottomNavItem(
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                    isSelected: selectedIndex == 2,
                    onTap: () => ref.read(navigationIndexProvider.notifier).setIndex(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 60,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? colorScheme.primary : Colors.white.withOpacity(0.4),
          size: 26,
        ),
      ),
    );
  }
}
