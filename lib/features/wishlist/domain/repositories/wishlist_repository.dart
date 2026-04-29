import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/auth/domain/entities/wishlist.dart';
import 'package:fpdart/fpdart.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getWishlist(String userId);
  Future<Either<Failure, void>> addToWishlist({
    required String userId,
    required String productId,
  });
  Future<Either<Failure, void>> removeFromWishlist({
    required String userId,
    required String productId,
  });
}
