import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_empty_state_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_marker_state.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';

void main() {
  test('reveals a confirmed empty viewport after the debounce', () async {
    final controller = MapEmptyStateController();
    addTearDown(controller.dispose);

    controller.sync(const MapMarkerState(visibleBoundsLoaded: true));
    expect(controller.mode, MapEmptyOverlayMode.hidden);

    await Future<void>.delayed(
      MapViewConfig.emptyStateRevealDelay + const Duration(milliseconds: 20),
    );
    expect(controller.mode, MapEmptyOverlayMode.empty);
  });

  test('keeps a visible empty state while data refreshes', () async {
    final controller = MapEmptyStateController();
    addTearDown(controller.dispose);
    controller.sync(const MapMarkerState(visibleBoundsLoaded: true));
    await Future<void>.delayed(
      MapViewConfig.emptyStateRevealDelay + const Duration(milliseconds: 20),
    );

    controller.sync(
      const MapMarkerState(
        visibleBoundsLoaded: true,
        status: AsyncValue<void>.loading(),
      ),
    );

    expect(controller.mode, MapEmptyOverlayMode.refreshing);
  });

  test('hides immediately when a visible marker appears', () async {
    final controller = MapEmptyStateController();
    addTearDown(controller.dispose);
    controller.sync(const MapMarkerState(visibleBoundsLoaded: true));
    await Future<void>.delayed(
      MapViewConfig.emptyStateRevealDelay + const Duration(milliseconds: 20),
    );

    controller.sync(
      const MapMarkerState(visibleBoundsLoaded: true, hasVisibleMarkers: true),
    );

    expect(controller.mode, MapEmptyOverlayMode.hidden);
  });
}
