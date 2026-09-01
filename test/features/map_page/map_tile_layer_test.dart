import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/features/map_page/constants/map_page_constants.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_tile_layer.dart';

void main() {
  test('retains one off-screen tile ring without changing load behaviour', () {
    final layer = buildMapTileLayer();

    expect(layer.urlTemplate, MapPageConstants.mapTilesMapy);
    expect(layer.keepBuffer, 1);
    expect(layer.panBuffer, 1);
    expect(layer.tileDisplay, const TileDisplay.fadeIn());
  });
}
