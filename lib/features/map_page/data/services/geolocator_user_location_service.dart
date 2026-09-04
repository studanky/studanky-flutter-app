import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:studanky_flutter_app/features/map_page/data/services/user_location_service.dart';

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

final userLocationServiceProvider = Provider<UserLocationService>(
  (_) => const GeolocatorUserLocationService(),
);
