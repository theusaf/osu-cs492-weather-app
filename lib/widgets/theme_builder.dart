import 'package:flutter/material.dart';

class ThemeBuilder extends StatelessWidget {
  const ThemeBuilder({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return builder(context, theme.colorScheme, theme.textTheme);
  }
}
