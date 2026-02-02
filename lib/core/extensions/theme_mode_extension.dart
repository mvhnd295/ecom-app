import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  String get name {
    return switch (this) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
  }
}
