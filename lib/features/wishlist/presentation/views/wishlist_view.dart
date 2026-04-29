import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitflow/core/common/widgets/app_error_view.dart';
import 'package:fitflow/core/common/widgets/inline_warning.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/features/auth/domain/entities/wishlist.dart';
import 'package:fitflow/features/wishlist/presentation/providers/wishlist_notifier.dart';
import 'package:fitflow/features/wishlist/presentation/providers/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistView extends ConsumerStatefulWidget {
  const WishlistView({super.key});

  @override
  ConsumerState<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends ConsumerState<WishlistView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wishlistProvider.notifier).load();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorColor,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wishlistProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: switch (state) {
        WishlistLoaded(:final items) when items.isEmpty =>
          const _EmptyWishlist(),
        WishlistLoaded loaded => _LoadedWishlist(
            state: loaded,
            onError: _showError,
          ),
        WishlistError(:final message) => AppErrorView(
            message: message,
            onRetry: () => ref.read(wishlistProvider.notifier).load(),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _LoadedWishlist extends ConsumerWidget {
  const _LoadedWishlist({required this.state, required this.onError});
  final WishlistLoaded state;
  final void Function(String) onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(wishlistProvider.notifier).load(),
      child: ListView.separated(
        padding: AppSpacing.p16,
        itemCount: state.items.length,
        separatorBuilder: (_, _) => AppSpacing.gapV12,
        itemBuilder: (_, i) {
          final item = state.items[i];
          return _WishlistItemTile(
            item: item,
            busy: state.isMutating(item.productId),
            onRemove: () async {
              final err = await ref
                  .read(wishlistProvider.notifier)
                  .remove(item.productId);
              if (err != null) onError(err);
            },
          );
        },
      ),
    );
  }
}

class _WishlistItemTile extends StatelessWidget {
  const _WishlistItemTile({
    required this.item,
    required this.busy,
    required this.onRemove,
  });

  final WishlistItem item;
  final bool busy;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: busy ? 0.6 : 1,
      child: Container(
        padding: AppSpacing.p12,
        decoration: BoxDecoration(
          color: AppColors.blackColor5,
          borderRadius: AppSpacing.borderRadius12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: AppSpacing.borderRadius8,
              child: SizedBox(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: item.productImage,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const ColoredBox(
                    color: AppColors.blackColor10,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.blackColor40,
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.gapH12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${item.productPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (!item.productExists)
                    const InlineWarning('No longer available'),
                  if (item.productOutOfStock && item.productExists)
                    const InlineWarning('Out of stock'),
                ],
              ),
            ),
            IconButton(
              onPressed: busy ? null : onRemove,
              icon: const Icon(
                Icons.favorite_rounded,
                color: AppColors.wishlistHeartColor,
              ),
              tooltip: 'Remove from wishlist',
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: AppSpacing.p24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_outline_rounded,
              size: 56,
              color: AppColors.blackColor40,
            ),
            AppSpacing.gapV12,
            Text(
              'Your wishlist is empty',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.gapV8,
            const Text(
              'Tap the heart icon on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.blackColor60),
            ),
          ],
        ),
      ),
    );
  }
}

