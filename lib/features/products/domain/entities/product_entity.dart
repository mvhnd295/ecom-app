import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String image;
  final List<String> images;
  final String categoryId;
  final List<String> colors;
  final List<String> sizes;
  final String? genderAgeCategory;
  final int countInStock;
  final DateTime? dateAdded;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.image,
    this.images = const [],
    required this.categoryId,
    this.colors = const [],
    this.sizes = const [],
    this.genderAgeCategory,
    required this.countInStock,
    this.dateAdded,
  });

  bool get isInStock => countInStock > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        rating,
        reviewCount,
        image,
        images,
        categoryId,
        colors,
        sizes,
        genderAgeCategory,
        countInStock,
        dateAdded,
      ];
}
