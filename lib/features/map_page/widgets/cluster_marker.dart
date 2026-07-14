import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';

/// Builds a clustered-count badge in the app's blue theme. Tapping zooms in to
/// the cluster's expansion level. Size grows mildly with the point count.
/// [semanticsLabel] announces the cluster (e.g. "Shluk studánek, počet 12").
Marker buildClusterMarker(
  Cluster cluster, {
  required VoidCallback onTap,
  String? semanticsLabel,
}) {
  final size = _sizeFor(cluster.count);

  return Marker(
    point: cluster.position,
    width: size,
    height: size,
    alignment: Alignment.center,
    // Keep upright when the map is rotated.
    rotate: true,
    child: Semantics(
      button: true,
      label: semanticsLabel,
      child: _ClusterBadge(count: cluster.count, size: size, onTap: onTap),
    ),
  );
}

double _sizeFor(int count) {
  if (count >= 100) return 60;
  if (count >= 10) return 50;
  return 42;
}

class _ClusterBadge extends StatelessWidget {
  const _ClusterBadge({
    required this.count,
    required this.size,
    required this.onTap,
  });

  final int count;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final label = count >= 1000 ? '${(count / 1000).floor()}k+' : '$count';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          // Deliberately the same water blue as the "flowing" marker so the map
          // canvas speaks a single blue; the count qualifies as WCAG large text
          // (≥18.66px bold), where the brand blue's 3.3:1 with [onPrimary]
          // clears the 3:1 large-text/graphics floor. The ring is the shared
          // [markerRing] so it stays white in both themes.
          color: colors.primaryMain,
          shape: BoxShape.circle,
          border: Border.all(color: colors.markerRing, width: 2),
          boxShadow: [
            BoxShadow(
              color: colors.primaryMain.withValues(alpha: isDark ? 0.55 : 0.4),
              blurRadius: isDark ? 16 : 12,
              spreadRadius: isDark ? 2 : 1,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.22),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colors.onPrimary,
            // Large-text size (with bold) — both for the AA floor above and for
            // at-a-glance counts; Google-style clusters use big numerals too.
            fontSize: 19,
            height: 1,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
