import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check if this is first time user or if there is a valid cached session
    Future.microtask(() {
      final isFirstTimer = cacheService.isFirstTimer();
      if (isFirstTimer) {
        // Show onboarding screen for first-time users
        if (mounted) {
          context.go(RouteNames.onboarding);
        }
      } else {
        // Check existing session for returning users
        ref.read(authProvider.notifier).checkCurrentUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<AuthState>(authProvider, (_, next) {
      if (!mounted) return;
      final isFirstTimer = cacheService.isFirstTimer();
      if (next is AuthAuthenticated) {
        // Navigate to home screen
        context.go(RouteNames.home);
      } else if (next is AuthUnauthenticated || next is AuthError) {
        // If first timer and onboarding not shown, show it
        if (isFirstTimer) {
          context.go(RouteNames.onboarding);
        } else {
          context.go(RouteNames.login);
        }
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'E-Buy',
              style: theme.textTheme.displayMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
