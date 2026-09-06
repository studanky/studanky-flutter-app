import 'package:flutter_map/flutter_map.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_tile_config.dart';

/// Creates the shared Mapy.com raster layer used by both map themes.
///
/// Keeping this configuration in one factory prevents the light and filtered
/// dark branches from drifting apart.
TileLayer buildMapTileLayer() => TileLayer(
  urlTemplate: MapTileConfig.mapTilesMapy,
  keepBuffer: MapTileConfig.mapTileKeepBuffer,
  // A/B candidate: skip the default 100 ms per-tile opacity animation and
  // present decoded tiles immediately. panBuffer intentionally stays at 1.
  tileDisplay: const TileDisplay.instantaneous(),
);
