import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitflow/core/extensions/context_extension.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/features/cart/presentation/providers/cart_notifier.dart';
import 'package:fitflow/features/products/domain/entities/product_entity.dart';
import 'package:fitflow/features/products/presentation/providers/product_detail_notifier.dart';
import 'package:fitflow/features/products/presentation/providers/product_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  const ProductDetailView({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDetailProvider.notifier).load(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailProvider);
    return switch (state) {
      ProductDetailLoaded(:final product) => _Loaded(product: product),
      ProductDetailError(:final message) => Scaffold(
          body: _ErrorView(
            message: message,
            onRetry: () => ref
                .read(productDetailProvider.notifier)
                .load(widget.productId),
          ),
        ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Loaded extends ConsumerStatefulWidget {
  const _Loaded({required this.product});
  final ProductEntity product;

  @override
  ConsumerState<_Loaded> createState() => _LoadedState();
}

class _LoadedState extends ConsumerState<_Loaded> {
  int _imageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  bool _adding = false;

  List<String> get _gallery {
    final product = widget.product;
    return [
      product.image,
      ...product.images.where((url) => url != product.image),
    ];
  }

  Future<void> _addToCart() async {
    final product = widget.product;
    if (product.sizes.isNotEmpty && _selectedSize == null) {
      _showSnack('Please select a size');
      return;
    }
    if (product.colors.isNotEmpty && _selectedColor == null) {
      _showSnack('Please select a color');
      return;
    }

    setState(() => _adding = true);
    final error = await ref.read(cartProvider.notifier).addToCart(
          productId: product.id,
          selectedSize: _selectedSize,
          selectedColor: _selectedColor,
        );
    if (!mounted) return;
    setState(() => _adding = false);
    _showSnack(error ?? 'Added to cart', isError: error != null);
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.errorColor : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final product = widget.product;
    final gallery = _gallery;

    return Scaffold(
      body: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 360,
          leading: _CircleIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          actions: [
            _CircleIconButton(
              icon: Icons.favorite_outline_rounded,
              onTap: () {},
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: gallery[_imageIndex],
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Container(
                      color: AppColors.blackColor5,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 48,
                        color: AppColors.blackColor40,
                      ),
                    ),
                  ),
                ),
                if (gallery.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(gallery.length, (i) {
                        final selected = i == _imageIndex;
                        return GestureDetector(
                          onTap: () => setState(() => _imageIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: selected ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primaryColor
                                  : AppColors.whiteColor.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.p16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.gapV8,
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: AppColors.warningColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating.toStringAsFixed(1)} '
                      '(${product.reviewCount})',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    _StockBadge(inStock: product.isInStock),
                  ],
                ),
                AppSpacing.gapV16,
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
                if (product.colors.isNotEmpty) ...[
                  AppSpacing.gapV20,
                  const _SectionTitle('Colors'),
                  AppSpacing.gapV8,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.colors
                        .map((c) => _ChoiceChip(
                              label: c,
                              selected: _selectedColor == c,
                              onTap: () =>
                                  setState(() => _selectedColor = c),
                            ))
                        .toList(),
                  ),
                ],
                if (product.sizes.isNotEmpty) ...[
                  AppSpacing.gapV20,
                  const _SectionTitle('Sizes'),
                  AppSpacing.gapV8,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes
                        .map((s) => _ChoiceChip(
                              label: s,
                              selected: _selectedSize == s,
                              onTap: () =>
                                  setState(() => _selectedSize = s),
                            ))
                        .toList(),
                  ),
                ],
                AppSpacing.gapV20,
                const _SectionTitle('Description'),
                AppSpacing.gapV8,
                Text(
                  product.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.blackColor60,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
        ],
      ),
      bottomNavigationBar: _AddToCartBar(
        price: product.price,
        enabled: product.isInStock && !_adding,
        loading: _adding,
        onPressed: _addToCart,
      ),
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.price,
    required this.enabled,
    required this.loading,
    required this.onPressed,
  });

  final double price;
  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.blackColor60,
                  ),
                ),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            AppSpacing.gapH16,
            Expanded(
              child: ElevatedButton.icon(
                onPressed: enabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : const Icon(Icons.shopping_bag_outlined),
                label: Text(loading ? 'Adding...' : 'Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : AppColors.blackColor5,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.whiteColor : AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.inStock});
  final bool inStock;

  @override
  Widget build(BuildContext context) {
    final color = inStock ? AppColors.successColor : AppColors.errorColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        inStock ? 'In stock' : 'Out of stock',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: AppColors.whiteColor.withValues(alpha: 0.9),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: AppColors.blackColor),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.p24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: AppColors.errorColor,
            ),
            AppSpacing.gapV12,
            Text(message, textAlign: TextAlign.center),
            AppSpacing.gapV16,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
