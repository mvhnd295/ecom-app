import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

/// A prominent call-to-action button with a gradient background.
///
/// Uses the app's primary purple tones by default. The gradient, size,
/// border-radius, and text style are all customisable.
///
/// Usage:
/// ```dart
/// GradientButton(
///   text: 'Get Started',
///   onPressed: () => ...,
/// )
/// ```
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.textStyle,
    this.child,
  });

  /// Button label. Ignored when [child] is provided.
  final String text;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Optional custom gradient. Defaults to a left-to-right purple sweep.
  final Gradient? gradient;

  /// Fixed width. Defaults to stretching to available space.
  final double? width;

  /// Fixed height. Defaults to `56`.
  final double height;

  /// Corner radius. Defaults to `16`.
  final double borderRadius;

  /// Override text style for the label.
  final TextStyle? textStyle;

  /// Optional custom child widget (replaces the default [Text]).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final resolvedGradient = gradient ??
        const LinearGradient(
          colors: [
            AppColors.primaryColor,
            Color(0xFF9B7FFF),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null ? resolvedGradient : null,
          color: onPressed == null ? AppColors.blackColor20 : null,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: onPressed != null
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: MaterialButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.zero,
          child: child ??
              Text(
                text,
                style: textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
              ),
        ),
      ),
    );
  }
}
