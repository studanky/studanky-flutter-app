import 'package:studanky_flutter_app/core/env.dart';

class MapPageConstants {
  const MapPageConstants._();

  static const String mapTilesMapy =
      'https://api.mapy.com/v1/maptiles/outdoor/256/{z}/{x}/{y}?apikey=${Env.mapyComApiKey}';
}
