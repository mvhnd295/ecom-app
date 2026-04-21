import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/services/api/api_endpoints.dart';
import 'package:fitflow/core/services/api/api_service.dart';
import 'package:fitflow/features/categories/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService apiService;
  CategoryRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await apiService.get<dynamic>(ApiEndpoints.getCategories);
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => (data as List)
          .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    final result = await apiService.get<Map<String, dynamic>>(
      ApiEndpoints.getCategoryById(id),
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => CategoryModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }
}
