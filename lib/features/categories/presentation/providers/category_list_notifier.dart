import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:fitflow/features/categories/presentation/providers/category_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryListNotifier extends Notifier<CategoryListState> {
  late final GetCategoriesUsecase _getCategories;

  @override
  CategoryListState build() {
    _getCategories = sl<GetCategoriesUsecase>();
    return const CategoryListInitial();
  }

  Future<void> load() async {
    state = const CategoryListLoading();
    final result = await _getCategories();
    result.fold(
      (failure) => state = CategoryListError(failure.message),
      (categories) => state = CategoryListLoaded(categories),
    );
  }
}

final categoryListProvider =
    NotifierProvider<CategoryListNotifier, CategoryListState>(
      CategoryListNotifier.new,
    );
