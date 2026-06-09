import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get apiKey {
    final key = dotenv.env['TMDB_API_KEY'] ?? 
                dotenv.env['API_KEY'] ?? 
                dotenv.env['tmdb_api_key'];

    if (key == null || key.isEmpty) {
      debugPrint('❌ API_ERROR: TMDB_API_KEY not found in .env');
      return 'b577c13bfefab17dbfc6c0c160cdc868';
    }

    if (kDebugMode) {
      final obscuredKey = '${key.substring(0, 4)}...${key.substring(key.length - 4)}';
      debugPrint('✅ API_INFO: Loaded TMDB Key: $obscuredKey (Length: ${key.length})');
    }
    
    return key;
  }

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/original';
}
