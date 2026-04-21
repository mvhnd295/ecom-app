import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/services/api/api_endpoints.dart';
import 'package:fitflow/core/services/api/api_service.dart';
import 'package:fitflow/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    String? categoryId,
    String? criteria,
  });

  Future<ProductModel> getProductById(String id);

  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    String? categoryId,
    String? genderAgeCategory,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;
  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    String? categoryId,
    String? criteria,
  }) async {
    final result = await apiService.get<dynamic>(
      ApiEndpoints.getProducts,
      queryParameters: {
        'page': page,
        if (categoryId != null) 'category': categoryId,
        if (criteria != null) 'criteria': criteria,
      },
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => (data as List)
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final result = await apiService.get<Map<String, dynamic>>(
      ApiEndpoints.getProductById(id),
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => ProductModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 1,
    String? categoryId,
    String? genderAgeCategory,
  }) async {
    final result = await apiService.get<dynamic>(
      ApiEndpoints.searchProducts,
      queryParameters: {
        'q': query,
        'page': page,
        if (categoryId != null) 'category': categoryId,
        if (genderAgeCategory != null) 'genderAgeCategory': genderAgeCategory,
      },
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => (data as List)
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
