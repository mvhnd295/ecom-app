import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/core/services/storage/cache_helper.dart';
import 'package:fitflow/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:fitflow/features/wishlist/presentation/providers/wishlist_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistNotifier extends Notifier<WishlistState> {
  late final GetWishlistUsecase _getWishlist;
  late final AddToWishlistUsecase _addToWishlist;
  late final RemoveFromWishlistUsecase _removeFromWishlist;
  late final CacheHelper _cache;

  @override
  WishlistState build() {
    _getWishlist = sl<GetWishlistUsecase>();
    _addToWishlist = sl<AddToWishlistUsecase>();
    _removeFromWishlist = sl<RemoveFromWishlistUsecase>();
    _cache = sl<CacheHelper>();
    return const WishlistInitial();
  }

  String? get _userId => _cache.userId;
  static const _notLoggedIn = 'You need to be logged in.';

  Future<void> load() async {
    final userId = _userId;
    if (userId == null) {
      state = const WishlistError(_notLoggedIn);
      return;
    }
    state = const WishlistLoading();
    final result = await _getWishlist(userId);
    result.fold(
      (failure) => state = WishlistError(failure.message),
      (items) => state = WishlistLoaded(items),
    );
  }

  /// Returns a failure message, or null on success.
  Future<String?> add(String productId) async {
    final userId = _userId;
    if (userId == null) return _notLoggedIn;
    if (!_beginMutation(productId)) return null;
    try {
      final result = await _addToWishlist(
        AddToWishlistParams(userId: userId, productId: productId),
      );
      return result.fold(
        (failure) => failure.message,
        (_) {
          load();
          return null;
        },
      );
    } finally {
      _endMutation(productId);
    }
  }

  /// Returns a failure message, or null on success.
  Future<String?> remove(String productId) async {
    final userId = _userId;
    if (userId == null) return _notLoggedIn;
    if (!_beginMutation(productId)) return null;
    try {
      final result = await _removeFromWishlist(
        RemoveFromWishlistParams(userId: userId, productId: productId),
      );
      return result.fold(
        (failure) => failure.message,
        (_) {
          final current = state;
          if (current is WishlistLoaded) {
            state = current.copyWith(
              items: current.items
                  .where((i) => i.productId != productId)
                  .toList(),
            );
          }
          return null;
        },
      );
    } finally {
      _endMutation(productId);
    }
  }

  /// Toggles wishlist membership. Returns a failure message, or null on success.
  Future<String?> toggle(String productId) async {
    final current = state;
    if (current is WishlistLoaded && current.isInWishlist(productId)) {
      return remove(productId);
    }
    return add(productId);
  }

  bool _beginMutation(String productId) {
    final current = state;
    if (current is! WishlistLoaded) return false;
    if (current.mutatingIds.contains(productId)) return false;
    state = current.copyWith(
      mutatingIds: {...current.mutatingIds, productId},
    );
    return true;
  }

  void _endMutation(String productId) {
    final current = state;
    if (current is! WishlistLoaded) return;
    state = current.copyWith(
      mutatingIds: {...current.mutatingIds}..remove(productId),
    );
  }
}

final wishlistProvider = NotifierProvider<WishlistNotifier, WishlistState>(
  WishlistNotifier.new,
);
