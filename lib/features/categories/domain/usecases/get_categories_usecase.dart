import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/categories/domain/entities/category_entity.dart';
import 'package:fitflow/features/categories/domain/repositories/category_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCategoriesUsecase {
  final CategoryRepository repository;
  const GetCategoriesUsecase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
