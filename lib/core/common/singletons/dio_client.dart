import 'package:dio/dio.dart';
import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio _dio;
  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(_getInterceptor());
  }
  static final DioClient _instance = DioClient._();
  factory DioClient() => _instance;
  Dio get dio => _dio;

  Interceptor _getInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await cacheService.getSessionToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (kDebugMode) {
          debugPrint('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Data: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (kDebugMode) {
          debugPrint(
            '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          debugPrint('Data: ${response.data}');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (kDebugMode) {
          debugPrint(
            '❌ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          debugPrint('Message: ${e.message}');
          debugPrint('Error Data: ${e.response?.data}');
        }
        if (e.response?.statusCode == 401) {
          // Handle 401 errors - unauthorized access - token might be invalid or expired
          await cacheService.clearUserData(); // Clear auth data
          // TODO: Navigate to login screen (HANDLED OUTSIDE OF THIS CLASS BY ROUTER GUARD)
        }
        return handler.next(e);
      },
    );
  }

  // Refresh Token if needed
  Future<void> refreshToken(String newToken) async {
    await cacheService.setSessionToken(newToken);
    _dio.options.headers['Authorization'] = 'Bearer $newToken';
  }
}
// Global instance
final dioClient = DioClient();
