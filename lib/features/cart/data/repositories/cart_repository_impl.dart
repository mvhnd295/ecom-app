import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/core/network/network_info.dart';
import 'package:fitflow/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:fitflow/features/cart/domain/entities/cart_item_entity.dart';
import 'package:fitflow/features/cart/domain/repositories/cart_repository.dart';
import 'package:fpdart/fpdart.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const CartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      return Right(await run());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCart(String userId) =>
      _guard(() => remoteDataSource.getCart(userId));

  @override
  Future<Either<Failure, int>> getCartCount(String userId) =>
      _guard(() => remoteDataSource.getCartCount(userId));

  @override
  Future<Either<Failure, CartItemEntity>> getCartItemById({
    required String userId,
    required String cartItemId,
  }) =>
      _guard(() => remoteDataSource.getCartItemById(
            userId: userId,
            cartItemId: cartItemId,
          ));

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required String userId,
    required String productId,
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) =>
      _guard(() => remoteDataSource.addToCart(
            userId: userId,
            productId: productId,
            quantity: quantity,
            selectedSize: selectedSize,
            selectedColor: selectedColor,
          ));

  @override
  Future<Either<Failure, void>> removeFromCart({
    required String userId,
    required String cartItemId,
  }) =>
      _guard(() => remoteDataSource.removeFromCart(
            userId: userId,
            cartItemId: cartItemId,
          ));

  @override
  Future<Either<Failure, void>> clearCart(String userId) =>
      _guard(() => remoteDataSource.clearCart(userId));

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItemQuantity({
    required String userId,
    required String cartItemId,
    required CartQuantityAction action,
  }) =>
      _guard(() => remoteDataSource.updateCartItemQuantity(
            userId: userId,
            cartItemId: cartItemId,
            action: action,
          ));

  @override
  Future<Either<Failure, CartItemEntity>> setCartItemQuantity({
    required String userId,
    required String cartItemId,
    required int quantity,
  }) =>
      _guard(() => remoteDataSource.setCartItemQuantity(
            userId: userId,
            cartItemId: cartItemId,
            quantity: quantity,
          ));

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String userId,
    required String cartItemId,
    String? selectedSize,
    String? selectedColor,
  }) =>
      _guard(() => remoteDataSource.updateCartItem(
            userId: userId,
            cartItemId: cartItemId,
            selectedSize: selectedSize,
            selectedColor: selectedColor,
          ));
}
