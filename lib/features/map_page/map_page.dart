import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/providers/connectivity_status_provider.dart';
import 'package:studanky_flutter_app/core/widgets/async_value_builder.dart';
import 'package:studanky_flutter_app/core/widgets/error_widget.dart';
import 'package:studanky_flutter_app/features/map_page/map_page_content.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/offline_placeholder.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key, this.detailDocumentId, this.detailMarker});

  /// When set, the map shows this spring's detail sheet (route
  /// `/map/spring/:documentId`); null is the plain `/map` home. Both routes
  /// resolve to this one page, so opening/closing the detail is a parameter
  /// change on the live map, never a page swap.
  final String? detailDocumentId;

  /// Already-loaded marker for an instant sheet header; null on a deep link /
  /// QR scan, where the sheet fetches by [detailDocumentId].
  final SpringMarkerEntity? detailMarker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityStatusProvider);

    void invalidateConnectivity() {
      ref.invalidate(connectivityStatusProvider);
    }

    return Scaffold(
      // Keep the map full-bleed and let the keyboard overlay the bottom strip
      // (disclaimer + attribution) instead of resizing the body up.
      resizeToAvoidBottomInset: false,
      body: AsyncValueBuilder<bool>(
        asyncValue: connectivity,
        error: (error, stackTrace) => AppErrorWidget(
          error: error,
          stackTrace: stackTrace,
          title: context.l10n.error_connectivity_status_title,
          subtitle: context.l10n.error_connectivity_status_subtitle,
          onRefresh: invalidateConnectivity,
        ),
        data: (online) => online
            ? MapPageContent(
                detailDocumentId: detailDocumentId,
                detailMarker: detailMarker,
              )
            : OfflinePlaceholder(onRetry: invalidateConnectivity),
      ),
    );
  }
}
