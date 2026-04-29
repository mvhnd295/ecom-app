import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitflow/core/common/widgets/app_error_view.dart';
import 'package:fitflow/core/common/widgets/inline_warning.dart';
import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/features/cart/domain/entities/cart_item_entity.dart';
import 'package:fitflow/features/cart/domain/repositories/cart_repository.dart';
import 'package:fitflow/features/cart/presentation/providers/cart_notifier.dart';
import 'package:fitflow/features/cart/presentation/providers/cart_state.dart';
import 'package:fitflow/features/products/domain/entities/product_entity.dart';
import 'package:fitflow/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({super.key});

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).load();
    });
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('This removes every item from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final error = await ref.read(cartProvider.notifier).clear();
    if (error != null && mounted) _showError(error);
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
    final state = ref.watch(cartProvider);
    final hasItems = state is CartLoaded && !state.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (hasItems)
            TextButton(
              onPressed: _confirmClear,
              child: const Text('Clear'),
            ),
        ],
      ),
      body: switch (state) {
        CartLoaded(:final items) when items.isEmpty => const _EmptyCart(),
        CartLoaded() => _LoadedCart(state: state, onError: _showError),
        CartError(:final message) => AppErrorView(
            message: message,
            onRetry: () => ref.read(cartProvider.notifier).load(),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: hasItems
          ? _CheckoutBar(
              subtotal: state.subtotal,
              onCheckout: () {
                // TODO: wire checkout flow
              },
            )
          : null,
    );
  }
}

class _LoadedCart extends ConsumerWidget {
  const _LoadedCart({required this.state, required this.onError});
  final CartLoaded state;
  final void Function(String message) onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(cartProvider.notifier).load(),
      child: ListView.separated(
        padding: AppSpacing.p16,
        itemCount: state.items.length,
        separatorBuilder: (_, _) => AppSpacing.gapV12,
        itemBuilder: (_, i) {
          final item = state.items[i];
          return _CartItemTile(
            item: item,
            busy: state.mutatingIds.contains(item.id),
            onIncrement: () async {
              final err = await ref
                  .read(cartProvider.notifier)
                  .updateQuantity(item.id, CartQuantityAction.increment);
              if (err != null) onError(err);
            },
            onDecrement: () async {
              final err = await ref
                  .read(cartProvider.notifier)
                  .updateQuantity(item.id, CartQuantityAction.decrement);
              if (err != null) onError(err);
            },
            onSetQuantity: (qty) async {
              final err = await ref
                  .read(cartProvider.notifier)
                  .setQuantity(item.id, qty);
              if (err != null) onError(err);
            },
            onEditVariant: () async {
              final picked = await showModalBottomSheet<_VariantSelection>(
                context: context,
                isScrollControlled: true,
                builder: (_) => _VariantEditSheet(item: item),
              );
              if (picked == null) return;
              final err = await ref
                  .read(cartProvider.notifier)
                  .updateVariant(
                    item.id,
                    selectedSize: picked.size,
                    selectedColor: picked.color,
                  );
              if (err != null) onError(err);
            },
            onRemove: () async {
              final err = await ref
                  .read(cartProvider.notifier)
                  .removeItem(item.id);
              if (err != null) onError(err);
            },
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.busy,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSetQuantity,
    required this.onEditVariant,
    required this.onRemove,
  });

  final CartItemEntity item;
  final bool busy;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onSetQuantity;
  final VoidCallback onEditVariant;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = busy;
    return Opacity(
      opacity: disabled ? 0.6 : 1,
      child: Container(
        padding: AppSpacing.p12,
        decoration: BoxDecoration(
          color: AppColors.blackColor5,
          borderRadius: AppSpacing.borderRadius12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppSpacing.borderRadius8,
              child: SizedBox(
                width: 72,
                height: 72,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.selectedSize != null || item.selectedColor != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        [
                          if (item.selectedSize != null) 'Size: ${item.selectedSize}',
                          if (item.selectedColor != null) 'Color: ${item.selectedColor}',
                        ].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.blackColor60,
                        ),
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
                    const InlineWarning('Product no longer available'),
                  if (item.productOutOfStock)
                    const InlineWarning('Out of stock'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.productExists &&
                        (item.selectedSize != null ||
                            item.selectedColor != null))
                      IconButton(
                        onPressed: disabled ? null : onEditVariant,
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.primaryColor,
                        ),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Edit size / color',
                      ),
                    IconButton(
                      onPressed: disabled ? null : onRemove,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.errorColor,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                _QtyStepper(
                  quantity: item.quantity,
                  busy: busy,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                  onSetQuantity: onSetQuantity,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.quantity,
    required this.busy,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSetQuantity,
  });

  final int quantity;
  final bool busy;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onSetQuantity;

  Future<void> _openQuantityPicker(BuildContext context) async {
    final picked = await showDialog<int>(
      context: context,
      builder: (_) => _QuantityPickerDialog(initial: quantity),
    );
    if (picked != null && picked != quantity) onSetQuantity(picked);
  }

  @override
  Widget build(BuildContext context) {
    final canDecrement = !busy && quantity > 1;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            onTap: canDecrement ? onDecrement : null,
          ),
          InkWell(
            onTap: busy ? null : () => _openQuantityPicker(context),
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 28,
              height: 28,
              child: Center(
                child: Text(
                  '$quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            onTap: busy ? null : onIncrement,
          ),
        ],
      ),
    );
  }
}

class _QuantityPickerDialog extends StatefulWidget {
  const _QuantityPickerDialog({required this.initial});
  final int initial;

  @override
  State<_QuantityPickerDialog> createState() => _QuantityPickerDialogState();
}

class _QuantityPickerDialogState extends State<_QuantityPickerDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial.toString());
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _controller.text.trim();
    final parsed = int.tryParse(raw);
    if (parsed == null || parsed < 0) {
      setState(() => _error = 'Enter a whole number (0 or more).');
      return;
    }
    Navigator.pop(context, parsed);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set quantity'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: 'Quantity',
          helperText: '0 will remove the item',
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.blackColor : AppColors.blackColor40,
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.subtotal,
    required this.onCheckout,
  });
  final double subtotal;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(color: AppColors.blackColor60),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.whiteColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

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
              Icons.shopping_bag_outlined,
              size: 56,
              color: AppColors.blackColor40,
            ),
            AppSpacing.gapV12,
            Text(
              'Your cart is empty',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.gapV8,
            const Text(
              'Browse products and add some favorites.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.blackColor60),
            ),
          ],
        ),
      ),
    );
  }
}

class _VariantSelection {
  const _VariantSelection({this.size, this.color});
  final String? size;
  final String? color;
}

class _VariantEditSheet extends StatefulWidget {
  const _VariantEditSheet({required this.item});
  final CartItemEntity item;

  @override
  State<_VariantEditSheet> createState() => _VariantEditSheetState();
}

class _VariantEditSheetState extends State<_VariantEditSheet> {
  final _getProduct = sl<GetProductByIdUsecase>();
  ProductEntity? _product;
  String? _errorMessage;
  bool _loading = true;
  String? _size;
  String? _color;

  @override
  void initState() {
    super.initState();
    _size = widget.item.selectedSize;
    _color = widget.item.selectedColor;
    _fetch();
  }

  Future<void> _fetch() async {
    final result = await _getProduct(widget.item.productId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _errorMessage = failure.message;
      }),
      (product) => setState(() {
        _loading = false;
        _product = product;
      }),
    );
  }

  bool get _changed =>
      _size != widget.item.selectedSize || _color != widget.item.selectedColor;

  void _apply() {
    if (!_changed) {
      Navigator.pop(context);
      return;
    }
    Navigator.pop(
      context,
      _VariantSelection(size: _size, color: _color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Edit options',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            AppSpacing.gapV8,
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.errorColor),
                ),
              )
            else ...[
              if (_product!.sizes.isEmpty && _product!.colors.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('This product has no size or color options.'),
                )
              else ...[
                if (_product!.sizes.isNotEmpty) ...[
                  Text(
                    'Size',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.gapV8,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in _product!.sizes)
                        ChoiceChip(
                          label: Text(s),
                          selected: _size == s,
                          onSelected: (selected) =>
                              setState(() => _size = selected ? s : null),
                        ),
                    ],
                  ),
                  AppSpacing.gapV16,
                ],
                if (_product!.colors.isNotEmpty) ...[
                  Text(
                    'Color',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.gapV8,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in _product!.colors)
                        ChoiceChip(
                          label: Text(c),
                          selected: _color == c,
                          onSelected: (selected) =>
                              setState(() => _color = selected ? c : null),
                        ),
                    ],
                  ),
                ],
              ],
              AppSpacing.gapV16,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _changed ? _apply : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
