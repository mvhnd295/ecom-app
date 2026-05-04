import 'package:fitflow/core/res/spacing.dart';
import 'package:flutter/material.dart';

/// A rounded, bordered card container for grouping settings or menu items.
///
/// Wrap a list of [AppSettingsTile]s (separated by [AppSettingsDivider]s)
/// inside this widget:
/// ```dart
/// AppSettingsCard(
///   children: [
///     AppSettingsTile(icon: Icons.person_outline_rounded, label: 'Profile', onTap: ...),
///     AppSettingsDivider(),
///     AppSettingsTile(icon: Icons.lock_outline_rounded, label: 'Security', onTap: ...),
///   ],
/// )
/// ```
class AppSettingsCard extends StatelessWidget {
  const AppSettingsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppSpacing.borderRadius12,
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// A thin horizontal divider meant to separate rows inside an [AppSettingsCard].
///
/// [indent] defaults to `48` — aligning with the text that follows the leading
/// icon in an [AppSettingsTile] (16 px padding + 20 px icon + 12 px gap).
class AppSettingsDivider extends StatelessWidget {
  const AppSettingsDivider({super.key, this.indent = 48});

  /// Left indent in logical pixels. Defaults to `48`.
  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      color: Theme.of(context).dividerColor,
    );
  }
}
