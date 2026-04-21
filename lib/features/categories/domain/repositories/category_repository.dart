import 'package:fitflow/core/error/failures.dart';
import 'package:fitflow/features/categories/domain/entities/category_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id);
}
