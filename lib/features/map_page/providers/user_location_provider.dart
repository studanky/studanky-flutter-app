import 'dart:async';

import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

part 'user_location_provider.freezed.dart';

/// Permission / availability status of the user's location.
enum LocationStatus { idle, ready, denied, deniedForever, serviceOff }

final userLocationServiceProvider = Provider<UserLocationService>(
  (_) => const GeolocatorUserLocationService(),
);

final userLocationProvider =
    NotifierProvider.autoDispose<UserLocationNotifier, UserLocationState>(
      UserLocationNotifier.new,
    );

abstract interface class UserLocationService {
  Future<bool> isLocationServiceEnabled();

  Future<LocationPermission> checkPermission();

  Future<LocationPermission> requestPermission();

  Stream<Position> getPositionStream({
    required LocationSettings locationSettings,
  });
}

class GeolocatorUserLocationService implements UserLocationService {
  const GeolocatorUserLocationService();

  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Stream<Position> getPositionStream({
    required LocationSettings locationSettings,
  }) => Geolocator.getPositionStream(locationSettings: locationSettings);
}

@freezed
abstract class UserLocationState with _$UserLocationState {
  const factory UserLocationState({
    @Default(LocationStatus.idle) LocationStatus status,
    @Default(false) bool activated,
  }) = _UserLocationState;
}

class UserLocationNotifier extends Notifier<UserLocationState> {
  final Logger _logger = Logger('UserLocationNotifier');

  StreamController<LocationMarkerPosition?>? _positionEventController;
  Stream<LocationMarkerPosition?>? _positionStream;
  StreamSubscription<Position>? _nativePositionSubscription;
  Future<void>? _positionFlow;
  Stream<LocationMarkerHeading?>? _headingStream;
  LatLng? _lastKnownPosition;
  LocationMarkerPosition? _lastKnownMarkerPosition;

  @override
  UserLocationState build() {
    ref.onDispose(() {
      unawaited(_nativePositionSubscription?.cancel());
      unawaited(_positionEventController?.close());
    });
    return const UserLocationState();
  }

  /// Most recent fix observed on [positionStream], or null before the first
  /// one. Lets the "my location" button recenter instantly without re-awaiting
  /// the stream.
  LatLng? get lastKnownPosition => _lastKnownPosition;

  /// The single shared position stream. Permission is requested only after
  /// [activate] / [firstFix], which keeps the OS prompt out of app startup and
  /// the legal onboarding. The stream replays the last known marker position to
  /// late subscribers so [CurrentLocationLayer] can be mounted after activation
  /// without waiting for the next GPS tick.
  Stream<LocationMarkerPosition?> get positionStream =>
      _positionStream ??= Stream<LocationMarkerPosition?>.multi((controller) {
        final last = _lastKnownMarkerPosition;
        if (last != null) controller.add(last);

        final events = _ensurePositionEventController();
        final subscription = events.stream.listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
        );
        controller.onCancel = () {
          unawaited(subscription.cancel());
        };

        if (ref.mounted && state.activated) _startPositionFlow();
      }, isBroadcast: true);

  /// Heading (compass). Intentionally an empty stream: this keeps the layer
  /// from subscribing to the rotation sensor, whose activation failure
  /// (typically on simulators and devices without the sensor) is reported by
  /// Flutter directly through FlutterError, so it cannot be caught via
  /// Stream.handleError. Nothing is lost without the heading wedge – the blue
  /// dot and the accuracy circle still work.
  Stream<LocationMarkerHeading?> get headingStream =>
      _headingStream ??= const Stream<LocationMarkerHeading?>.empty();

  /// Waits for the first valid position (for the initial map centering).
  /// Returns `null` if the stream ends without a position (denied / services
  /// off); the reason is then available in [UserLocationState.status].
  Future<LatLng?> firstFix() async {
    final stream = positionStream;
    activate();

    await for (final position in stream) {
      if (position != null) return position.latLng;
    }
    return null;
  }

  void activate() {
    if (!ref.mounted) return;

    final status = state.status == LocationStatus.ready
        ? LocationStatus.ready
        : LocationStatus.idle;
    state = state.copyWith(status: status, activated: true);
    _startPositionFlow();
  }

  /// Enables the location layer only when the OS permission was already granted.
  /// This never opens the platform prompt, so it is safe to call during map
  /// startup for returning users.
  Future<bool> activateIfPermissionGranted() async {
    final permission = await ref
        .read(userLocationServiceProvider)
        .checkPermission();
    if (!ref.mounted || !_hasLocationPermission(permission)) return false;

    activate();
    return true;
  }

  void _startPositionFlow() {
    if (!ref.mounted ||
        !state.activated ||
        _positionFlow != null ||
        _nativePositionSubscription != null) {
      return;
    }

    _ensurePositionEventController();
    late final Future<void> flow;
    flow = _runPositionFlow().whenComplete(() {
      if (identical(_positionFlow, flow)) _positionFlow = null;
    });
    _positionFlow = flow;
  }

  Future<void> _runPositionFlow() async {
    final service = ref.read(userLocationServiceProvider);

    if (!await service.isLocationServiceEnabled()) {
      _failLocationFlow(LocationStatus.serviceOff);
      return;
    }
    if (!ref.mounted || !state.activated) return;

    var permission = await service.checkPermission();
    if (!ref.mounted || !state.activated) return;

    if (permission == LocationPermission.denied) {
      permission = await service.requestPermission();
    }
    if (!ref.mounted || !state.activated) return;

    if (permission == LocationPermission.deniedForever) {
      _failLocationFlow(LocationStatus.deniedForever);
      return;
    }
    if (permission == LocationPermission.denied) {
      _failLocationFlow(LocationStatus.denied);
      return;
    }

    if (!_hasLocationPermission(permission)) {
      _failLocationFlow(LocationStatus.denied);
      return;
    }

    _setStatus(LocationStatus.ready, activated: true);

    _nativePositionSubscription = service
        .getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        )
        .listen(
          _emitPosition,
          onError: (Object error, StackTrace stackTrace) {
            _logger.warning('Position stream error', error, stackTrace);
          },
          onDone: () => _nativePositionSubscription = null,
        );
  }

  StreamController<LocationMarkerPosition?> _ensurePositionEventController() {
    final existing = _positionEventController;
    if (existing != null && !existing.isClosed) return existing;

    return _positionEventController =
        StreamController<LocationMarkerPosition?>.broadcast();
  }

  void _emitPosition(Position position) {
    final markerPosition = LocationMarkerPosition(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );
    _lastKnownPosition = markerPosition.latLng;
    _lastKnownMarkerPosition = markerPosition;

    final controller = _positionEventController;
    if (controller != null && !controller.isClosed) {
      controller.add(markerPosition);
    }
  }

  void _failLocationFlow(LocationStatus status) {
    _lastKnownPosition = null;
    _lastKnownMarkerPosition = null;
    _setStatus(status, activated: false);
    _resetPositionStreamForRetry();
  }

  void _resetPositionStreamForRetry() {
    unawaited(_nativePositionSubscription?.cancel());
    _nativePositionSubscription = null;
    _positionFlow = null;

    final controller = _positionEventController;
    _positionEventController = null;
    _positionStream = null;
    if (controller != null && !controller.isClosed) {
      unawaited(controller.close());
    }
  }

  bool _hasLocationPermission(LocationPermission permission) =>
      permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;

  void _setStatus(LocationStatus status, {bool? activated}) {
    if (ref.mounted) {
      state = state.copyWith(
        status: status,
        activated: activated ?? state.activated,
      );
    }
  }
}
