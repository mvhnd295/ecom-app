import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

/// A small uppercase label used to introduce a group of related items.
///
/// Renders the [label] in all-caps with wide letter-spacing, matching the
/// conventional settings/profile screen section style.
///
/// Typical usage — placed above an [AppSettingsCard]:
/// ```dart
/// AppSectionHeader(label: 'Account'),
/// AppSpacing.gapV8,
/// AppSettingsCard(children: [...]),
/// ```
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.label,
    this.padding = const EdgeInsets.only(left: 4),
  });

  final String label;

  /// Padding applied around the label. Defaults to a small left inset
  /// so the text lines up with card content.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColors.blackColor40,
            ),
      ),
    );
  }
}
