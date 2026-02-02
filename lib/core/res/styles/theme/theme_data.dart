import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

class ThemeDataConfig {
  ThemeDataConfig._();

  /// AppBar theme for light mode
  static const AppBarTheme appBarLightTheme = AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.blackColor),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.blackColor,
    ),
  );

  /// AppBar theme for dark mode
  static const AppBarTheme appBarDarkTheme = AppBarTheme(
    backgroundColor: AppColors.darkGreyColor,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.whiteColor),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor,
    ),
  );

  /// Scrollbar theme
  static const ScrollbarThemeData scrollbarThemeData = ScrollbarThemeData(
    thumbColor: WidgetStatePropertyAll(AppColors.primaryColor),
    trackColor: WidgetStatePropertyAll(AppColors.lightGreyColor),
    thickness: WidgetStatePropertyAll(8),
    radius: Radius.circular(4),
  );

  /// DataTable theme for light mode
  static const DataTableThemeData dataTableLightThemeData = DataTableThemeData(
    headingRowColor: WidgetStatePropertyAll(AppColors.blackColor5),
    headingRowHeight: 56,
    dataRowMaxHeight: 52,
    dividerThickness: 1,
  );

  /// DataTable theme for dark mode
  static const DataTableThemeData dataTableDarkThemeData = DataTableThemeData(
    headingRowColor: WidgetStatePropertyAll(AppColors.darkGreyColor),
    headingRowHeight: 56,
    dataRowMaxHeight: 52,
    dividerThickness: 1,
  );
}
