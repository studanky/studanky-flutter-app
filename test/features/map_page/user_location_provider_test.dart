import 'dart:async';

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';

class _FakeUserLocationService implements UserLocationService {
  _FakeUserLocationService({
    this.serviceEnabled = true,
    this.permission = LocationPermission.denied,
    List<LocationPermission>? requestResults,
  }) : requestResults = List.of(requestResults ?? const []);

  bool serviceEnabled;
  LocationPermission permission;
  final List<LocationPermission> requestResults;
  final StreamController<Position> positions =
      StreamController<Position>.broadcast();

  int serviceEnabledCount = 0;
  int checkPermissionCount = 0;
  int requestPermissionCount = 0;
  int positionStreamListenCount = 0;

  @override
  Future<bool> isLocationServiceEnabled() async {
    serviceEnabledCount++;
    return serviceEnabled;
  }

  @override
  Future<LocationPermission> checkPermission() async {
    checkPermissionCount++;
    return permission;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    requestPermissionCount++;
    if (requestResults.isNotEmpty) {
      permission = requestResults.removeAt(0);
    }
    return permission;
  }

  @override
  Stream<Position> getPositionStream({
    required LocationSettings locationSettings,
  }) async* {
    positionStreamListenCount++;
    yield* positions.stream;
  }

  void emitPosition({double latitude = 50.08, double longitude = 14.42}) {
    positions.add(
      Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime(2026, 7, 21),
        accuracy: 5,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      ),
    );
  }

  Future<void> dispose() => positions.close();
}

ProviderContainer _containerWith(_FakeUserLocationService service) {
  final container = ProviderContainer(
    overrides: [userLocationServiceProvider.overrideWithValue(service)],
  );
  addTearDown(container.dispose);
  addTearDown(service.dispose);
  container.listen(userLocationProvider, (_, _) {}, fireImmediately: true);
  return container;
}

Future<void> _pumpEventQueue() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  test('defaults to inactive and does not touch location permission', () {
    final service = _FakeUserLocationService();
    final container = _containerWith(service);

    expect(container.read(userLocationProvider), const UserLocationState());
    expect(service.serviceEnabledCount, 0);
    expect(service.checkPermissionCount, 0);
    expect(service.requestPermissionCount, 0);
  });

  test(
    'listening to the position stream before activation does not prompt',
    () async {
      final service = _FakeUserLocationService();
      final container = _containerWith(service);
      final subscription = container
          .read(userLocationProvider.notifier)
          .positionStream
          .listen((_) {});
      addTearDown(subscription.cancel);

      await _pumpEventQueue();

      expect(service.serviceEnabledCount, 0);
      expect(service.checkPermissionCount, 0);
      expect(service.requestPermissionCount, 0);
    },
  );

  test(
    'firstFix activates location and requests permission on demand',
    () async {
      final service = _FakeUserLocationService(
        requestResults: [LocationPermission.whileInUse],
      );
      final container = _containerWith(service);
      final notifier = container.read(userLocationProvider.notifier);

      final firstFix = notifier.firstFix();
      await _pumpEventQueue();

      expect(container.read(userLocationProvider).activated, isTrue);
      expect(service.requestPermissionCount, 1);
      expect(service.positionStreamListenCount, 1);

      service.emitPosition(latitude: 49.2, longitude: 16.6);
      final location = await firstFix.timeout(const Duration(seconds: 1));

      expect(location, isNotNull);
      expect(location!.latitude, 49.2);
      expect(location.longitude, 16.6);
      expect(container.read(userLocationProvider).status, LocationStatus.ready);
    },
  );

  test('activateIfPermissionGranted does not request permission', () async {
    final service = _FakeUserLocationService(
      permission: LocationPermission.whileInUse,
    );
    final container = _containerWith(service);

    final activated = await container
        .read(userLocationProvider.notifier)
        .activateIfPermissionGranted();
    await _pumpEventQueue();

    expect(activated, isTrue);
    expect(container.read(userLocationProvider).activated, isTrue);
    expect(service.requestPermissionCount, 0);
    expect(service.positionStreamListenCount, 1);
  });

  test(
    'activateIfPermissionGranted stays inactive and silent when denied',
    () async {
      final service = _FakeUserLocationService();
      final container = _containerWith(service);

      final activated = await container
          .read(userLocationProvider.notifier)
          .activateIfPermissionGranted();
      await _pumpEventQueue();

      expect(activated, isFalse);
      expect(container.read(userLocationProvider).activated, isFalse);
      expect(service.requestPermissionCount, 0);
      expect(service.positionStreamListenCount, 0);
    },
  );

  test('denied permission resets the stream for a later retry', () async {
    final service = _FakeUserLocationService(
      requestResults: [
        LocationPermission.denied,
        LocationPermission.whileInUse,
      ],
    );
    final container = _containerWith(service);
    final notifier = container.read(userLocationProvider.notifier);

    final deniedFix = await notifier.firstFix().timeout(
      const Duration(seconds: 1),
    );
    expect(deniedFix, isNull);
    expect(container.read(userLocationProvider).status, LocationStatus.denied);
    expect(container.read(userLocationProvider).activated, isFalse);
    expect(service.requestPermissionCount, 1);

    final retryFix = notifier.firstFix();
    await _pumpEventQueue();
    expect(service.requestPermissionCount, 2);

    service.emitPosition();
    final location = await retryFix.timeout(const Duration(seconds: 1));

    expect(location, isNotNull);
    expect(container.read(userLocationProvider).status, LocationStatus.ready);
    expect(container.read(userLocationProvider).activated, isTrue);
  });

  test('serviceOff resets the stream for a later retry', () async {
    final service = _FakeUserLocationService(
      serviceEnabled: false,
      permission: LocationPermission.whileInUse,
    );
    final container = _containerWith(service);
    final notifier = container.read(userLocationProvider.notifier);

    final disabledFix = await notifier.firstFix().timeout(
      const Duration(seconds: 1),
    );
    expect(disabledFix, isNull);
    expect(
      container.read(userLocationProvider).status,
      LocationStatus.serviceOff,
    );
    expect(container.read(userLocationProvider).activated, isFalse);
    expect(service.requestPermissionCount, 0);

    service.serviceEnabled = true;
    final retryFix = notifier.firstFix();
    await _pumpEventQueue();
    service.emitPosition();

    final location = await retryFix.timeout(const Duration(seconds: 1));
    expect(location, isNotNull);
    expect(container.read(userLocationProvider).status, LocationStatus.ready);
  });

  test(
    'positionStream replays the last known position to late listeners',
    () async {
      final service = _FakeUserLocationService(
        requestResults: [LocationPermission.whileInUse],
      );
      final container = _containerWith(service);
      final notifier = container.read(userLocationProvider.notifier);

      final firstFix = notifier.firstFix();
      await _pumpEventQueue();
      service.emitPosition(latitude: 48.9, longitude: 15.7);
      await firstFix.timeout(const Duration(seconds: 1));

      final values = <LocationMarkerPosition?>[];
      final subscription = notifier.positionStream.listen(values.add);
      addTearDown(subscription.cancel);
      await _pumpEventQueue();

      expect(values, hasLength(1));
      expect(values.single, isNotNull);
      expect(values.single!.latitude, 48.9);
      expect(values.single!.longitude, 15.7);
    },
  );
}
