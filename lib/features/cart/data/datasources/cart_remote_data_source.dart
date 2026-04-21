import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/services/api/api_endpoints.dart';
import 'package:fitflow/core/services/api/api_service.dart';
import 'package:fitflow/features/cart/data/models/cart_item_model.dart';

enum CartQuantityAction { increment, decrement }

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCart(String userId);

  Future<int> getCartCount(String userId);

  Future<CartItemModel> getCartItemById({
    required String userId,
    required String cartItemId,
  });

  Future<CartItemModel> addToCart({
    required String userId,
    required String productId,
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  });

  Future<void> removeFromCart({
    required String userId,
    required String cartItemId,
  });

  Future<void> clearCart(String userId);

  Future<CartItemModel> updateCartItemQuantity({
    required String userId,
    required String cartItemId,
    required CartQuantityAction action,
  });

  Future<CartItemModel> setCartItemQuantity({
    required String userId,
    required String cartItemId,
    required int quantity,
  });

  Future<CartItemModel> updateCartItem({
    required String userId,
    required String cartItemId,
    String? selectedSize,
    String? selectedColor,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService apiService;
  CartRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<CartItemModel>> getCart(String userId) async {
    final result = await apiService.get<dynamic>(
      ApiEndpoints.getCart(userId),
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => (data as List)
          .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  @override
  Future<int> getCartCount(String userId) async {
    final result = await apiService.get<dynamic>(
      ApiEndpoints.getCartCount(userId),
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) {
        if (data is num) return data.toInt();
        if (data is Map) {
          final value = data['count'] ?? data['total'] ?? data['itemCount'];
          if (value is num) return value.toInt();
        }
        return 0;
      },
    );
  }

  @override
  Future<CartItemModel> getCartItemById({
    required String userId,
    required String cartItemId,
  }) async {
    final result = await apiService.get<dynamic>(
      ApiEndpoints.getCartItemById(userId, cartItemId),
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => CartItemModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  @override
  Future<CartItemModel> addToCart({
    required String userId,
    required String productId,
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) async {
    final result = await apiService.post<Map<String, dynamic>>(
      ApiEndpoints.addToCart(userId),
      data: {
        'productId': productId,
        'quantity': quantity,
        if (selectedSize != null) 'selectedSize': selectedSize,
        if (selectedColor != null) 'selectedColor': selectedColor,
      },
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => CartItemModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  @override
  Future<void> removeFromCart({
    required String userId,
    required String cartItemId,
  }) async {
    final result = await apiService.delete<Map<String, dynamic>>(
      ApiEndpoints.removeCartItem(userId, cartItemId),
    );
    result.fold(
      (failure) => throw ServerException(message: failure.message),
      (_) {},
    );
  }

  @override
  Future<void> clearCart(String userId) async {
    final result = await apiService.delete<Map<String, dynamic>>(
      ApiEndpoints.clearCart(userId),
    );
    result.fold(
      (failure) => throw ServerException(message: failure.message),
      (_) {},
    );
  }

  @override
  Future<CartItemModel> updateCartItemQuantity({
    required String userId,
    required String cartItemId,
    required CartQuantityAction action,
  }) async {
    final result = await apiService.patch<Map<String, dynamic>>(
      ApiEndpoints.updateCartItemQuantity(userId, cartItemId),
      data: {'action': action.name},
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => CartItemModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  @override
  Future<CartItemModel> setCartItemQuantity({
    required String userId,
    required String cartItemId,
    required int quantity,
  }) async {
    final result = await apiService.patch<Map<String, dynamic>>(
      ApiEndpoints.setCartQuantity(userId, cartItemId),
      data: {'quantity': quantity},
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => CartItemModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  @override
  Future<CartItemModel> updateCartItem({
    required String userId,
    required String cartItemId,
    String? selectedSize,
    String? selectedColor,
  }) async {
    final result = await apiService.put<Map<String, dynamic>>(
      ApiEndpoints.updateCartItem(userId, cartItemId),
      data: {
        if (selectedSize != null) 'selectedSize': selectedSize,
        if (selectedColor != null) 'selectedColor': selectedColor,
      },
    );
    return result.fold(
      (failure) => throw ServerException(message: failure.message),
      (data) => CartItemModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }
}
