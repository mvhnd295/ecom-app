import 'package:fitflow/features/products/domain/entities/product_entity.dart';

sealed class SearchState {
  const SearchState();
}

/// No query entered yet — show an idle hint.
class SearchIdle extends SearchState {
  const SearchIdle();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final String query;
  final List<ProductEntity> results;
  const SearchLoaded({required this.query, required this.results});
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
}
