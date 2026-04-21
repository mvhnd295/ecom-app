import 'package:fitflow/features/categories/domain/entities/category_entity.dart';

sealed class CategoryListState {
  const CategoryListState();
}

class CategoryListInitial extends CategoryListState {
  const CategoryListInitial();
}

class CategoryListLoading extends CategoryListState {
  const CategoryListLoading();
}

class CategoryListLoaded extends CategoryListState {
  final List<CategoryEntity> categories;
  const CategoryListLoaded(this.categories);
}

class CategoryListError extends CategoryListState {
  final String message;
  const CategoryListError(this.message);
}
