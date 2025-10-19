import 'package:latlong2/latlong.dart';

/// Lightweight projection of a single search suggestion returned by the
/// Mapy.cz suggest API (or one of the fallbacks).
class MapSearchResult {
  const MapSearchResult({
    required this.label,
    required this.position,
    this.raw,
  });

  final String label;
  final LatLng position;

  /// Raw payload returned by the backend. Useful for diagnostics or for
  /// surfacing extra metadata in the UI.
  final Map<String, dynamic>? raw;
}
