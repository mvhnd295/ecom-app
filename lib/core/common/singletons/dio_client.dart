import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:fitflow/core/constants/app_constants.dart';
import 'package:fitflow/core/services/api/api_endpoints.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio _dio;
  // Separate Dio for the refresh call so it bypasses our auth interceptor
  // and cannot recurse on its own 401.
  late final Dio _refreshDio;
  Completer<String?>? _refreshCompleter;

  DioClient._() {
    final base = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    _dio = Dio(base);
    _refreshDio = Dio(base);
    _dio.interceptors.add(_authInterceptor());
  }
  static final DioClient _instance = DioClient._();
  factory DioClient() => _instance;
  Dio get dio => _dio;

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = cacheService.sessionToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (kDebugMode) {
          debugPrint('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
          debugPrint('Data: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint(
            '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (kDebugMode) {
          debugPrint(
            '❌ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          debugPrint('Error Data: ${e.response?.data}');
        }

        final isUnauthorized = e.response?.statusCode == 401;
        final isRefreshCall =
            e.requestOptions.path == ApiEndpoints.refreshToken;
        final alreadyRetried = e.requestOptions.extra[_retriedKey] == true;

        if (!isUnauthorized || isRefreshCall || alreadyRetried) {
          return handler.next(e);
        }

        final newToken = await _refreshAccessToken();
        if (newToken == null) {
          await cacheService.clearUserData();
          // Router redirect picks up the missing auth on the next navigation.
          return handler.next(e);
        }

        final opts = e.requestOptions
          ..headers['Authorization'] = 'Bearer $newToken'
          ..extra[_retriedKey] = true;
        try {
          final retry = await _dio.fetch(opts);
          return handler.resolve(retry);
        } on DioException catch (err) {
          return handler.next(err);
        }
      },
    );
  }

  /// Concurrent 401s share the same refresh call. Returns the new access
  /// token, or null if the refresh failed (caller should treat as logged out).
  Future<String?> _refreshAccessToken() async {
    final existing = _refreshCompleter;
    if (existing != null) return existing.future;

    final completer = Completer<String?>();
    _refreshCompleter = completer;

    try {
      final refreshToken = cacheService.refreshToken;
      if (refreshToken == null) {
        completer.complete(null);
        return null;
      }
      final resp = await _refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final newAccess = resp.data is Map
          ? resp.data['accessToken'] as String?
          : null;
      if (newAccess == null) {
        completer.complete(null);
        return null;
      }
      await cacheService.setSessionToken(newAccess);
      completer.complete(newAccess);
      return newAccess;
    } catch (_) {
      if (!completer.isCompleted) completer.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }

  static const _retriedKey = '_authRetried';
}

final dioClient = DioClient();
