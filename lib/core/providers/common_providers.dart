import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/api_constants.dart';

final dioProvider = Provider<Dio>((ref) {
  final apiKey = ApiConstants.apiKey;
  final bool isBearerToken = apiKey.length > 50;

  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: isBearerToken ? {
      'Authorization': 'Bearer $apiKey',
      'accept': 'application/json',
    } : null,
  ));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: false,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
  return dio;
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn(
  serverClientId: '216300574155-g6kvrvkb6eglnq0a9ljhvsg6j5rbkqd5.apps.googleusercontent.com',
));
