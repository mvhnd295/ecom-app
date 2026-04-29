import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/core/network/network_info.dart';
import 'package:fitflow/features/auth/domain/entities/wishlist.dart';
import 'package:fitflow/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:fitflow/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:fpdart/fpdart.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const WishlistRepositoryImpl({
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
  Future<Either<Failure, List<WishlistItem>>> getWishlist(String userId) =>
      _guard(() => remoteDataSource.getWishlist(userId));

  @override
  Future<Either<Failure, void>> addToWishlist({
    required String userId,
    required String productId,
  }) =>
      _guard(() => remoteDataSource.addToWishlist(
            userId: userId,
            productId: productId,
          ));

  @override
  Future<Either<Failure, void>> removeFromWishlist({
    required String userId,
    required String productId,
  }) =>
      _guard(() => remoteDataSource.removeFromWishlist(
            userId: userId,
            productId: productId,
          ));
}
