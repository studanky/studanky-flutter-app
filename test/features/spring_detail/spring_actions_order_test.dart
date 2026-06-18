import 'package:flutter_test/flutter_test.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_actions.dart';

AvailableMap _map(MapType type) =>
    AvailableMap(mapName: type.name, mapType: type, icon: '');

List<MapType> _types(List<AvailableMap> maps) =>
    maps.map((m) => m.mapType).toList();

void main() {
  group('SpringActions.orderForDisplay', () {
    test('puts Mapy.com and outdoor apps first, regardless of install order', () {
      final result = SpringActions.orderForDisplay([
        _map(MapType.google),
        _map(MapType.osmand),
        _map(MapType.mapyCz),
      ]);

      expect(_types(result), [MapType.mapyCz, MapType.osmand, MapType.google]);
    });

    test('keeps every installed app — nothing is filtered out (Waze included)', () {
      final input = [
        _map(MapType.waze),
        _map(MapType.mapyCz),
        _map(MapType.citymapper),
      ];

      final result = SpringActions.orderForDisplay(input);

      expect(result, hasLength(input.length));
      expect(result.first.mapType, MapType.mapyCz);
      expect(
        _types(result),
        containsAll([MapType.waze, MapType.citymapper]),
      );
    });

    test('non-preferred apps follow the preferred ones in their original order', () {
      final result = SpringActions.orderForDisplay([
        _map(MapType.waze),
        _map(MapType.apple), // preferred (anchor)
        _map(MapType.citymapper),
        _map(MapType.mapyCz), // preferred (first)
      ]);

      expect(_types(result), [
        MapType.mapyCz,
        MapType.apple,
        MapType.waze,
        MapType.citymapper,
      ]);
    });

    test('returns empty for empty input', () {
      expect(SpringActions.orderForDisplay([]), isEmpty);
    });
  });
}
