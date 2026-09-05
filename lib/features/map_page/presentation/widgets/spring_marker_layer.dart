import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/cluster_marker.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/marker.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

class SpringMarkerLayer extends StatelessWidget {
  const SpringMarkerLayer({
    required this.items,
    required this.config,
    required this.selectedDocumentId,
    required this.l10n,
    required this.onClusterTap,
    required this.onSpringTap,
    super.key,
  });

  final List<MapClusterItem> items;
  final PlatformConfig config;
  final String? selectedDocumentId;
  final AppLocalizations l10n;
  final ValueChanged<Cluster> onClusterTap;
  final ValueChanged<SpringMarkerEntity> onSpringTap;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        for (final item in items)
          switch (item) {
            Cluster() => buildClusterMarker(
              item,
              onTap: () => onClusterTap(item),
              semanticsLabel: l10n.map_cluster_semantic(item.count),
            ),
            SpringPoint(:final spring) => buildSpringMarker(
              spring,
              config.iconFor(spring.status.wireValue, spring.statusUpdatedAt),
              onTap: () => onSpringTap(spring),
              selected: spring.documentId == selectedDocumentId,
              semanticsLabel: l10n.map_marker_semantic(
                spring.name,
                _statusLabel(
                  config.iconFor(
                    spring.status.wireValue,
                    spring.statusUpdatedAt,
                  ),
                  l10n,
                ),
              ),
            ),
          },
      ],
    );
  }
}

String _statusLabel(SpringIcon icon, AppLocalizations l10n) => switch (icon) {
  SpringIcon.flowing => l10n.spring_detail_status_flowing,
  SpringIcon.notFlowing => l10n.spring_detail_status_not_flowing,
  SpringIcon.stale => l10n.map_status_stale,
  SpringIcon.unknown => l10n.spring_detail_status_unknown,
};
