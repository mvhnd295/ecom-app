import 'package:dio/dio.dart';
import 'package:fitflow/core/common/singletons/dio_client.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

class ApiService {
  final Dio _dio = dioClient.dio;

  // Singleton
  ApiService._();
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  // Generic GET request
  Future<Either<Failure, T>> get<T>(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }
  // Generic POST request
  Future<Either<Failure, T>> post<T>(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }
  // Generic PUT request
  Future<Either<Failure, T>> put<T>(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }
  // Generic DELETE request
  Future<Either<Failure, T>> delete<T>(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }


  Failure _handleError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout => ServerFailure(message: 'Connection timeout. Please try again.'),
      DioExceptionType.sendTimeout => ServerFailure(message: 'Request timeout. Please try again.'),
      DioExceptionType.receiveTimeout => ServerFailure(message: 'Response timeout. Please try again.'),
      DioExceptionType.badResponse => _handleBadResponse(e),
      DioExceptionType.cancel => ServerFailure(message: 'Request was cancelled.'),
      DioExceptionType.unknown => UnknownFailure(message: 'An unexpected error occurred.'),
      DioExceptionType.badCertificate => ServerFailure(message: 'Bad certificate error.'),
      _ => ServerFailure(message: 'Network Error. Please check your connection.'),
    };
  }

  Failure _handleBadResponse(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data['message'];
    if (statusCode == 400) {
      return InputFailure(message: message ?? 'Bad request.');
    } else if (statusCode == 401) {
      return UnauthorizedFailure(message: message ?? 'Unauthorized. Please login again.');
    } else if (statusCode == 403) {
      return PermissionFailure(message: message ?? 'Forbidden access.');
    } else if (statusCode == 404) {
      return ServerFailure(message: message ?? 'Resource not found.');
    } else if (statusCode == 500 || statusCode == 501 || statusCode == 502 || statusCode == 503) {
      return ServerFailure(message: message ?? 'Internal server error. Please try later.');
    }
    return ServerFailure(message: message ?? 'Something went wrong.');
  }
}

final apiService = ApiService();
