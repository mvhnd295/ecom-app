import 'package:fitflow/features/auth/domain/entities/wishlist.dart';

sealed class WishlistState {
  const WishlistState();
}

class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;
  final Set<String> mutatingIds;

  const WishlistLoaded(this.items, {this.mutatingIds = const {}});

  bool isInWishlist(String productId) =>
      items.any((item) => item.productId == productId);

  bool isMutating(String productId) => mutatingIds.contains(productId);

  WishlistLoaded copyWith({
    List<WishlistItem>? items,
    Set<String>? mutatingIds,
  }) =>
      WishlistLoaded(
        items ?? this.items,
        mutatingIds: mutatingIds ?? this.mutatingIds,
      );
}

class WishlistError extends WishlistState {
  final String message;
  const WishlistError(this.message);
}
