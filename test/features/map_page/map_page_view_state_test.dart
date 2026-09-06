import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_empty_state_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_marker_state.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/user_location_state.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/views/map_page_view_state.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/platform_config.dart';

const _base = MapPageViewState(
  markers: MapMarkerState(),
  platformConfig: PlatformConfig.fallback,
  location: UserLocationState(),
  emptyMode: MapEmptyOverlayMode.hidden,
  isOffline: false,
  isLocating: false,
  detailDocumentId: null,
  detailMarker: null,
);

void main() {
  test('equivalent view snapshots have value equality', () {
    const equivalent = MapPageViewState(
      markers: MapMarkerState(),
      platformConfig: PlatformConfig.fallback,
      location: UserLocationState(),
      emptyMode: MapEmptyOverlayMode.hidden,
      isOffline: false,
      isLocating: false,
      detailDocumentId: null,
      detailMarker: null,
    );

    expect(_base, equivalent);
    expect(_base.hashCode, equivalent.hashCode);
  });

  test('a changed rendered field makes snapshots unequal', () {
    const offline = MapPageViewState(
      markers: MapMarkerState(),
      platformConfig: PlatformConfig.fallback,
      location: UserLocationState(),
      emptyMode: MapEmptyOverlayMode.hidden,
      isOffline: true,
      isLocating: false,
      detailDocumentId: null,
      detailMarker: null,
    );

    expect(_base, isNot(offline));
  });
}
