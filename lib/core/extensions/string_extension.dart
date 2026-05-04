import 'package:flutter/material.dart';

extension StringExtension on String {
  bool get isValidEmail {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(this);
  }

  ThemeMode toThemeMode() {
    return switch (toLowerCase()) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Returns up to two uppercase initials derived from the first two words.
  ///
  /// Examples: `'John Doe'` → `'JD'`, `'Alice'` → `'A'`, `''` → `'?'`
  String get initials {
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}