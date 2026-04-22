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