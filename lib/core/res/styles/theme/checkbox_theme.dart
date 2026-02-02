import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

class CheckboxThemes {
  CheckboxThemes._();

  static CheckboxThemeData get checkboxTheme {
    return CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadius12 / 2),
      side: const BorderSide(color: AppColors.whiteColor40)
    );
  }
}
