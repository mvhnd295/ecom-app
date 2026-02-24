import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';

/// AuthGuard provides redirect logic based on authentication state
class AuthGuard {
  static Future<String?> redirect(BuildContext context, GoRouterState state, WidgetRef ref) async {
    final authState = ref.read(authProvider);
    
    // Define public routes that don't require authentication
    final publicRoutes = {
      '/splash',
      '/onboarding',
      '/login',
      '/register',
      '/forgot-password',
    };

    final isPublicRoute = publicRoutes.contains(state.matchedLocation);

    if (authState is AuthAuthenticated) {
      // If user is authenticated and trying to access auth routes, redirect to home
      if (isPublicRoute && state.matchedLocation != '/splash') {
        return '/home';
      }
      return null;
    } else if (authState is AuthUnauthenticated) {
      // If user is not authenticated and trying to access protected routes
      if (!isPublicRoute) {
        return '/login';
      }
      return null;
    } else if (authState is AuthLoading) {
      // Keep user on splash screen while loading
      return null;
    }

    return null;
  }
}
