import 'package:fitflow/core/common/widgets/app_logo.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_notifier.dart';
import 'package:fitflow/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  bool _minTimePassed = false;
  bool _authChecked = false;
  AuthState? _resolvedState;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Start auth check and minimum display timer in parallel.
    Future.microtask(
      () => ref.read(authProvider.notifier).checkCurrentUser(),
    );

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      _minTimePassed = true;
      _maybeNavigate();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _maybeNavigate() {
    if (!_minTimePassed || !_authChecked) return;
    if (_resolvedState is AuthAuthenticated) {
      context.go(RouteNames.home);
    } else if (_resolvedState is AuthUnauthenticated) {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated || next is AuthUnauthenticated) {
        _resolvedState = next;
        _authChecked = true;
        _maybeNavigate();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 1.6),
                const SizedBox(height: 16),
                Text(
                  'Your smart shopping companion',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
