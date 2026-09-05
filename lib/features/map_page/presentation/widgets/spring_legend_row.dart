import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/spring_marker_icon.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';

class SpringLegendRow extends StatelessWidget {
  const SpringLegendRow({super.key, required this.icon, required this.label});

  final SpringIcon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpringMarkerIcon(icon: icon, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                label,
                style: context.appTextStyles.body2.copyWith(
                  color: colors.neutral700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
