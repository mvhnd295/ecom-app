import 'dart:async';

import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/features/products/domain/usecases/search_products_usecase.dart';
import 'package:fitflow/features/search/presentation/providers/search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchNotifier extends Notifier<SearchState> {
  late final SearchProductsUsecase _searchProducts;
  Timer? _debounce;
  int _requestId = 0;

  @override
  SearchState build() {
    _searchProducts = sl<SearchProductsUsecase>();
    ref.onDispose(() => _debounce?.cancel());
    return const SearchIdle();
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const SearchIdle();
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => _run(trimmed),
    );
  }

  void clear() {
    _debounce?.cancel();
    state = const SearchIdle();
  }

  Future<void> _run(String query) async {
    final requestId = ++_requestId;
    state = const SearchLoading();
    final result = await _searchProducts(SearchProductsParams(query: query));
    // Drop the result if a newer request has started.
    if (requestId != _requestId) return;
    result.fold(
      (failure) => state = SearchError(failure.message),
      (products) => state = SearchLoaded(query: query, results: products),
    );
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);
