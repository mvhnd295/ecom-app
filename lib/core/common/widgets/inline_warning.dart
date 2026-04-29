import 'package:fitflow/core/res/styles/colors.dart';
import 'package:flutter/material.dart';

class InlineWarning extends StatelessWidget {
  const InlineWarning(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.errorColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
