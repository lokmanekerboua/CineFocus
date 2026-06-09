import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../movies/services/movie_service.dart';
import '../../movies/models/movie_model.dart';
import '../../movies/providers/movie_provider.dart';

final tvServiceProvider = Provider((ref) => MovieService());

class TVSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  set state(String value) => super.state = value;
}

final tvSearchQueryProvider = NotifierProvider<TVSearchQueryNotifier, String>(TVSearchQueryNotifier.new);

class TVFiltersNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {'list_type': 'popular'};
  set state(Map<String, dynamic> value) => super.state = value;
}

final tvFiltersProvider = NotifierProvider<TVFiltersNotifier, Map<String, dynamic>>(TVFiltersNotifier.new);

class TVShowsNotifier extends AsyncNotifier<List<Movie>> {
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;

  @override
  Future<List<Movie>> build() async {
    final query = ref.watch(tvSearchQueryProvider);
    final filters = ref.watch(tvFiltersProvider);
    _currentPage = 1;
    _hasMore = true;
    return _fetchTVShows(1, query, filters);
  }

  Future<List<Movie>> _fetchTVShows(int page, String query, Map<String, dynamic> filters) async {
    List<Movie> shows;
    
    if (query.isNotEmpty) {
      shows = await ref.read(tvServiceProvider).searchTVShows(query: query, page: page);
    } else if (filters.containsKey('list_type')) {
      shows = await ref.read(tvServiceProvider).getTVList(filters['list_type'], page: page);
    } else {
      shows = await ref.read(tvServiceProvider).discoverTVShows(page: page, filters: filters);
    }

    final showsWithRatings = await Future.wait(shows.map((show) async {
      try {
        final rating = await ref.read(tvServiceProvider).getAgeRating(show.id, true);
        return show.copyWith(ageRating: rating);
      } catch (_) {
        return show;
      }
    }));

    return showsWithRatings;
  }

  Future<void> fetchNextPage() async {
    if (_isFetching || !_hasMore) return;
    _isFetching = true;
    
    final query = ref.read(tvSearchQueryProvider);
    final filters = ref.read(tvFiltersProvider);
    final currentState = state.value ?? [];
    
    try {
      _currentPage++;
      final nextShows = await _fetchTVShows(_currentPage, query, filters);

      if (nextShows.isEmpty) {
        _hasMore = false;
      } else {
        state = AsyncData([...currentState, ...nextShows]);
      }
    } catch (e) {
      debugPrint('TV Pagination error: $e');
    } finally {
      _isFetching = false;
    }
  }
}

final tvShowsProvider = AsyncNotifierProvider<TVShowsNotifier, List<Movie>>(TVShowsNotifier.new);
