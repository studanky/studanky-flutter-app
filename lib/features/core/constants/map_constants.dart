import 'package:studanky_flutter_app/core/constants/app_constants.dart';

class MapConstants {
  const MapConstants._();

  static const String suggestHost = 'api.mapy.cz';
  static const String suggestBaseUrl = 'https://$suggestHost';
  static const String suggestPath = '/v1/suggest';
  static const String mapTilesMapy =
      'https://api.mapy.com/v1/maptiles/basic/256/{z}/{x}/{y}?apikey=${AppConstants.apiKey}';

  static const String mapSpringPoint = 'lib/core/assets/studanka_point.svg';
}
