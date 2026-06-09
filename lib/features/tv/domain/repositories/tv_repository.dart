import 'package:cine_focus/features/movies/domain/entities/movie.dart';

abstract class TVRepository {
  Future<List<Movie>> getTVList(String type, {int page = 1});
  Future<List<Movie>> discoverTVShows({int page = 1, Map<String, dynamic>? filters});
  Future<List<Movie>> searchTVShows({required String query, int page = 1});
  Future<String?> getAgeRating(int id);
}
