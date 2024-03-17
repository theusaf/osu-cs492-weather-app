import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cs492_weather_app/widgets/theme_builder.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (context, colorScheme, textTheme) {
        return Shimmer.fromColors(
          baseColor: colorScheme.onBackground.withAlpha(200),
          highlightColor: Colors.grey.shade400,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: colorScheme.onBackground,
            ),
          ),
        );
      },
    );
  }
}
