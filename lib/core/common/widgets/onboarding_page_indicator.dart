import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

/// An animated dot indicator for multi-step flows (onboarding, carousels, etc.).
///
/// Usage:
/// ```dart
/// OnboardingPageIndicator(
///   activeIndex: _currentPage,
///   count: 3,
/// )
/// ```
class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.activeIndex,
    required this.count,
    this.activeColor,
    this.inactiveColor,
    this.activeWidth = 28,
    this.dotSize = 8,
    this.spacing = 8,
  });

  /// Currently selected page index (zero-based).
  final int activeIndex;

  /// Total number of pages / dots.
  final int count;

  /// Color for the active dot. Defaults to [AppColors.primaryColor].
  final Color? activeColor;

  /// Color for inactive dots. Defaults to [AppColors.blackColor10].
  final Color? inactiveColor;

  /// Width of the active (expanded) dot.
  final double activeWidth;

  /// Diameter of inactive dots and height of the active dot.
  final double dotSize;

  /// Horizontal spacing between dots.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedActiveColor =
        activeColor ?? AppColors.primaryColor;
    final resolvedInactiveColor = inactiveColor ??
        (isDark ? AppColors.whiteColor20 : AppColors.blackColor10);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? activeWidth : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: isActive ? resolvedActiveColor : resolvedInactiveColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        );
      }),
    );
  }
}
