import 'package:fitflow/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.productPrice,
    required super.quantity,
    super.selectedSize,
    super.selectedColor,
    super.productExists,
    super.productOutOfStock,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final productId = product is Map<String, dynamic>
        ? (product['_id'] ?? product['id']).toString()
        : product?.toString() ?? '';

    // Server overwrites productImage with product.images (an array) before
    // responding, so handle both cases.
    final rawImage = json['productImage'];
    final productImage = rawImage is List
        ? (rawImage.isEmpty ? '' : rawImage.first.toString())
        : (rawImage?.toString() ?? '');

    return CartItemModel(
      id: (json['id'] ?? json['_id']).toString(),
      productId: productId,
      productName: json['productName'] as String? ?? '',
      productImage: productImage,
      productPrice: (json['productPrice'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedSize: json['selectedSize'] as String?,
      selectedColor: json['selectedColor'] as String?,
      productExists: json['productExists'] as bool? ?? true,
      productOutOfStock: json['productOutOfStock'] as bool? ?? false,
    );
  }
}
