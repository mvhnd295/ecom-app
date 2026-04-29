import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final bool productExists;
  final bool productOutOfStock;

  const WishlistItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    this.productExists = true,
    this.productOutOfStock = false,
  });

  @override
  List<Object?> get props => [
        productId,
        productName,
        productImage,
        productPrice,
        productExists,
        productOutOfStock,
      ];
}
