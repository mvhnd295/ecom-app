import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

/// A single tappable row inside an [AppSettingsCard].
///
/// Layout: `[icon]  [label]  [trailing / chevron]`
///
/// Parameters:
/// - [icon] — leading icon (20 px).
/// - [label] — primary text.
/// - [onTap] — tap callback; `null` disables interaction.
/// - [iconColor] — overrides the default body-text icon colour.
/// - [labelColor] — overrides the default body-text label colour.
/// - [trailing] — custom widget on the right (replaces the chevron).
/// - [showChevron] — when `true` (default) and [trailing] is `null`, a
///   chevron arrow is rendered on the right.
///
/// Example — destructive action:
/// ```dart
/// AppSettingsTile(
///   icon: Icons.logout_rounded,
///   label: 'Logout',
///   iconColor: AppColors.errorColor,
///   labelColor: AppColors.errorColor,
///   showChevron: false,
///   onTap: () => ...,
/// )
/// ```
class AppSettingsTile extends StatelessWidget {
  const AppSettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.trailing,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;
  final Widget? trailing;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.textTheme.bodyLarge?.color;
    final effectiveLabelColor = labelColor ?? theme.textTheme.bodyLarge?.color;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadius12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: effectiveIconColor),
            AppSpacing.gapH12,
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: effectiveLabelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (showChevron && trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.blackColor40,
              ),
          ],
        ),
      ),
    );
  }
}
