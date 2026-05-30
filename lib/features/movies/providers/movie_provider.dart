import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';

final movieServiceProvider = Provider((ref) => MovieService());

final trendingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieServiceProvider).getTrendingMovies();
});

final trailerKeyProvider = FutureProvider.family<String?, int>((ref, movieId) async {
  return ref.watch(movieServiceProvider).getYoutubeTrailerKey(movieId);
});

// Using Notifier instead of StateProvider for Riverpod 3.x compatibility
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
    if (query.isNotEmpty) {
      return ref.read(movieServiceProvider).searchMovies(query: query, page: page);
    } else {
      return ref.read(movieServiceProvider).discoverMovies(page: page, filters: filters);
    }
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
    } catch (e, st) {
      debugPrint('Pagination error: $e');
    } finally {
      _isFetching = false;
    }
  }
}

final moviesProvider = AsyncNotifierProvider<MoviesNotifier, List<Movie>>(MoviesNotifier.new);
