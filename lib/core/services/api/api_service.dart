import 'package:dio/dio.dart';
import 'package:fitflow/core/common/singletons/dio_client.dart';
import 'package:fitflow/core/services/api/api_endpoints.dart';

class ApiService {
  final Dio _dio = dioClient.dio;

  // Singleton
  ApiService._();
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  /// Verify if current token is valid
  Future<bool> verifyToken() async {
    try {
      final response = await _dio.get(ApiEndpoints.login);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  String _handleError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout => 'Connection timeout. Please try again.',
      DioExceptionType.sendTimeout => 'Request timeout. Please try again.',
      DioExceptionType.receiveTimeout => 'Response timeout. Please try again.',
      DioExceptionType.badResponse => _handleBadResponse(e),
      DioExceptionType.cancel => 'Request was cancelled.',
      DioExceptionType.unknown => 'An unexpected error occurred.',
      DioExceptionType.badCertificate => 'Bad certificate error.',
      _ => 'Network Error. Please check your connection.',
    };
  }

  String _handleBadResponse(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data['message'];
    if (statusCode == 400) {
      return message ?? 'Bad request.';
    } else if (statusCode == 401) {
      return message ?? 'Unauthorized. Please login again.';
    } else if (statusCode == 403) {
      return message ?? 'Forbidden access.';
    } else if (statusCode == 404) {
      return message ?? 'Resource not found.';
    } else if (statusCode == 500) {
      return message ?? 'Internal server error. Please try later.';
    }
    return message ?? 'Something went wrong.';
  }
}
final apiService = ApiService();
