import 'package:dio/dio.dart';
import '../models/movie_model.dart';
import '../../../core/constants/api_constants.dart';

class MovieService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<List<Movie>> getTrendingMovies() async {
    final response = await _dio.get('/trending/movie/day', queryParameters: {
      'api_key': ApiConstants.apiKey,
    });
    return (response.data['results'] as List)
        .map((m) => Movie.fromJson(m))
        .toList();
  }

  Future<String?> getYoutubeTrailerKey(int movieId) async {
    final response = await _dio.get('/movie/$movieId/videos', queryParameters: {
      'api_key': ApiConstants.apiKey,
    });
    final videos = response.data['results'] as List;
    final trailer = videos.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
      orElse: () => null,
    );
    return trailer?['key'];
  }
}