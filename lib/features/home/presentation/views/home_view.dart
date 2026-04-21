import 'package:fitflow/core/extensions/context_extension.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/categories/presentation/providers/category_list_notifier.dart';
import 'package:fitflow/features/categories/presentation/providers/category_list_state.dart';
import 'package:fitflow/features/categories/presentation/widgets/category_chip.dart';
import 'package:fitflow/features/products/presentation/providers/product_list_notifier.dart';
import 'package:fitflow/features/products/presentation/providers/product_list_state.dart';
import 'package:fitflow/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryListProvider.notifier).load();
      ref.read(productListProvider.notifier).load();
    });
  }

  void _onCategoryTap(String? categoryId) {
    setState(() => _selectedCategoryId = categoryId);
    ref.read(productListProvider.notifier).load(categoryId: categoryId);
  }

  Future<void> _refresh() async {
    await Future.wait([
      ref.read(categoryListProvider.notifier).load(),
      ref.read(productListProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.p16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Find your next favorite',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.blackColor60,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildCategoriesStrip()),
              AppSpacing.gapV16.toSliver(),
              _buildProductsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesStrip() {
    final state = ref.watch(categoryListProvider);
    return SizedBox(
      height: 110,
      child: switch (state) {
        CategoryListLoaded(:final categories) => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.ph16,
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _AllCategoriesChip(
                    isSelected: _selectedCategoryId == null,
                    onTap: () => _onCategoryTap(null),
                  ),
                );
              }
              final category = categories[index - 1];
              return CategoryChip(
                category: category,
                isSelected: _selectedCategoryId == category.id,
                onTap: () => _onCategoryTap(category.id),
              );
            },
          ),
        CategoryListError(:final message) => Center(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildProductsGrid() {
    final state = ref.watch(productListProvider);
    return switch (state) {
      ProductListLoaded(:final products) => products.isEmpty
          ? const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No products found')),
            )
          : SliverPadding(
              padding: AppSpacing.ph16,
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.push(
                        RouteNames.productDetailPath(product.id),
                      ),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
      ProductListError(:final message) => SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: AppSpacing.p16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.errorColor,
                    size: 48,
                  ),
                  AppSpacing.gapV8,
                  Text(message, textAlign: TextAlign.center),
                  AppSpacing.gapV16,
                  OutlinedButton.icon(
                    onPressed: () => ref
                        .read(productListProvider.notifier)
                        .refresh(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      _ => const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
    };
  }
}

class _AllCategoriesChip extends StatelessWidget {
  const _AllCategoriesChip({required this.isSelected, required this.onTap});
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.blackColor5,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.apps_rounded,
                color: isSelected
                    ? AppColors.whiteColor
                    : AppColors.blackColor60,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'All',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryColor
                    : theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on SizedBox {
  Widget toSliver() => SliverToBoxAdapter(child: this);
}
