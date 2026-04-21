import 'package:fitflow/features/products/domain/entities/product_entity.dart';

sealed class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

class ProductDetailLoaded extends ProductDetailState {
  final ProductEntity product;
  const ProductDetailLoaded(this.product);
}

class ProductDetailError extends ProductDetailState {
  final String message;
  const ProductDetailError(this.message);
}
