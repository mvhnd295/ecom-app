import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 1.0});

  /// Scale multiplier — 1.0 renders at the default 26 px font size.
  final double size;

  @override
  Widget build(BuildContext context) {
    final fs = 26.0 * size;
    final boxSize = fs * 1.18;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(boxSize * 0.28),
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: boxSize * 0.60,
          ),
        ),
        SizedBox(width: fs * 0.28),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Nex',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: fs,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1,
                ),
              ),
              TextSpan(
                text: 'ora',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: fs,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.8,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
