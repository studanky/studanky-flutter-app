import 'package:studanky_flutter_app/core/env.dart';

class MapPageConstants {
  const MapPageConstants._();

  static const String mapTilesMapy =
      'https://api.mapy.com/v1/maptiles/outdoor/256/{z}/{x}/{y}?apikey=${Env.mapyComApiKey}';

  /// Retain one ring of off-screen raster tiles instead of flutter_map's
  /// default two. The loading `TileLayer.panBuffer` remains at its default 1,
  /// preserving smooth near-edge pans while reducing image memory on older
  /// Android devices.
  static const int mapTileKeepBuffer = 1;
}
