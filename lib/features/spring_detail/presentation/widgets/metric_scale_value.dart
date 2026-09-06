import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// Graphical metric scale with a trailing value label.
class MetricScaleValue extends StatelessWidget {
  const MetricScaleValue({
    super.key,
    required this.scale,
    required this.label,
    required this.labelColor,
    this.spacing = 10,
  });

  final Widget scale;
  final String label;
  final Color labelColor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        scale,
        SizedBox(width: spacing),
        Text(
          label,
          style: context.appTextStyles.title2.copyWith(color: labelColor),
        ),
      ],
    );
  }
}
