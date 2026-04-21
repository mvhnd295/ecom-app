import 'package:fitflow/features/products/domain/entities/product_entity.dart';

sealed class ProductListState {
  const ProductListState();
}

class ProductListInitial extends ProductListState {
  const ProductListInitial();
}

class ProductListLoading extends ProductListState {
  const ProductListLoading();
}

class ProductListLoaded extends ProductListState {
  final List<ProductEntity> products;
  final String? categoryId;
  const ProductListLoaded(this.products, {this.categoryId});
}

class ProductListError extends ProductListState {
  final String message;
  const ProductListError(this.message);
}
