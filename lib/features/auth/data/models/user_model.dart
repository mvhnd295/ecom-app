import 'package:fitflow/features/auth/domain/entities/address.dart';
import 'package:fitflow/features/auth/domain/entities/user_entity.dart';
import 'package:fitflow/features/auth/domain/entities/wishlist.dart';

class UserModel extends UserEntity {
  final String? passwordHash;
  final int? resetPasswordOTP;
  final DateTime? resetPasswordOTPExpiry;

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.address,
    super.avatarUrl,
    super.isAdmin,
    super.wishlist,
    this.passwordHash,
    this.resetPasswordOTP,
    this.resetPasswordOTPExpiry,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Address? address;
    if (json['country'] != null ||
        json['city'] != null ||
        json['street'] != null) {
      address = Address(
        country: json['address']['country'],
        city: json['address']['city'],
        street: json['address']['street'],
        postalCode: json['address']['postalCode'],
        houseNumber: json['address']['houseNumber'],
        apartmentNumber: json['address']['apartmentNumber'],
      );
    }
    List<WishlistItem> wishlist = [];
    if (json['wishlist'] != null) {
      wishlist = List<WishlistItem>.from(
        json['wishlist'].map(
          (item) => WishlistItem(
            productId: item['productId'].toString(),
            productName: item['productName'],
            productImage: item['productImage'],
            productPrice: item['productPrice'].toDouble(),
          ),
        ),
      );
    }
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: address,
      avatarUrl: json['avatarUrl'],
      isAdmin: json['isAdmin'] ?? false,
      wishlist: wishlist,
      passwordHash: json['passwordHash'],
      resetPasswordOTP: json['resetPasswordOTP'],
      resetPasswordOTPExpiry: json['resetPasswordOTPExpiry'] != null
          ? DateTime.parse(json['resetPasswordOTPExpiry'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'isAdmin': isAdmin,
    };

    if (address != null) {
      data.addAll({
        'country': address!.country,
        'city': address!.city,
        'street': address!.street,
        'postalCode': address!.postalCode,
        'houseNumber': address!.houseNumber,
        'apartmentNumber': address!.apartmentNumber,
      });
    }

    data['wishlist'] = wishlist.map((item) => item.productId).toList();

    return data;
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      avatarUrl: entity.avatarUrl,
      isAdmin: entity.isAdmin,
      wishlist: entity.wishlist,
    );
  }
}
