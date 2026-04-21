import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/core/services/storage/cache_helper.dart';
import 'package:fitflow/features/cart/domain/repositories/cart_repository.dart';
import 'package:fitflow/features/cart/domain/usecases/cart_usecases.dart';
import 'package:fitflow/features/cart/presentation/providers/cart_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends Notifier<CartState> {
  late final GetCartUsecase _getCart;
  late final AddToCartUsecase _addToCart;
  late final RemoveCartItemUsecase _removeItem;
  late final ClearCartUsecase _clearCart;
  late final UpdateCartQuantityUsecase _updateQty;
  late final SetCartQuantityUsecase _setQty;
  late final UpdateCartItemUsecase _updateItem;
  late final CacheHelper _cache;

  @override
  CartState build() {
    _getCart = sl<GetCartUsecase>();
    _addToCart = sl<AddToCartUsecase>();
    _removeItem = sl<RemoveCartItemUsecase>();
    _clearCart = sl<ClearCartUsecase>();
    _updateQty = sl<UpdateCartQuantityUsecase>();
    _setQty = sl<SetCartQuantityUsecase>();
    _updateItem = sl<UpdateCartItemUsecase>();
    _cache = sl<CacheHelper>();
    return const CartInitial();
  }

  String? get _userId => _cache.userId;
  static const _notLoggedIn = 'You need to be logged in.';

  Future<void> load() async {
    final userId = _userId;
    if (userId == null) {
      state = const CartError(_notLoggedIn);
      return;
    }
    state = const CartLoading();
    final result = await _getCart(userId);
    result.fold(
      (failure) => state = CartError(failure.message),
      (items) => state = CartLoaded(items),
    );
  }

  /// Returns a failure message, or null on success.
  Future<String?> addToCart({
    required String productId,
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) async {
    final userId = _userId;
    if (userId == null) return _notLoggedIn;
    final result = await _addToCart(AddToCartParams(
      userId: userId,
      productId: productId,
      quantity: quantity,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
    ));
    return result.fold((failure) => failure.message, (_) {
      load();
      return null;
    });
  }

  Future<String?> updateQuantity(
    String cartItemId,
    CartQuantityAction action,
  ) async {
    final userId = _userId;
    if (userId == null) return _notLoggedIn;
    if (!_beginMutation(cartItemId)) return null;
    try {
      final result = await _updateQty(UpdateCartQuantityParams(
        userId: userId,
        cartItemId: cartItemId,
        action: action,
      ));
      return result.fold((failure) => failure.message, (updated) {
        final current = state;
        if (current is CartLoaded) {
          final items = [
            for (final item in current.items)
              if (item.id == cartItemId) updated else item,
          ];
          state = current.copyWith(items: items);
        }
        return null;
      });
    } finally {
      _endMutation(cartItemId);
    }
  }

  /// Sets the quantity on a line item directly (as opposed to incrementing
  /// or decrementing one at a time). A quantity of 0 is treated as a removal.
  Future<String?> setQuantity(String cartItemId, int quantity) async {
    if (quantity < 0) return null;
    if (quantity == 0) return removeItem(cartItemId);
    final userId = _userId;
    if (userId == null) return _notLoggedIn;
    if (!_beginMutation(cartItemId)) return null;
    try {
      final result = await _setQty(SetCartQuantityParams(
        userId: userId,
        cartItemId: cartItemId,
        quantity: quantity,
      ));
      return result.fold((failure) => failure.message, (updated) {
        final current = state;
        if (current is CartLoaded) {
          final items = [
            for (final item in current.items)
              if (item.id == cartItemId) updated else item,
          ];
          state = current.copyWith(items: items);
        }
        return null;
      });
    } finally {
      _endMutation(cartItemId);
    }
  }

  /// Updates the selected size/color on an existing line item. At least one
  /// of [selectedSize] / [selectedColor] must be provided.
  Future<String?> updateVariant(
    String cartItemId, {
    String? selectedSize,
    String? selectedColor,
  }) async {
    if (selectedSize == null && selectedColor == null) return null;
    final userId = _userId;
    if (userId == null) return _notLoggedIn;
    if (!_beginMutation(cartItemId)) return null;
    try {
      final result = await _updateItem(UpdateCartItemParams(
        userId: userId,
        cartItemId: cartItemId,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ));
      return result.fold((failure) => failure.message, (updated) {
        final current = state;
        if (current is CartLoaded) {
          final items = [
            for (final item in current.items)
              if (item.id == cartItemId) updated else item,
          ];
          state = current.copyWith(items: items);
        }
        return null;
      });
    } finally {
      _endMutation(cartItemId);
    }
  }

  Future<String?> removeItem(String cartItemId) async {
    final userId = _userId;
    if (userId == null) return _notLoggedIn;
    if (!_beginMutation(cartItemId)) return null;
    try {
      final result = await _removeItem(
        RemoveCartItemParams(userId: userId, cartItemId: cartItemId),
      );
      return result.fold((failure) => failure.message, (_) {
        final current = state;
        if (current is CartLoaded) {
          final items =
              current.items.where((i) => i.id != cartItemId).toList();
          state = current.copyWith(items: items);
        }
        return null;
      });
    } finally {
      _endMutation(cartItemId);
    }
  }

  Future<String?> clear() async {
    final userId = _userId;
    if (userId == null) return _notLoggedIn;
    final result = await _clearCart(userId);
    return result.fold((failure) => failure.message, (_) {
      state = const CartLoaded([]);
      return null;
    });
  }

  /// Returns false if the item is already being mutated (taps debounced).
  bool _beginMutation(String cartItemId) {
    final current = state;
    if (current is! CartLoaded) return false;
    if (current.mutatingIds.contains(cartItemId)) return false;
    state = current.copyWith(
      mutatingIds: {...current.mutatingIds, cartItemId},
    );
    return true;
  }

  void _endMutation(String cartItemId) {
    final current = state;
    if (current is! CartLoaded) return;
    state = current.copyWith(
      mutatingIds: {...current.mutatingIds}..remove(cartItemId),
    );
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);
