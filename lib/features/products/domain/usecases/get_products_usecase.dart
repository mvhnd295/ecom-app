import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/products/domain/entities/product_entity.dart';
import 'package:fitflow/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProductsParams {
  final int page;
  final String? categoryId;
  final String? criteria;
  const GetProductsParams({this.page = 1, this.categoryId, this.criteria});
}

class GetProductsUsecase {
  final ProductRepository repository;
  const GetProductsUsecase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(GetProductsParams params) {
    return repository.getProducts(
      page: params.page,
      categoryId: params.categoryId,
      criteria: params.criteria,
    );
  }
}
