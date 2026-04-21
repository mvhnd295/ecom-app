import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/cart/data/datasources/cart_remote_data_source.dart'
    show CartQuantityAction;
import 'package:fitflow/features/cart/domain/entities/cart_item_entity.dart';
import 'package:fpdart/fpdart.dart';

export 'package:fitflow/features/cart/data/datasources/cart_remote_data_source.dart'
    show CartQuantityAction;

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart(String userId);

  Future<Either<Failure, int>> getCartCount(String userId);

  Future<Either<Failure, CartItemEntity>> getCartItemById({
    required String userId,
    required String cartItemId,
  });

  Future<Either<Failure, CartItemEntity>> addToCart({
    required String userId,
    required String productId,
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  });

  Future<Either<Failure, void>> removeFromCart({
    required String userId,
    required String cartItemId,
  });

  Future<Either<Failure, void>> clearCart(String userId);

  Future<Either<Failure, CartItemEntity>> updateCartItemQuantity({
    required String userId,
    required String cartItemId,
    required CartQuantityAction action,
  });

  Future<Either<Failure, CartItemEntity>> setCartItemQuantity({
    required String userId,
    required String cartItemId,
    required int quantity,
  });

  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String userId,
    required String cartItemId,
    String? selectedSize,
    String? selectedColor,
  });
}
