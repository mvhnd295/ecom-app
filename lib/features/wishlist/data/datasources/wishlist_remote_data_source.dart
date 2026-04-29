import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/services/api/api_endpoints.dart';
import 'package:fitflow/core/services/api/api_service.dart';
import 'package:fitflow/features/wishlist/data/models/wishlist_item_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<WishlistItemModel>> getWishlist(String userId);
  Future<void> addToWishlist({required String userId, required String productId});
  Future<void> removeFromWishlist({required String userId, required String productId});
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiService apiService;
  const WishlistRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<WishlistItemModel>> getWishlist(String userId) async {
    final result = await apiService.get<dynamic>(
      ApiEndpoints.getWishlist(userId),
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => (data as List)
          .map((e) => WishlistItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  @override
  Future<void> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    final result = await apiService.post<dynamic>(
      ApiEndpoints.addToWishlist(userId),
      data: {'productId': productId},
    );
    result.fold(
      (failure) => throw ServerException(message: failure.message),
      (_) {},
    );
  }

  @override
  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    final result = await apiService.delete<dynamic>(
      ApiEndpoints.removeFromWishlist(userId, productId),
    );
    result.fold(
      (failure) => throw ServerException(message: failure.message),
      (_) {},
    );
  }
}
