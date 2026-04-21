import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/products/domain/entities/product_entity.dart';
import 'package:fitflow/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class SearchProductsParams {
  final String query;
  final int page;
  final String? categoryId;
  final String? genderAgeCategory;

  const SearchProductsParams({
    required this.query,
    this.page = 1,
    this.categoryId,
    this.genderAgeCategory,
  });
}

class SearchProductsUsecase {
  final ProductRepository repository;
  const SearchProductsUsecase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(
    SearchProductsParams params,
  ) {
    return repository.searchProducts(
      query: params.query,
      page: params.page,
      categoryId: params.categoryId,
      genderAgeCategory: params.genderAgeCategory,
    );
  }
}
