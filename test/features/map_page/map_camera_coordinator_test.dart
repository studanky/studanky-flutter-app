import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_camera_coordinator.dart';

void main() {
  test('disposes its externally-owned map controller', () async {
    final coordinator = MapCameraCoordinator(
      vsync: const TestVSync(),
      initialDetailSheetExtent: 0.5,
    );
    final streamDone = expectLater(
      coordinator.mapController.mapEventStream,
      emitsDone,
    );

    coordinator.dispose();

    await streamDone;
  });
}
