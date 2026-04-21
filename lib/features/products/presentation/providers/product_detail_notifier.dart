import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:fitflow/features/products/presentation/providers/product_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailNotifier extends Notifier<ProductDetailState> {
  late final GetProductByIdUsecase _getProductById;

  @override
  ProductDetailState build() {
    _getProductById = sl<GetProductByIdUsecase>();
    return const ProductDetailInitial();
  }

  Future<void> load(String id) async {
    state = const ProductDetailLoading();
    final result = await _getProductById(id);
    result.fold(
      (failure) => state = ProductDetailError(failure.message),
      (product) => state = ProductDetailLoaded(product),
    );
  }

  Future<void> refresh(String id) => load(id);
}

final productDetailProvider =
    NotifierProvider<ProductDetailNotifier, ProductDetailState>(
      ProductDetailNotifier.new,
    );
