import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/products/domain/entities/product_entity.dart';
import 'package:fitflow/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProductByIdUsecase {
  final ProductRepository repository;
  const GetProductByIdUsecase(this.repository);

  Future<Either<Failure, ProductEntity>> call(String id) {
    return repository.getProductById(id);
  }
}
