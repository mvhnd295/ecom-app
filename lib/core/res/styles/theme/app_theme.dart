import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/core/res/styles/theme/button_theme.dart';
import 'package:fitflow/core/res/styles/theme/checkbox_theme.dart';
import 'package:fitflow/core/res/styles/theme/input_decoration_theme.dart';
import 'package:fitflow/core/res/styles/theme/theme_data.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Plus Jakarta',
      primarySwatch: AppColors.primaryMaterialColor,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: AppColors.blackColor),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.blackColor),
        bodyMedium: TextStyle(color: AppColors.blackColor40),
        bodySmall: TextStyle(color: AppColors.blackColor),
      ),
      elevatedButtonTheme: ButtonThemes.elevatedButtonTheme,
      textButtonTheme: ButtonThemes.textButtonTheme,
      outlinedButtonTheme: ButtonThemes.outlinedButtonTheme,
      inputDecorationTheme: InputDecorationThemes.lightInputDecorationTheme,
      checkboxTheme: CheckboxThemes.checkboxTheme,
      appBarTheme:  ThemeDataConfig.appBarLightTheme,
      scrollbarTheme: ThemeDataConfig.scrollbarThemeData,
      dataTableTheme: ThemeDataConfig.dataTableLightThemeData,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Plus Jakarta',
      primarySwatch: AppColors.primaryMaterialColor,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.darkGreyColor,
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.whiteColor),
        bodyMedium: TextStyle(color: AppColors.whiteColor40),
        bodySmall: TextStyle(color: AppColors.whiteColor),
      ),
      elevatedButtonTheme: ButtonThemes.elevatedButtonTheme,
      textButtonTheme: ButtonThemes.textButtonTheme,
      outlinedButtonTheme: ButtonThemes.outlinedButtonTheme,
      inputDecorationTheme: InputDecorationThemes.darkInputDecorationTheme,
      checkboxTheme: CheckboxThemes.checkboxTheme,
      appBarTheme:  ThemeDataConfig.appBarDarkTheme,
      scrollbarTheme: ThemeDataConfig.scrollbarThemeData,
      dataTableTheme: ThemeDataConfig.dataTableDarkThemeData,
    );
  }
}
