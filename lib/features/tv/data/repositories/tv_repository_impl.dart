import 'package:cine_focus/features/movies/domain/entities/movie.dart';
import 'package:cine_focus/features/tv/domain/repositories/tv_repository.dart';
import 'package:cine_focus/features/tv/data/datasources/tv_remote_data_source.dart';

class TVRepositoryImpl implements TVRepository {
  final TVRemoteDataSource remoteDataSource;

  TVRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Movie>> getTVList(String type, {int page = 1}) async {
    return await remoteDataSource.getTVList(type, page: page);
  }

  @override
  Future<List<Movie>> discoverTVShows({int page = 1, Map<String, dynamic>? filters}) async {
    return await remoteDataSource.discoverTVShows(page: page, filters: filters);
  }

  @override
  Future<List<Movie>> searchTVShows({required String query, int page = 1}) async {
    return await remoteDataSource.searchTVShows(query: query, page: page);
  }

  @override
  Future<String?> getAgeRating(int id) async {
    return await remoteDataSource.getAgeRating(id);
  }
}
