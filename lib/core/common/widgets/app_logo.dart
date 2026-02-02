import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.style});
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
      text: 'FitFlow',
      style: style ?? Theme.of(context).textTheme.headlineMedium
    ));
  }
}
