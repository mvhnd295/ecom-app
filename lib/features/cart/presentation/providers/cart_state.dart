import 'package:fitflow/features/cart/domain/entities/cart_item_entity.dart';

sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final Set<String> mutatingIds;

  const CartLoaded(this.items, {this.mutatingIds = const {}});

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.lineTotal);

  bool get isEmpty => items.isEmpty;

  CartLoaded copyWith({
    List<CartItemEntity>? items,
    Set<String>? mutatingIds,
  }) => CartLoaded(
        items ?? this.items,
        mutatingIds: mutatingIds ?? this.mutatingIds,
      );
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
}
