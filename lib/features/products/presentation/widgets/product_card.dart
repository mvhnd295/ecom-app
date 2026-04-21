import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitflow/core/extensions/context_extension.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/features/products/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final ProductEntity product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadius12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: AppSpacing.borderRadius12,
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                placeholder: (_, _) => Shimmer.fromColors(
                  baseColor: AppColors.blackColor5,
                  highlightColor: AppColors.blackColor10,
                  child: const ColoredBox(color: Colors.white),
                ),
                errorWidget: (_, _, _) => Container(
                  color: AppColors.blackColor5,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.blackColor40,
                  ),
                ),
              ),
            ),
          ),
          AppSpacing.gapV8,
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: AppColors.warningColor,
              ),
              const SizedBox(width: 2),
              Text(
                product.rating.toStringAsFixed(1),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 4),
              Text(
                '(${product.reviewCount})',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.blackColor60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
