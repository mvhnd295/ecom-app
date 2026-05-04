import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/services/api/api_endpoints.dart';
import 'package:fitflow/core/services/api/api_service.dart';
import 'package:fitflow/features/auth/domain/entities/address.dart';

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

  Future<void> verifyOtp({required String email, required String otp});

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String name,
    required String phone,
    Address? address,
  });
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

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    final result = await apiService.post<Map<String, dynamic>>(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
    result.fold(
      (failure) => throw ServerException(message: failure.message),
      (_) {},
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final result = await apiService.post<Map<String, dynamic>>(
      ApiEndpoints.resetPassword,
      data: {'email': email, 'newPassword': newPassword},
    );
    result.fold(
      (failure) => throw ServerException(message: failure.message),
      (_) {},
    );
  }

  @override
  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String name,
    required String phone,
    Address? address,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'phone': phone,
      if (address != null) ...{
        'country': address.country,
        'city': address.city,
        'street': address.street,
        'postalCode': address.postalCode,
        'houseNumber': address.houseNumber,
        'apartmentNumber': address.apartmentNumber,
      },
    };

    final result = await apiService.put<Map<String, dynamic>>(
      ApiEndpoints.updateUser(userId),
      data: data,
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (response) => Map<String, dynamic>.from(response),
    );
  }
}
