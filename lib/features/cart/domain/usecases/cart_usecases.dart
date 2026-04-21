import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/cart/domain/entities/cart_item_entity.dart';
import 'package:fitflow/features/cart/domain/repositories/cart_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCartUsecase {
  final CartRepository repository;
  const GetCartUsecase(this.repository);

  Future<Either<Failure, List<CartItemEntity>>> call(String userId) =>
      repository.getCart(userId);
}

class GetCartCountUsecase {
  final CartRepository repository;
  const GetCartCountUsecase(this.repository);

  Future<Either<Failure, int>> call(String userId) =>
      repository.getCartCount(userId);
}

class GetCartItemByIdParams {
  final String userId;
  final String cartItemId;
  const GetCartItemByIdParams({
    required this.userId,
    required this.cartItemId,
  });
}

class GetCartItemByIdUsecase {
  final CartRepository repository;
  const GetCartItemByIdUsecase(this.repository);

  Future<Either<Failure, CartItemEntity>> call(GetCartItemByIdParams p) =>
      repository.getCartItemById(userId: p.userId, cartItemId: p.cartItemId);
}

class AddToCartParams {
  final String userId;
  final String productId;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const AddToCartParams({
    required this.userId,
    required this.productId,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });
}

class AddToCartUsecase {
  final CartRepository repository;
  const AddToCartUsecase(this.repository);

  Future<Either<Failure, CartItemEntity>> call(AddToCartParams p) =>
      repository.addToCart(
        userId: p.userId,
        productId: p.productId,
        quantity: p.quantity,
        selectedSize: p.selectedSize,
        selectedColor: p.selectedColor,
      );
}

class RemoveCartItemParams {
  final String userId;
  final String cartItemId;
  const RemoveCartItemParams({required this.userId, required this.cartItemId});
}

class RemoveCartItemUsecase {
  final CartRepository repository;
  const RemoveCartItemUsecase(this.repository);

  Future<Either<Failure, void>> call(RemoveCartItemParams p) =>
      repository.removeFromCart(userId: p.userId, cartItemId: p.cartItemId);
}

class ClearCartUsecase {
  final CartRepository repository;
  const ClearCartUsecase(this.repository);

  Future<Either<Failure, void>> call(String userId) =>
      repository.clearCart(userId);
}

class UpdateCartQuantityParams {
  final String userId;
  final String cartItemId;
  final CartQuantityAction action;

  const UpdateCartQuantityParams({
    required this.userId,
    required this.cartItemId,
    required this.action,
  });
}

class UpdateCartQuantityUsecase {
  final CartRepository repository;
  const UpdateCartQuantityUsecase(this.repository);

  Future<Either<Failure, CartItemEntity>> call(UpdateCartQuantityParams p) =>
      repository.updateCartItemQuantity(
        userId: p.userId,
        cartItemId: p.cartItemId,
        action: p.action,
      );
}

class SetCartQuantityParams {
  final String userId;
  final String cartItemId;
  final int quantity;

  const SetCartQuantityParams({
    required this.userId,
    required this.cartItemId,
    required this.quantity,
  });
}

class SetCartQuantityUsecase {
  final CartRepository repository;
  const SetCartQuantityUsecase(this.repository);

  Future<Either<Failure, CartItemEntity>> call(SetCartQuantityParams p) =>
      repository.setCartItemQuantity(
        userId: p.userId,
        cartItemId: p.cartItemId,
        quantity: p.quantity,
      );
}

class UpdateCartItemParams {
  final String userId;
  final String cartItemId;
  final String? selectedSize;
  final String? selectedColor;

  const UpdateCartItemParams({
    required this.userId,
    required this.cartItemId,
    this.selectedSize,
    this.selectedColor,
  });
}

class UpdateCartItemUsecase {
  final CartRepository repository;
  const UpdateCartItemUsecase(this.repository);

  Future<Either<Failure, CartItemEntity>> call(UpdateCartItemParams p) =>
      repository.updateCartItem(
        userId: p.userId,
        cartItemId: p.cartItemId,
        selectedSize: p.selectedSize,
        selectedColor: p.selectedColor,
      );
}
