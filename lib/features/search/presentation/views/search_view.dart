import 'package:fitflow/core/extensions/context_extension.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/products/presentation/widgets/product_card.dart';
import 'package:fitflow/features/search/presentation/providers/search_notifier.dart';
import 'package:fitflow/features/search/presentation/providers/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    // Rebuild to toggle the clear-button visibility.
    setState(() {});
  }

  void _onClear() {
    _controller.clear();
    ref.read(searchProvider.notifier).clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final theme = context.theme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.p16,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: ref.read(searchProvider.notifier).onQueryChanged,
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: _onClear,
                        ),
                  filled: true,
                  fillColor: AppColors.blackColor5,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(child: _buildBody(state, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(SearchState state, ThemeData theme) {
    return switch (state) {
      SearchIdle() => _CenteredHint(
          icon: Icons.search_rounded,
          title: 'Find anything',
          subtitle: 'Search by name or description',
        ),
      SearchLoading() => const Center(child: CircularProgressIndicator()),
      SearchLoaded(:final results, :final query) => results.isEmpty
          ? _CenteredHint(
              icon: Icons.sentiment_dissatisfied_rounded,
              title: 'No matches',
              subtitle: 'Nothing found for "$query"',
            )
          : GridView.builder(
              padding: AppSpacing.p16,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final product = results[i];
                return ProductCard(
                  product: product,
                  onTap: () => context.push(
                    RouteNames.productDetailPath(product.id),
                  ),
                );
              },
            ),
      SearchError(:final message) => _CenteredHint(
          icon: Icons.error_outline_rounded,
          title: 'Something went wrong',
          subtitle: message,
          color: AppColors.errorColor,
        ),
    };
  }
}

class _CenteredHint extends StatelessWidget {
  const _CenteredHint({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tone = color ?? AppColors.blackColor40;
    return Center(
      child: Padding(
        padding: AppSpacing.p24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: tone),
            AppSpacing.gapV12,
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.gapV8,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.blackColor60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
