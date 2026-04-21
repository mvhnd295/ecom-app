import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/core/services/storage/cache_helper.dart';
import 'package:fitflow/features/cart/domain/usecases/cart_usecases.dart';
import 'package:fitflow/features/cart/presentation/providers/cart_notifier.dart';
import 'package:fitflow/features/cart/presentation/providers/cart_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartCountNotifier extends Notifier<int> {
  late final GetCartCountUsecase _getCount;
  late final CacheHelper _cache;

  @override
  int build() {
    _getCount = sl<GetCartCountUsecase>();
    _cache = sl<CacheHelper>();

    // Whenever the full cart is loaded or mutated in-place, mirror its count
    // so the badge and the cart view can never disagree.
    ref.listen<CartState>(cartProvider, (_, next) {
      if (next is CartLoaded) state = next.itemCount;
    });

    Future.microtask(refresh);
    return 0;
  }

  Future<void> refresh() async {
    final userId = _cache.userId;
    if (userId == null) {
      state = 0;
      return;
    }
    final result = await _getCount(userId);
    result.fold((_) {}, (count) => state = count < 0 ? 0 : count);
  }
}

final cartCountProvider = NotifierProvider<CartCountNotifier, int>(
  CartCountNotifier.new,
);
