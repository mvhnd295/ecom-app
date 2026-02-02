import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Padding constants
  static const EdgeInsets p4 = EdgeInsets.all(4);
  static const EdgeInsets p8 = EdgeInsets.all(8);
  static const EdgeInsets p12 = EdgeInsets.all(12);
  static const EdgeInsets p16 = EdgeInsets.all(16);
  static const EdgeInsets p20 = EdgeInsets.all(20);
  static const EdgeInsets p24 = EdgeInsets.all(24);

  // Horizontal padding
  static const EdgeInsets ph8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets ph12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets ph16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets ph20 = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets ph24 = EdgeInsets.symmetric(horizontal: 24);

  // Vertical padding
  static const EdgeInsets pv8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets pv12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets pv16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets pv20 = EdgeInsets.symmetric(vertical: 20);
  static const EdgeInsets pv24 = EdgeInsets.symmetric(vertical: 24);

  // Combined padding (horizontal, vertical)
  static const EdgeInsets p12h16v = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets p16h20v = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
  );

  // Gap sizes
  static const SizedBox gap4 = SizedBox(height: 4, width: 4);
  static const SizedBox gap8 = SizedBox(height: 8, width: 8);
  static const SizedBox gap12 = SizedBox(height: 12, width: 12);
  static const SizedBox gap16 = SizedBox(height: 16, width: 16);
  static const SizedBox gap20 = SizedBox(height: 20, width: 20);
  static const SizedBox gap24 = SizedBox(height: 24, width: 24);

  // Horizontal gaps
  static const SizedBox gapH8 = SizedBox(width: 8);
  static const SizedBox gapH12 = SizedBox(width: 12);
  static const SizedBox gapH16 = SizedBox(width: 16);
  static const SizedBox gapH20 = SizedBox(width: 20);

  // Vertical gaps
  static const SizedBox gapV8 = SizedBox(height: 8);
  static const SizedBox gapV12 = SizedBox(height: 12);
  static const SizedBox gapV16 = SizedBox(height: 16);
  static const SizedBox gapV20 = SizedBox(height: 20);

  // Border radius
  static const BorderRadius borderRadius4 = BorderRadius.all(Radius.circular(4));
  static const BorderRadius borderRadius8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderRadius12 = BorderRadius.all(Radius.circular(12));
}
