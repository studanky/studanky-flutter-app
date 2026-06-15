import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// One iOS-style "inset grouped" section in the spring detail: an optional
/// uppercase caption above a rounded card sitting on the sheet's grouped
/// background. Keeps the detail's blocks (current state, about, location,
/// history) visually separated with a clear hierarchy.
class DetailSection extends StatelessWidget {
  const DetailSection({
    super.key,
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final String? title;

  /// Inner padding of the card. Pass [EdgeInsets.zero] for full-bleed rows
  /// (e.g. a list that draws its own row padding + dividers).
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 8),
              child: Text(
                title!.toUpperCase(),
                style: text.body2.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: colors.neutral500,
                ),
              ),
            ),
          DetailCard(padding: padding, child: child),
        ],
      ),
    );
  }
}

/// The rounded card surface used by [DetailSection] (and reusable on its own,
/// e.g. behind the history list). Solid `onNeutral` with a hairline edge so it
/// reads on both the light and dark grouped background.
class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    // A Material (not a plain Container) so InkWell ripples from rows inside the
    // card — copy coordinates, expand a report — render on the card surface and
    // are clipped to its rounded corners.
    return Material(
      color: colors.onNeutral,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.neutral200),
        borderRadius: BorderRadius.circular(kRadiusControl),
      ),
      child: Padding(
        padding: padding,
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

/// A label → value row used inside a [DetailSection] card (iOS settings style):
/// muted label on the left, the value (text or a graphical scale) on the right.
class DetailMetricRow extends StatelessWidget {
  const DetailMetricRow({super.key, required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: text.body2.copyWith(color: colors.neutral700)),
        const SizedBox(width: 12),
        Expanded(child: Align(alignment: Alignment.centerRight, child: value)),
      ],
    );
  }
}
