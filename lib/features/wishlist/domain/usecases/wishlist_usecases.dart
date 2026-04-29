import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/auth/domain/entities/wishlist.dart';
import 'package:fitflow/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetWishlistUsecase {
  final WishlistRepository repository;
  const GetWishlistUsecase(this.repository);

  Future<Either<Failure, List<WishlistItem>>> call(String userId) =>
      repository.getWishlist(userId);
}

class AddToWishlistParams {
  final String userId;
  final String productId;
  const AddToWishlistParams({required this.userId, required this.productId});
}

class AddToWishlistUsecase {
  final WishlistRepository repository;
  const AddToWishlistUsecase(this.repository);

  Future<Either<Failure, void>> call(AddToWishlistParams p) =>
      repository.addToWishlist(userId: p.userId, productId: p.productId);
}

class RemoveFromWishlistParams {
  final String userId;
  final String productId;
  const RemoveFromWishlistParams({required this.userId, required this.productId});
}

class RemoveFromWishlistUsecase {
  final WishlistRepository repository;
  const RemoveFromWishlistUsecase(this.repository);

  Future<Either<Failure, void>> call(RemoveFromWishlistParams p) =>
      repository.removeFromWishlist(userId: p.userId, productId: p.productId);
}
