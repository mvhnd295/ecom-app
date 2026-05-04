import 'package:fitflow/core/extensions/string_extension.dart';
import 'package:flutter/material.dart';

/// A circular avatar that shows a network image when [avatarUrl] is provided,
/// falling back to the user's uppercase initials when absent or on error.
///
/// [name] is used to derive the initials via [StringExtension.initials].
/// [size] controls the diameter; defaults to 88.
///
/// Example:
/// ```dart
/// UserAvatar(name: user.name, avatarUrl: user.avatarUrl)
/// UserAvatar(name: user.name, size: 40)   // compact variant
/// ```
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 88,
  });

  final String name;
  final String? avatarUrl;

  /// Diameter of the circle in logical pixels. Defaults to `88`.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = name.initials;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primaryColor.withValues(alpha: 0.12),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    _InitialsView(initials: initials, size: size),
              ),
            )
          : _InitialsView(initials: initials, size: size),
    );
  }
}

class _InitialsView extends StatelessWidget {
  const _InitialsView({required this.initials, required this.size});
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.w700,
          // Scales proportionally with avatar size.
          fontSize: size * 0.3,
          fontFamily: theme.textTheme.headlineSmall?.fontFamily,
        ),
      ),
    );
  }
}
