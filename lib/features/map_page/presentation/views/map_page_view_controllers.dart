import 'package:flutter/foundation.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_backdrop_blur_controller.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_camera_coordinator.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/user_location_controller.dart';

/// Long-lived controllers owned by the map page's stateful host.
@immutable
class MapPageViewControllers {
  const MapPageViewControllers({
    required this.camera,
    required this.backdropBlur,
    required this.location,
  });

  final MapCameraCoordinator camera;
  final MapBackdropBlurController backdropBlur;
  final UserLocationNotifier location;
}
