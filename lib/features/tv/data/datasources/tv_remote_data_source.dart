import 'package:dio/dio.dart';
import 'package:cine_focus/features/movies/data/models/movie_model.dart';
import 'package:cine_focus/core/constants/api_constants.dart';

abstract class TVRemoteDataSource {
  Future<List<MovieModel>> getTVList(String type, {int page = 1});
  Future<List<MovieModel>> discoverTVShows({int page = 1, Map<String, dynamic>? filters});
  Future<List<MovieModel>> searchTVShows({required String query, int page = 1});
  Future<String?> getAgeRating(int id);
}

class TVRemoteDataSourceImpl implements TVRemoteDataSource {
  final Dio _dio;

  TVRemoteDataSourceImpl(this._dio);

  Map<String, dynamic> _getAuthParams() {
    final apiKey = ApiConstants.apiKey;
    if (apiKey.length <= 50) return {'api_key': apiKey};
    return {};
  }

  @override
  Future<List<MovieModel>> getTVList(String type, {int page = 1}) async {
    try {
      final response = await _dio.get('/tv/$type', queryParameters: {..._getAuthParams(), 'page': page});
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => MovieModel.fromJson(m, isTV: true)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load TV list $type: ${e.message}');
    }
  }

  @override
  Future<List<MovieModel>> discoverTVShows({int page = 1, Map<String, dynamic>? filters}) async {
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
        return results.map((m) => MovieModel.fromJson(m, isTV: true)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to discover TV shows: ${e.message}');
    }
  }

  @override
  Future<List<MovieModel>> searchTVShows({required String query, int page = 1}) async {
    try {
      final response = await _dio.get('/search/tv', queryParameters: {..._getAuthParams(), 'query': query, 'page': page});
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] ?? [];
        return results.map((m) => MovieModel.fromJson(m, isTV: true)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to search TV shows: ${e.message}');
    }
  }

  @override
  Future<String?> getAgeRating(int id) async {
    try {
      final response = await _dio.get('/tv/$id/content_ratings', queryParameters: _getAuthParams());
      final List results = response.data['results'] ?? [];
      final usRating = results.firstWhere((r) => r['iso_3166_1'] == 'US', orElse: () => results.isNotEmpty ? results.first : null);
      return usRating?['rating'];
    } catch (_) {
      return null;
    }
  }
}
