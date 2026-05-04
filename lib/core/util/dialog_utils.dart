import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

/// Utility class for displaying common application dialogs.
abstract class DialogUtils {
  DialogUtils._();

  /// Shows a confirmation dialog, typically for irreversible or destructive
  /// actions (delete, logout, clear, etc.).
  ///
  /// Returns `true` when the user taps [confirmLabel], `false` on cancel,
  /// and `null` if the dialog is dismissed without interaction.
  ///
  /// [onConfirm] is an optional callback called immediately before the dialog
  /// closes on confirmation — useful when you don't need the return value.
  ///
  /// Example:
  /// ```dart
  /// DialogUtils.confirmAction(
  ///   context,
  ///   title: 'Delete Account',
  ///   content: 'This cannot be undone. Are you sure?',
  ///   confirmLabel: 'Delete',
  ///   onConfirm: () => ref.read(authProvider.notifier).deleteAccount(),
  /// );
  /// ```
  static Future<bool?> confirmAction(
    BuildContext context, {
    required String title,
    required String content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    Color confirmColor = AppColors.errorColor,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
              onConfirm?.call();
            },
            style: TextButton.styleFrom(foregroundColor: confirmColor),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}
