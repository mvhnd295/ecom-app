import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => cacheService.getThemeMode();

  Future<void> setTheme(ThemeMode mode) async {
    await cacheService.setThemeMode(mode);
    state = mode;
  }
}

final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
