import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/springs/presentation/formatters/spring_formatters.dart';

/// Compact, copyable coordinates displayed in the detail hero.
class SpringHeroCoordinates extends StatelessWidget {
  const SpringHeroCoordinates({
    super.key,
    required this.position,
    required this.onCopy,
  });

  final LatLng position;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.appTextStyles;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: onCopy,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: 14,
                    color: colors.neutral700,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    SpringFormatters.coordinates(position),
                    style: text.body2.copyWith(
                      fontSize: 12.5,
                      color: colors.neutral700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.copy_rounded, size: 13, color: colors.neutral700),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
