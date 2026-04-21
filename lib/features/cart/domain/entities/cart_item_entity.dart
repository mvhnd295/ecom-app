import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;
  final bool productExists;
  final bool productOutOfStock;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
    this.productExists = true,
    this.productOutOfStock = false,
  });

  double get lineTotal => productPrice * quantity;

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productImage,
        productPrice,
        quantity,
        selectedSize,
        selectedColor,
        productExists,
        productOutOfStock,
      ];
}
