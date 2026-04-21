import 'package:fitflow/features/categories/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.colorHex,
    required super.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] ?? json['_id']).toString(),
      name: json['name'] as String? ?? '',
      colorHex: json['color'] as String? ?? '#000000',
      image: json['image'] as String? ?? '',
    );
  }
}
