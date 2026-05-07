import 'package:fitflow/core/common/singletons/cache.dart';
// import 'package:fitflow/core/common/widgets/app_logo.dart';
import 'package:fitflow/core/di/injection_container.dart' as di;
import 'package:fitflow/core/providers/theme_provider.dart';
import 'package:fitflow/core/res/styles/theme/app_theme.dart';
import 'package:fitflow/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await cacheService.init();
  await di.init();

  runApp(const ProviderScope(child: MainApp()));
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           AppLogo(size: 0.7),   // appbar size
  //           SizedBox(height: 32),
  //           AppLogo(size: 1.0),   // default
  //           SizedBox(height: 32),
  //           AppLogo(size: 1.6),   // splash/hero size
  //         ],
  //       ),
  //     ),
  //   ),
  // ));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final goRouter = router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Ebuy App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: goRouter,
    );
  }
}
