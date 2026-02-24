import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:fitflow/core/routes/route_names.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  Future<void> _completeOnboarding() async {
    // Mark onboarding as complete in shared preferences
    await cacheService.markOnboardingComplete();

    if (mounted) {
      // Navigate to login screen
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Onboarding Screen'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _completeOnboarding,
              child: const Text('Complete Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}
