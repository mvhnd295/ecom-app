import 'package:fitflow/core/di/injection_container.dart';
import 'package:fitflow/core/services/storage/cache_helper.dart';
import 'package:fitflow/features/cart/presentation/views/cart_view.dart';
import 'package:fitflow/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:fitflow/features/home/presentation/views/home_view.dart';
import 'package:fitflow/features/products/presentation/views/product_detail_view.dart';
import 'package:fitflow/features/profile/presentation/views/profile_view.dart';
import 'package:fitflow/features/search/presentation/views/search_view.dart';
import 'package:fitflow/features/wishlist/presentation/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/auth/presentation/views/splash_screen.dart';
import 'package:fitflow/features/auth/presentation/views/login_view.dart';
import 'package:fitflow/features/auth/presentation/views/register_view.dart';
import 'package:fitflow/features/auth/presentation/views/forgot_password_view.dart';
import 'package:fitflow/features/onboarding/presentation/views/onboarding_view.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: RouteNames.home,
  redirect: (context, state) {
    final cache = sl<CacheHelper>();
    final location = state.matchedLocation;

    if (cache.isFirstLaunch() && location != RouteNames.onboarding) {
      return RouteNames.onboarding;
    }

    final isAuthRoute = {
      RouteNames.login,
      RouteNames.register,
      RouteNames.forgotPassword,
    }.contains(location);
    final isOnboardingRoute = location == RouteNames.onboarding;

    if (!cache.isAuthenticated) {
      if (isOnboardingRoute || isAuthRoute) return null;
      return RouteNames.login;
    }

    if (isOnboardingRoute || isAuthRoute) {
      return RouteNames.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) {
        final cacheHelper = sl<CacheHelper>()
          ..getSessionToken()
          ..getUserId();
        if (cacheHelper.isFirstLaunch()) {
          return const OnboardingView();
        }
        return const SplashScreen();
      },
    ),
    GoRoute(path: RouteNames.login, builder: (_, _) => const LoginView()),
    GoRoute(path: RouteNames.register, builder: (_, _) => const RegisterView()),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (_, _) => const ForgotPasswordView(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (_, _) => const OnboardingView(),
    ),
    GoRoute(
      path: RouteNames.productDetail,
      builder: (_, state) => ProductDetailView(
        productId: state.pathParameters['id'] ?? '',
      ),
    ),
    ShellRoute(
      builder: (context, state, child) =>
          DashboardView(state: state, child: child),
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (_, _) => const HomeView(),
        ),
        GoRoute(
          path: RouteNames.search,
          builder: (_, _) => const SearchView(),
        ),
        GoRoute(
          path: RouteNames.cart,
          builder: (_, _) => const CartView(),
        ),
        GoRoute(
          path: RouteNames.wishlist,
          builder: (_, _) => const WishlistView(),
        ),
        GoRoute(
          path: RouteNames.profile,
          builder: (_, _) => const ProfileView(),
        ),
      ],
    ),
  ],
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
