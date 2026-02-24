import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:fitflow/core/routes/guards/auth_guard.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';
import 'package:fitflow/features/auth/presentation/views/splash_screen.dart';
import 'package:fitflow/features/auth/presentation/views/login_view.dart';
import 'package:fitflow/features/auth/presentation/views/register_view.dart';
import 'package:fitflow/features/auth/presentation/views/forgot_password_view.dart';
import 'package:fitflow/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:fitflow/features/home/presentation/views/home_view.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      return AuthGuard.redirect(context, state, ref as WidgetRef);
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingView(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),

      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),

      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordView(),
      ),

      // Home Routes
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),
    ],

    // Error page for undefined routes
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
