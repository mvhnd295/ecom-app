import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:fitflow/core/di/injection_container.dart' as di;
import 'package:fitflow/core/res/styles/theme/app_theme.dart';
import 'package:fitflow/features/auth/presentation/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await cacheService.init();
  await di.init();

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = cacheService.getThemeMode();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ebuy App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
