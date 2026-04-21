import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String colorHex;
  final String image;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.image,
  });

  Color get color {
    final hex = colorHex.replaceFirst('#', '');
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return const Color(0xFF000000);
    return Color(hex.length == 6 ? 0xFF000000 | value : value);
  }

  @override
  List<Object?> get props => [id, name, colorHex, image];
}
