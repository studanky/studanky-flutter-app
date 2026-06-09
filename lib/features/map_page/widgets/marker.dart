import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studanky_flutter_app/core/app_constants.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

const double _springMarkerSize = 40;

/// Builds a single spring marker, coloured by its three-state [icon]
/// (api-reference.md §4.1). The shared SVG is tinted per state; "stale" and
/// "unknown" read neutrally, never as a confident flow state (spec §4.1).
Marker buildSpringMarker(
  SpringMarkerEntity spring,
  SpringIcon icon, {
  VoidCallback? onTap,
}) {
  return Marker(
    key: ValueKey('spring-${spring.documentId}'),
    point: spring.position,
    width: _springMarkerSize,
    height: _springMarkerSize,
    alignment: Alignment.center,
    // Keep upright when the map is rotated.
    rotate: true,
    child: _SpringMarkerPin(icon: icon, onTap: onTap),
  );
}

class _SpringMarkerPin extends StatelessWidget {
  const _SpringMarkerPin({required this.icon, this.onTap});

  final SpringIcon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final background = _backgroundColor(icon, colors);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(color: colors.onPrimary, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          AppConstants.iconSpring,
          colorFilter: ColorFilter.mode(colors.onPrimary, BlendMode.srcIn),
        ),
      ),
    );
  }

  Color _backgroundColor(SpringIcon icon, AppColors colors) {
    return switch (icon) {
      SpringIcon.flowing => colors.primaryMain,
      SpringIcon.notFlowing => colors.error,
      SpringIcon.stale => colors.neutral500,
      SpringIcon.unknown => colors.neutral300,
    };
  }
}
