import 'package:fitflow/features/auth/domain/entities/wishlist.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.productPrice,
    super.productExists,
    super.productOutOfStock,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      productId: json['productId'].toString(),
      productName: json['productName'] as String,
      productImage: json['productImage'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productExists: json['productExists'] as bool? ?? true,
      productOutOfStock: json['productOutOfStock'] as bool? ?? false,
    );
  }
}
