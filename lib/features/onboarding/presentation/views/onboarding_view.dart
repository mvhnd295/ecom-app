import 'package:fitflow/core/common/singletons/cache.dart';
import 'package:fitflow/core/common/widgets/gradient_button.dart';
import 'package:fitflow/core/common/widgets/onboarding_page_indicator.dart';
import 'package:fitflow/core/res/media.dart';
import 'package:fitflow/core/res/spacing.dart';
import 'package:fitflow/core/res/styles/colors.dart';
import 'package:fitflow/core/routes/route_names.dart';
import 'package:fitflow/features/onboarding/data/models/onboarding_page_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  List<OnboardingPageData> _buildPages(bool isDark) {
    return [
      OnboardingPageData(
        title: 'Discover Trending Styles',
        subtitle:
            'Explore curated collections and find the perfect look that matches your personality.',
        mediaWidget: _buildMedia(
          isDark
              ? AppMedia.illustrationDarkTheme0
              : AppMedia.illustration0,
        ),
      ),
      OnboardingPageData(
        title: 'Shop With Confidence',
        subtitle:
            'Secure checkout, real-time tracking, and hassle-free returns — all in one place.',
        mediaWidget: _buildMedia(
          isDark
              ? AppMedia.illustrationDarkTheme1
              : AppMedia.illustration1,
        ),
      ),
      OnboardingPageData(
        title: 'Exclusive Deals Await',
        subtitle:
            'Unlock members-only discounts and be the first to know about flash sales.',
        mediaWidget: _buildMedia(
          isDark
              ? AppMedia.illustrationDarkTheme2
              : AppMedia.illustration2,
        ),
      ),
    ];
  }

  /// Wraps an asset path in a styled, swappable image container.
  /// Replace the [Image.asset] with a Lottie widget, SVG, or any other widget.
  Widget _buildMedia(String assetPath) {
    return Container(
      padding: AppSpacing.p24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.12),
            AppColors.primaryColor.withValues(alpha: 0.0),
          ],
          radius: 0.7,
        ),
      ),
      child: Image.asset(
        assetPath,
        height: 280,
        fit: BoxFit.contain,
        // If the asset is missing during development, show a tinted placeholder.
        errorBuilder: (_, _, _) => Container(
          height: 280,
          width: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor.withValues(alpha: 0.08),
          ),
          child: const Icon(
            Icons.image_outlined,
            size: 80,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    await cacheService.setFirstLaunch(false);
    if (mounted) context.go(RouteNames.login);
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pages = _buildPages(isDark);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ──
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedOpacity(
                opacity: _currentPage < pages.length - 1 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: TextButton(
                  onPressed: _currentPage < pages.length - 1
                      ? _completeOnboarding
                      : null,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.whiteColor60
                          : AppColors.blackColor60,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // ── Page content ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  _fadeController
                    ..reset()
                    ..forward();
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: AppSpacing.ph24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Media / illustration
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SizedBox(
                            height: size.height * 0.38,
                            child: page.mediaWidget,
                          ),
                        ),

                        AppSpacing.gapV20,

                        // Title
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Grandis Extended',
                              height: 1.25,
                              color: isDark
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                            ),
                          ),
                        ),

                        AppSpacing.gapV12,

                        // Subtitle
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.55,
                              color: isDark
                                  ? AppColors.whiteColor60
                                  : AppColors.blackColor60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Bottom section ──
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator
                  OnboardingPageIndicator(
                    activeIndex: _currentPage,
                    count: pages.length,
                  ),

                  const SizedBox(height: 24),

                  // CTA button
                  GradientButton(
                    text: _currentPage < pages.length - 1
                        ? 'Next'
                        : 'Get Started',
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
