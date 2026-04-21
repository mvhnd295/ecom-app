import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/products/domain/entities/product_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int page = 1,
    String? categoryId,
    String? criteria,
  });

  Future<Either<Failure, ProductEntity>> getProductById(String id);

  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    int page = 1,
    String? categoryId,
    String? genderAgeCategory,
  });
}
