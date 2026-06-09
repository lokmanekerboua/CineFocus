import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Movie>> getTrendingMovies() async {
    return await remoteDataSource.getTrendingMovies();
  }

  @override
  Future<List<Movie>> discoverMovies({int page = 1, Map<String, dynamic>? filters}) async {
    return await remoteDataSource.discoverMovies(page: page, filters: filters);
  }

  @override
  Future<List<Movie>> searchMovies({required String query, int page = 1}) async {
    return await remoteDataSource.searchMovies(query: query, page: page);
  }

  @override
  Future<String?> getAgeRating(int id, bool isTV) async {
    return await remoteDataSource.getAgeRating(id, isTV);
  }

  @override
  Future<List<Map<String, dynamic>>> getCast(int id, bool isTV) async {
    return await remoteDataSource.getCast(id, isTV);
  }

  @override
  Future<List<Movie>> getSimilar(int id, bool isTV) async {
    return await remoteDataSource.getSimilar(id, isTV);
  }

  @override
  Future<String?> getYoutubeTrailerKey(int id, {bool isTV = false}) async {
    return await remoteDataSource.getYoutubeTrailerKey(id, isTV: isTV);
  }
}
