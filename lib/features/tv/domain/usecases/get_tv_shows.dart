import 'package:cine_focus/features/movies/domain/entities/movie.dart';
import '../repositories/tv_repository.dart';

class GetTVShows {
  final TVRepository repository;
  GetTVShows(this.repository);

  Future<List<Movie>> call({int page = 1, Map<String, dynamic>? filters, String? query}) async {
    if (query != null && query.isNotEmpty) {
      return await repository.searchTVShows(query: query, page: page);
    }
    if (filters != null && filters.containsKey('list_type')) {
      return await repository.getTVList(filters['list_type'], page: page);
    }
    return await repository.discoverTVShows(page: page, filters: filters);
  }
}
