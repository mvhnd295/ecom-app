import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/core/network/network_info.dart';
import 'package:fitflow/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fitflow/features/products/domain/entities/product_entity.dart';
import 'package:fitflow/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int page = 1,
    String? categoryId,
    String? criteria,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      final products = await remoteDataSource.getProducts(
        page: page,
        categoryId: categoryId,
        criteria: criteria,
      );
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    int page = 1,
    String? categoryId,
    String? genderAgeCategory,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      final products = await remoteDataSource.searchProducts(
        query: query,
        page: page,
        categoryId: categoryId,
        genderAgeCategory: genderAgeCategory,
      );
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
