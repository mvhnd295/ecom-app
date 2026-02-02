import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

class InputDecorationThemes {
  InputDecorationThemes._();

  static InputDecorationTheme get lightInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightGreyColor,
      hintStyle: const TextStyle(color: AppColors.greyColor),
      border: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      focusedBorder: focusedOutlineInputBorder,
      errorBorder: errorOutlineInputBorder,
    );
  }

  static InputDecorationTheme get darkInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkGreyColor,
      hintStyle: const TextStyle(color: AppColors.whiteColor40),
      border: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      focusedBorder: focusedOutlineInputBorder,
      errorBorder: errorOutlineInputBorder,
    );
  }

  static OutlineInputBorder get outlineInputBorder {
    return OutlineInputBorder(
      borderRadius: AppSpacing.borderRadius12,
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }

  static OutlineInputBorder get focusedOutlineInputBorder {
    return OutlineInputBorder(
      borderRadius: AppSpacing.borderRadius12,
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
    );
  }

  static OutlineInputBorder get errorOutlineInputBorder {
    return OutlineInputBorder(
      borderRadius: AppSpacing.borderRadius12,
      borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
    );
  }
}
