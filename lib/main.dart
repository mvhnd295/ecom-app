import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:fitflow/core/res/styles/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await cacheService.init();
  runApp(const MainApp());
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
      home: const Scaffold(body: Center(child: Text('Ebuy App Home Page'))),
    );
  }
}
