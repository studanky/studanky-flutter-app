import 'package:studanky_flutter_app/core/app_constants.dart';

class MapPageConstants {
  const MapPageConstants._();

  static const String mapTilesMapy =
      'https://api.mapy.com/v1/maptiles/basic/256/{z}/{x}/{y}?apikey=${AppConstants.mapyComApiKey}';
}
