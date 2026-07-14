import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// A graphical 1…n scale: [max] rounded segments, the first [value] of them
/// filled in [color], the rest left as a faint track. Shared by the spring
/// detail's "flow strength" and "water clarity" readouts so both speak one
/// visual language (zadání §17 — síla toku / čistota graficky). The numeric or
/// word label is rendered by the caller next to the bar, so the meaning never
/// rests on colour alone (colour-blind safe).
class SegmentScale extends StatelessWidget {
  const SegmentScale({
    super.key,
    required this.value,
    required this.max,
    this.color,
    this.segmentWidth = 14,
    this.height = 8,
    this.gap = 4,
  });

  /// Filled segment count (clamped to 0…[max]).
  final int value;
  final int max;

  /// Fill colour for active segments; defaults to the primary blue.
  final Color? color;

  final double segmentWidth;
  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final fill = color ?? colors.primaryMain;
    // 0.28, not 0.16: the empty segments show the scale's maximum, so they
    // must stay visible against the sheet (0.16 measured ~1.2:1 on white).
    final track = fill.withValues(alpha: 0.28);
    final filled = value.clamp(0, max);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < max; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Container(
            width: segmentWidth,
            height: height,
            decoration: BoxDecoration(
              color: i < filled ? fill : track,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        ],
      ],
    );
  }
}
