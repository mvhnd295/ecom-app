import 'package:fitflow/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.rating,
    required super.reviewCount,
    required super.image,
    super.images,
    required super.categoryId,
    super.colors,
    super.sizes,
    super.genderAgeCategory,
    required super.countInStock,
    super.dateAdded,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final categoryId = category is Map<String, dynamic>
        ? (category['_id'] ?? category['id']).toString()
        : category?.toString() ?? '';

    return ProductModel(
      id: (json['id'] ?? json['_id']).toString(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      image: json['image'] as String? ?? '',
      images: (json['images'] as List?)?.cast<String>() ?? const [],
      categoryId: categoryId,
      colors: (json['colors'] as List?)?.cast<String>() ?? const [],
      sizes: (json['sizes'] as List?)?.cast<String>() ?? const [],
      genderAgeCategory: json['genderAgeCategory'] as String?,
      countInStock: (json['countInStock'] as num?)?.toInt() ?? 0,
      dateAdded: json['dateAdded'] != null
          ? DateTime.tryParse(json['dateAdded'].toString())
          : null,
    );
  }
}
