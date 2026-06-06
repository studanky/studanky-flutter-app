import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';

part 'user_location_provider.freezed.dart';

/// Permission / availability status of the user's location.
enum LocationStatus {
  idle,
  ready,
  denied,
  deniedForever,
  serviceOff,
}

final userLocationProvider =
    NotifierProvider.autoDispose<UserLocationNotifier, UserLocationState>(
      UserLocationNotifier.new,
    );

@freezed
abstract class UserLocationState with _$UserLocationState {
  const factory UserLocationState({
    @Default(LocationStatus.idle) LocationStatus status,
  }) = _UserLocationState;
}

class UserLocationNotifier extends Notifier<UserLocationState> {
  final Logger _logger = Logger('UserLocationNotifier');

  Stream<LocationMarkerPosition?>? _positionStream;
  Stream<LocationMarkerHeading?>? _headingStream;

  @override
  UserLocationState build() => const UserLocationState();

  /// The single shared position stream. Permission is requested exactly once,
  /// here – which is why it is also passed to [CurrentLocationLayer], so the
  /// layer does not issue its own (concurrent) request causing
  /// PermissionRequestInProgress.
  Stream<LocationMarkerPosition?> get positionStream =>
      _positionStream ??= _createPositionStream().asBroadcastStream();

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
    await for (final position in positionStream) {
      if (position != null) return position.latLng;
    }
    return null;
  }

  Stream<LocationMarkerPosition?> _createPositionStream() async* {
    if (!await Geolocator.isLocationServiceEnabled()) {
      _setStatus(LocationStatus.serviceOff);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _setStatus(LocationStatus.deniedForever);
      return;
    }
    if (permission == LocationPermission.denied) {
      _setStatus(LocationStatus.denied);
      return;
    }

    _setStatus(LocationStatus.ready);

    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    ).map(
      (position) => LocationMarkerPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      ),
    ).handleError((Object error, StackTrace stackTrace) {
      _logger.warning('Position stream error', error, stackTrace);
    });
  }

  void _setStatus(LocationStatus status) {
    if (ref.mounted) {
      state = state.copyWith(status: status);
    }
  }
}
