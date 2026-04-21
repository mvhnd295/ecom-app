import 'package:fitflow/core/error/exceptions.dart';
import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/core/network/network_info.dart';
import 'package:fitflow/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:fitflow/features/categories/domain/entities/category_entity.dart';
import 'package:fitflow/features/categories/domain/repositories/category_repository.dart';
import 'package:fpdart/fpdart.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      final category = await remoteDataSource.getCategoryById(id);
      return Right(category);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
