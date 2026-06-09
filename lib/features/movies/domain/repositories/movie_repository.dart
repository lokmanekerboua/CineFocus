import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> discoverMovies({int page = 1, Map<String, dynamic>? filters});
  Future<List<Movie>> searchMovies({required String query, int page = 1});
  Future<String?> getAgeRating(int id, bool isTV);
  Future<List<Map<String, dynamic>>> getCast(int id, bool isTV);
  Future<List<Movie>> getSimilar(int id, bool isTV);
  Future<String?> getYoutubeTrailerKey(int id, {bool isTV = false});
}
