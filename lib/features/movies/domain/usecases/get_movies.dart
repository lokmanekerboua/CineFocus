import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovies {
  final MovieRepository repository;
  GetMovies(this.repository);

  Future<List<Movie>> call({int page = 1, Map<String, dynamic>? filters, String? query}) async {
    if (query != null && query.isNotEmpty) {
      return await repository.searchMovies(query: query, page: page);
    }
    return await repository.discoverMovies(page: page, filters: filters);
  }
}
