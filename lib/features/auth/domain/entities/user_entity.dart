import 'package:equatable/equatable.dart';
import 'package:fitflow/features/auth/domain/entities/address.dart';
import 'package:fitflow/features/auth/domain/entities/wishlist.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final Address? address;
  final String? avatarUrl;
  final bool isAdmin;
  final List<WishlistItem> wishlist;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.avatarUrl,
    this.isAdmin = false,
    this.wishlist = const [],
  });
  bool get hasAddress => address != null;
  bool isInWishList(String productId) =>
      wishlist.any((wishlistItem) => wishlistItem.productId == productId);

  @override
  List<Object?> get props => [id, name, email, phone, address, avatarUrl, isAdmin, wishlist];
}
