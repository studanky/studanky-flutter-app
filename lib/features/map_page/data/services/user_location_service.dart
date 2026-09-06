import 'package:geolocator/geolocator.dart';

abstract interface class UserLocationService {
  Future<bool> isLocationServiceEnabled();

  Future<LocationPermission> checkPermission();

  Future<LocationPermission> requestPermission();

  Stream<Position> getPositionStream({
    required LocationSettings locationSettings,
  });
}
