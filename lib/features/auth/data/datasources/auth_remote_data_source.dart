import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/services/api/api_endpoints.dart';
import 'package:fitflow/core/services/api/api_service.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  Future<void> forgotPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;
  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await apiService.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) {
        return Map<String, dynamic>.from(data);
      },
    );
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final result = await apiService.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) {
        return Map<String, dynamic>.from(data);
      },
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final result = await apiService.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    result.fold(
      (failure) => throw ServerException(message: failure.message),
      (_) {},
    );
  }
}
