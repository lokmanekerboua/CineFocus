import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../movies/providers/movie_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../main_screen.dart';
import '../providers/tv_provider.dart';

class TVHomeScreen extends ConsumerStatefulWidget {
  const TVHomeScreen({super.key});

  @override
  ConsumerState<TVHomeScreen> createState() => _TVHomeScreenState();
}

class _TVHomeScreenState extends ConsumerState<TVHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  final List<Map<String, dynamic>> _filterCategories = [
    {'label': '🔥 Popular', 'filter': {'list_type': 'popular'}},
    {'label': '⭐ Top Rated', 'filter': {'list_type': 'top_rated'}},
    {'label': '📺 Airing Today', 'filter': {'list_type': 'airing_today'}},
    {'label': '📅 On The Air', 'filter': {'list_type': 'on_the_air'}},
    {'label': '🔫 Action', 'filter': {'with_genres': '10759'}},
    {'label': '😂 Comedy', 'filter': {'with_genres': '35'}},
    {'label': '🧪 Sci-Fi', 'filter': {'with_genres': '10765'}},
    {'label': '🎭 Drama', 'filter': {'with_genres': '18'}},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 400) {
      ref.read(tvShowsProvider.notifier).fetchNextPage();
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (query.isNotEmpty) {
        ref.read(tvFiltersProvider.notifier).state = {};
      }
      ref.read(tvSearchQueryProvider.notifier).state = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tvShowsAsync = ref.watch(tvShowsProvider);
    final user = ref.watch(userProvider);
    final activeFilters = ref.watch(tvFiltersProvider);
    final String? avatarUrl = user?.userMetadata?['avatar_url'] ?? user?.userMetadata?['picture'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: AppTheme.moodyGradientBackground,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              pinned: true,
              floating: true,
              snap: true,
              expandedHeight: 140,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.surface.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search TV shows...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                          prefixIcon: Icon(Icons.search, color: colorScheme.primary.withOpacity(0.5)),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => ref.read(navigationIndexProvider.notifier).setIndex(2),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.2),
                            blurRadius: 10,
                          )
                        ],
                        border: Border.all(color: colorScheme.primary.withOpacity(0.3), width: 1.5),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: colorScheme.surface,
                        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                        child: avatarUrl == null ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
                      ),
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filterCategories.length,
                    itemBuilder: (context, index) {
                      final item = _filterCategories[index];
                      final bool isSelected = activeFilters.toString() == item['filter'].toString();
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(item['label']),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              _searchController.clear();
                              ref.read(tvSearchQueryProvider.notifier).state = '';
                              ref.read(tvFiltersProvider.notifier).state = item['filter'];
                            }
                          },
                          backgroundColor: Colors.white.withOpacity(0.05),
                          selectedColor: colorScheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected ? colorScheme.primary : Colors.white.withOpacity(0.1),
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            tvShowsAsync.when(
              data: (shows) {
                if (shows.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tv_outlined, size: 64, color: colorScheme.primary.withOpacity(0.2)),
                          const SizedBox(height: 16),
                          Text("No TV shows found", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 18)),
                        ],
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _TVCard(show: shows[index]);
                      },
                      childCount: shows.length,
                    ),
                  ),
                );
              },
              error: (e, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text("Error: ${e.toString()}", style: const TextStyle(color: Colors.red))),
              ),
              loading: () => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
              ),
            ),
            if (tvShowsAsync.isLoading && tvShowsAsync.hasValue)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}

class _TVCard extends StatelessWidget {
  final dynamic show;
  const _TVCard({required this.show});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/details', extra: show),
      child: Hero(
        tag: 'movie-${show.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: "${ApiConstants.imageBaseUrl}${show.posterPath}",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: colorScheme.surface,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: colorScheme.surface,
                    child: const Icon(Icons.movie, color: Colors.white24),
                  ),
                ),
                if (show.ageRating != null && show.ageRating.isNotEmpty)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.primary.withOpacity(0.5)),
                      ),
                      child: Text(
                        show.ageRating,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          show.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: colorScheme.primary, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              show.voteAverage.toStringAsFixed(1),
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (show.releaseDate.isNotEmpty)
                              Text(
                                show.releaseDate.split('-').first,
                                style: const TextStyle(color: Colors.white60, fontSize: 11),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
