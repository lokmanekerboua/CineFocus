import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';

final movieServiceProvider = Provider((ref) => MovieService());

// Simplified argument for detail-related providers
typedef ContentArgs = ({int id, bool isTV});

final trailerKeyProvider = FutureProvider.family<String?, ContentArgs>((ref, args) async {
  return ref.watch(movieServiceProvider).getYoutubeTrailerKey(args.id, isTV: args.isTV);
});

final castProvider = FutureProvider.family<List<Map<String, dynamic>>, ContentArgs>((ref, args) async {
  return ref.watch(movieServiceProvider).getCast(args.id, args.isTV);
});

final similarContentProvider = FutureProvider.family<List<Movie>, ContentArgs>((ref, args) async {
  return ref.watch(movieServiceProvider).getSimilar(args.id, args.isTV);
});

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  set state(String value) => super.state = value;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class MovieFiltersNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {};
  set state(Map<String, dynamic> value) => super.state = value;
}

final movieFiltersProvider = NotifierProvider<MovieFiltersNotifier, Map<String, dynamic>>(MovieFiltersNotifier.new);

class MoviesNotifier extends AsyncNotifier<List<Movie>> {
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;

  @override
  Future<List<Movie>> build() async {
    final query = ref.watch(searchQueryProvider);
    final filters = ref.watch(movieFiltersProvider);
    _currentPage = 1;
    _hasMore = true;
    return _fetchMovies(1, query, filters);
  }

  Future<List<Movie>> _fetchMovies(int page, String query, Map<String, dynamic> filters) async {
    List<Movie> movies;
    if (query.isNotEmpty) {
      movies = await ref.read(movieServiceProvider).searchMovies(query: query, page: page);
    } else {
      movies = await ref.read(movieServiceProvider).discoverMovies(page: page, filters: filters);
    }

    // Fetch age ratings for movies as well for consistency
    final moviesWithRatings = await Future.wait(movies.map((movie) async {
      try {
        final rating = await ref.read(movieServiceProvider).getAgeRating(movie.id, false);
        return movie.copyWith(ageRating: rating);
      } catch (_) {
        return movie;
      }
    }));

    return moviesWithRatings;
  }

  Future<void> fetchNextPage() async {
    if (_isFetching || !_hasMore) return;
    _isFetching = true;
    
    final query = ref.read(searchQueryProvider);
    final filters = ref.read(movieFiltersProvider);
    final currentState = state.value ?? [];
    
    try {
      _currentPage++;
      final nextMovies = await _fetchMovies(_currentPage, query, filters);
      
      if (nextMovies.isEmpty) {
        _hasMore = false;
      } else {
        state = AsyncData([...currentState, ...nextMovies]);
      }
    } catch (e) {
      debugPrint('Movie Pagination error: $e');
    } finally {
      _isFetching = false;
    }
  }
}

final moviesProvider = AsyncNotifierProvider<MoviesNotifier, List<Movie>>(MoviesNotifier.new);
