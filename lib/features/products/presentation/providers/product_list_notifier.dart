import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/features/products/domain/usecases/get_products_usecase.dart';
import 'package:fitflow/features/products/presentation/providers/product_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListNotifier extends Notifier<ProductListState> {
  late final GetProductsUsecase _getProducts;
  GetProductsParams _lastParams = const GetProductsParams();

  @override
  ProductListState build() {
    _getProducts = sl<GetProductsUsecase>();
    return const ProductListInitial();
  }

  Future<void> load({String? categoryId, String? criteria}) async {
    _lastParams = GetProductsParams(
      categoryId: categoryId,
      criteria: criteria,
    );
    state = const ProductListLoading();
    final result = await _getProducts(_lastParams);
    result.fold(
      (failure) => state = ProductListError(failure.message),
      (products) =>
          state = ProductListLoaded(products, categoryId: categoryId),
    );
  }

  Future<void> refresh() => load(
        categoryId: _lastParams.categoryId,
        criteria: _lastParams.criteria,
      );
}

final productListProvider =
    NotifierProvider<ProductListNotifier, ProductListState>(
      ProductListNotifier.new,
    );
