import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

class ButtonThemes {
  ButtonThemes._();

  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: AppSpacing.p16,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadius12,
        ),
      ),
    );
  }

  static TextButtonThemeData get textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: AppSpacing.p16,
        foregroundColor: AppColors.primaryColor,
        minimumSize: const Size(double.infinity, 48),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadius12,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: AppSpacing.p16,
        foregroundColor: AppColors.primaryColor,
        minimumSize: const Size(double.infinity, 48),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadius12,
        ),
        side: const BorderSide(color: AppColors.blackColor10, width: 1.5),
      ),
    );
  }
}
