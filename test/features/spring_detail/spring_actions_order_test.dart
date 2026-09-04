import 'package:flutter_test/flutter_test.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/services/spring_map_service.dart';

SupportedMap _map(MapApp map) => SupportedMap(map: map, isInstalled: true);

List<String> _ids(List<SupportedMap> maps) =>
    maps.map((supported) => supported.map.id).toList();

void main() {
  group('MapLauncherSpringMapService.orderForDisplay', () {
    test(
      'puts Mapy.com and outdoor apps first, regardless of install order',
      () {
        final result = MapLauncherSpringMapService.orderForDisplay([
          _map(MapApp.google),
          _map(MapApp.osmand),
          _map(MapApp.mapyCz),
        ]);

        expect(_ids(result), ['mapyCz', 'osmand', 'google']);
      },
    );

    test('does not filter maps supplied by capability discovery', () {
      final input = [
        _map(MapApp.yandexMaps),
        _map(MapApp.mapyCz),
        _map(MapApp.here),
      ];

      final result = MapLauncherSpringMapService.orderForDisplay(input);

      expect(result, hasLength(input.length));
      expect(result.first.map, MapApp.mapyCz);
      expect(_ids(result), containsAll(['yandexMaps', 'here']));
    });

    test(
      'non-preferred apps follow the preferred ones in their original order',
      () {
        final result = MapLauncherSpringMapService.orderForDisplay([
          _map(MapApp.yandexMaps),
          _map(MapApp.apple), // preferred (anchor)
          _map(MapApp.here),
          _map(MapApp.mapyCz), // preferred (first)
        ]);

        expect(_ids(result), ['mapyCz', 'apple', 'yandexMaps', 'here']);
      },
    );

    test('returns empty for empty input', () {
      expect(MapLauncherSpringMapService.orderForDisplay([]), isEmpty);
    });
  });
}
