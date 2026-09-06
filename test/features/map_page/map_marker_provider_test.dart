import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_page/entities/map_cluster_item.dart';

import '../../support/map_marker_test_support.dart';

void main() {
  test('renders each spring individually at high zoom', () async {
    final container = containerWith(
      FakeSpringRepository([prague, pragueNear, zdar]),
    );
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(wideBounds, 18);

    final items = container.read(testMapMarkerProvider).items;
    expect(items.whereType<SpringPoint>().length, 3);
    expect(items.whereType<Cluster>(), isEmpty);
  });

  test('groups nearby springs into fewer items at low zoom', () async {
    final container = containerWith(
      FakeSpringRepository([prague, pragueNear, zdar]),
    );
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(wideBounds, 5);

    final items = container.read(testMapMarkerProvider).items;
    expect(items.length, lessThan(3));
    expect(items.whereType<Cluster>(), isNotEmpty);
  });

  test('clusters only springs inside the camera window', () async {
    final container = containerWith(
      FakeSpringRepository([prague, pragueNear, zdar]),
    );
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(pragueBounds, 18);
    expect(
      container
          .read(testMapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .length,
      2,
    );

    await notifier.reportCameraForTest(wideBounds, 18);
    expect(
      container
          .read(testMapMarkerProvider)
          .items
          .whereType<SpringPoint>()
          .length,
      3,
    );
  });

  test('prefetches a marker without treating it as visible', () async {
    expect(pragueBounds.contains(praguePaddingRing.position), isFalse);
    final container = containerWith(FakeSpringRepository([praguePaddingRing]));
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(pragueBounds, 18);

    final paddedState = container.read(testMapMarkerProvider);
    expect(
      paddedState.items.whereType<SpringPoint>().single.spring,
      praguePaddingRing,
    );
    expect(paddedState.visibleBoundsLoaded, isTrue);
    expect(paddedState.hasVisibleMarkers, isFalse);

    final pannedBounds = LatLngBounds(
      const LatLng(50.125, 14.60),
      const LatLng(49.975, 14.30),
    );
    final pannedLoad = notifier.reportCameraForTest(pannedBounds, 18);
    final visibleState = container.read(testMapMarkerProvider);
    expect(visibleState.hasVisibleMarkers, isTrue);
    expect(
      identical(visibleState.items.single, paddedState.items.single),
      isTrue,
    );
    await pannedLoad;
  });

  test('keeps visible data loaded while only padding fetches', () async {
    final secondFetchGate = Completer<void>();
    addTearDown(() {
      if (!secondFetchGate.isCompleted) secondFetchGate.complete();
    });
    final visibleSpring = spring('visible', 50.075, 14.447);
    final repository = FakeSpringRepository(
      [visibleSpring],
      gate: secondFetchGate.future,
      gateOnFetch: 2,
    );
    final container = containerWith(repository);
    final notifier = container.read(testMapMarkerProvider.notifier);
    final initialBounds = LatLngBounds(
      const LatLng(50.10, 14.45),
      const LatLng(50.05, 14.40),
    );
    final pannedBounds = LatLngBounds(
      const LatLng(50.10, 14.492),
      const LatLng(50.05, 14.442),
    );

    await notifier.reportCameraForTest(initialBounds, 18);
    final paddingFetch = notifier.reportCameraForTest(pannedBounds, 18);
    final fetchingState = container.read(testMapMarkerProvider);

    expect(repository.fetchCount, 2);
    expect(fetchingState.status.isLoading, isTrue);
    expect(fetchingState.visibleBoundsLoaded, isTrue);
    expect(
      fetchingState.items.whereType<SpringPoint>().single.spring,
      visibleSpring,
    );

    secondFetchGate.complete();
    await paddingFetch;
  });

  test('panning inside the cluster window emits no state', () async {
    final container = containerWith(
      FakeSpringRepository([prague, pragueNear, zdar]),
    );
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(pragueBounds, 18);
    final state = container.read(testMapMarkerProvider);
    await notifier.reportCameraForTest(pragueBoundsNudged, 18);
    expect(identical(container.read(testMapMarkerProvider), state), isTrue);

    await notifier.reportCameraForTest(wideBounds, 18);
    expect(container.read(testMapMarkerProvider).items, isNot(state.items));
  });

  test('marks an empty visible viewport as loaded', () async {
    final container = containerWith(FakeSpringRepository([]));
    final notifier = container.read(testMapMarkerProvider.notifier);

    await notifier.reportCameraForTest(pragueBounds, 18);

    final state = container.read(testMapMarkerProvider);
    expect(state.items, isEmpty);
    expect(state.visibleBoundsLoaded, isTrue);
  });
}
