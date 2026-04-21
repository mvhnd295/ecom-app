import 'package:flutter/material.dart';

/// Holds the content for a single onboarding page.
///
/// [mediaWidget] accepts any `Widget`, making it trivial to swap between
/// `Image.asset`, Lottie animations, SVGs, or any other visual.
class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.mediaWidget,
  });

  /// Headline text shown below the media.
  final String title;

  /// Supporting description text.
  final String subtitle;

  /// The visual element for this page (image, Lottie, SVG, etc.).
  final Widget mediaWidget;
}
