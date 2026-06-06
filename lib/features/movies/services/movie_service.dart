import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import '../../../core/constants/api_constants.dart';

class MovieService {
  late final Dio _dio;

  MovieService() {
    final apiKey = ApiConstants.apiKey;
    // TMDB API Keys are usually 32 chars. Access Tokens (v4) are much longer.
    final bool isBearerToken = apiKey.length > 50;

    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: isBearerToken ? {
        'Authorization': 'Bearer $apiKey',
        'accept': 'application/json',
      } : null,
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestHeader: true,
        requestBody: false,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Map<String, dynamic> _getAuthParams() {
    final apiKey = ApiConstants.apiKey;
    // Only pass api_key in query if it's NOT a bearer token
    if (apiKey.length <= 50) {
      return {'api_key': apiKey};
    }
    return {};
  }

  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _dio.get('/trending/movie/day', queryParameters: _getAuthParams());
      
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logError('Trending', e);
      throw Exception('Failed to load trending movies: ${e.message}');
    }
  }

  Future<List<Movie>> discoverMovies({
    int page = 1,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        ..._getAuthParams(),
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
    } on DioException catch (e) {
      _logError('Discover', e);
      throw Exception('Failed to discover movies: ${e.message}');
    }
  }

  Future<List<Movie>> searchMovies({required String query, int page = 1}) async {
    try {
      final response = await _dio.get('/search/movie', queryParameters: {
        ..._getAuthParams(),
        'query': query,
        'page': page,
      });
      
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m)).toList();
      }
      return [];
    } on DioException catch (e) {
      _logError('Search', e);
      throw Exception('Failed to search movies: ${e.message}');
    }
  }

  Future<String?> getYoutubeTrailerKey(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId/videos', queryParameters: _getAuthParams());
      
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

  void _logError(String type, DioException e) {
    debugPrint('TMDB $type Error [${e.response?.statusCode}]: ${e.response?.data}');
    if (e.response?.statusCode == 401) {
      debugPrint('Check if TMDB_API_KEY in .env is valid and matches the type (Key vs Token)');
    }
  }
}
