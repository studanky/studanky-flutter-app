import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';

/// Builds a clustered-count badge in the app's blue theme. Tapping zooms in to
/// the cluster's expansion level. Size grows mildly with the point count.
Marker buildClusterMarker(Cluster cluster, {required VoidCallback onTap}) {
  final size = _sizeFor(cluster.count);

  return Marker(
    point: cluster.position,
    width: size,
    height: size,
    alignment: Alignment.center,
    // Keep upright when the map is rotated.
    rotate: true,
    child: _ClusterBadge(count: cluster.count, size: size, onTap: onTap),
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
          color: colors.primaryMain,
          shape: BoxShape.circle,
          border: Border.all(color: colors.onPrimary, width: 2),
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
