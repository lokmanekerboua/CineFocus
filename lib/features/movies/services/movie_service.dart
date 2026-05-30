import 'package:dio/dio.dart';
import '../models/movie_model.dart';
import '../../../core/constants/api_constants.dart';

class MovieService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _dio.get('/trending/movie/day', queryParameters: {
        'api_key': ApiConstants.apiKey,
      });
      
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load trending movies: $e');
    }
  }

  Future<List<Movie>> discoverMovies({
    int page = 1,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'api_key': ApiConstants.apiKey,
        'page': page,
        'sort_by': 'popularity.desc',
        ...?filters,
      };

      final response = await _dio.get('/discover/movie', queryParameters: queryParameters);
      
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to discover movies: $e');
    }
  }

  Future<List<Movie>> searchMovies({required String query, int page = 1}) async {
    try {
      final response = await _dio.get('/search/movie', queryParameters: {
        'api_key': ApiConstants.apiKey,
        'query': query,
        'page': page,
      });
      
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  Future<String?> getYoutubeTrailerKey(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId/videos', queryParameters: {
        'api_key': ApiConstants.apiKey,
      });
      
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        final trailer = results.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
          orElse: () => null,
        );
        return trailer?['key'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
