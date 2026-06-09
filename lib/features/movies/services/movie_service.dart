import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/movie_model.dart';
import '../../../core/constants/api_constants.dart';

class MovieService {
  late final Dio _dio;

  MovieService() {
    final apiKey = ApiConstants.apiKey;
    final bool isBearerToken = apiKey.length > 50;

    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
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
    if (apiKey.length <= 50) return {'api_key': apiKey};
    return {};
  }

  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _dio.get('/trending/movie/day', queryParameters: _getAuthParams());
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m, isTV: false)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load trending movies: ${e.message}');
    }
  }

  Future<List<Movie>> discoverMovies({int page = 1, Map<String, dynamic>? filters}) async {
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
        return results.map((m) => Movie.fromJson(m, isTV: false)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to discover movies: ${e.message}');
    }
  }

  Future<List<Movie>> getTVList(String type, {int page = 1}) async {
    try {
      final response = await _dio.get('/tv/$type', queryParameters: {..._getAuthParams(), 'page': page});
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m, isTV: true)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load TV list $type: ${e.message}');
    }
  }

  Future<List<Movie>> discoverTVShows({int page = 1, Map<String, dynamic>? filters}) async {
    try {
      final Map<String, dynamic> queryParameters = {
        ..._getAuthParams(),
        'page': page,
        'sort_by': 'popularity.desc',
        ...?filters,
      };
      final response = await _dio.get('/discover/tv', queryParameters: queryParameters);
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m, isTV: true)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to discover TV shows: ${e.message}');
    }
  }

  Future<List<Movie>> searchTVShows({required String query, int page = 1}) async {
    try {
      final response = await _dio.get('/search/tv', queryParameters: {..._getAuthParams(), 'query': query, 'page': page});
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m, isTV: true)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to search TV shows: ${e.message}');
    }
  }

  Future<String?> getAgeRating(int id, bool isTV) async {
    try {
      if (isTV) {
        final response = await _dio.get('/tv/$id/content_ratings', queryParameters: _getAuthParams());
        final List results = response.data['results'] ?? [];
        final usRating = results.firstWhere((r) => r['iso_3166_1'] == 'US', orElse: () => results.isNotEmpty ? results.first : null);
        return usRating?['rating'];
      } else {
        final response = await _dio.get('/movie/$id/release_dates', queryParameters: _getAuthParams());
        final List results = response.data['results'] ?? [];
        final usData = results.firstWhere((r) => r['iso_3166_1'] == 'US', orElse: () => null);
        if (usData != null) {
          final List releaseDates = usData['release_dates'] ?? [];
          return releaseDates.isNotEmpty ? releaseDates.first['certification'] : null;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCast(int id, bool isTV) async {
    try {
      final type = isTV ? 'tv' : 'movie';
      final response = await _dio.get('/$type/$id/credits', queryParameters: _getAuthParams());
      if (response.statusCode == 200 && response.data != null) {
        final List cast = response.data['cast'] ?? [];
        return cast.take(10).map((c) => {
          'name': c['name'],
          'character': c['character'],
          'profile_path': c['profile_path'],
        }).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<Movie>> getSimilar(int id, bool isTV) async {
    try {
      final type = isTV ? 'tv' : 'movie';
      final response = await _dio.get('/$type/$id/similar', queryParameters: _getAuthParams());
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.take(10).map((m) => Movie.fromJson(m, isTV: isTV)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<Movie>> searchMovies({required String query, int page = 1}) async {
    try {
      final response = await _dio.get('/search/movie', queryParameters: {..._getAuthParams(), 'query': query, 'page': page});
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => Movie.fromJson(m, isTV: false)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to search movies: ${e.message}');
    }
  }

  Future<String?> getYoutubeTrailerKey(int id, {bool isTV = false}) async {
    try {
      final type = isTV ? 'tv' : 'movie';
      final response = await _dio.get('/$type/$id/videos', queryParameters: _getAuthParams());
      final List results = response.data['results'] ?? [];
      final trailer = results.firstWhere((v) => v['type'] == 'Trailer' && v['site'] == 'YouTube', orElse: () => null);
      return trailer?['key'];
    } catch (_) {
      return null;
    }
  }
}
