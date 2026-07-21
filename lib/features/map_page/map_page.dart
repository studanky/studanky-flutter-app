import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/features/map_page/map_page_content.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key, this.detailDocumentId, this.detailMarker});

  /// When set, the map shows this spring's detail sheet (route
  /// `/map/spring/:documentId`); null is the plain `/map` home. Both routes
  /// resolve to this one page, so opening/closing the detail is a parameter
  /// change on the live map, never a page swap.
  final String? detailDocumentId;

  /// Already-loaded marker for an instant sheet header; null on a public link,
  /// where the sheet fetches by [detailDocumentId].
  final SpringMarkerEntity? detailMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep the map full-bleed and let the keyboard overlay the bottom strip
      // (disclaimer + attribution) instead of resizing the body up.
      resizeToAvoidBottomInset: false,
      // The map is always mounted. Connectivity is advisory, not a gate: an
      // offline device gets a non-blocking banner over the live map (see
      // MapPageContent), never a full-screen takeover — so nothing offline
      // flashes during the cold-start connectivity probe.
      body: MapPageContent(
        detailDocumentId: detailDocumentId,
        detailMarker: detailMarker,
      ),
    );
  }
}
