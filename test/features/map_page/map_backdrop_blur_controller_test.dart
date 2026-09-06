import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_backdrop_blur_controller.dart';

void main() {
  testWidgets('restores blur only after the final camera update', (
    tester,
  ) async {
    const delay = Duration(milliseconds: 120);
    final controller = MapBackdropBlurController(resumeDelay: delay);
    addTearDown(controller.dispose);

    var notifications = 0;
    controller
      ..addListener(() => notifications++)
      ..onCameraMoved();
    expect(controller.value, isFalse);
    expect(notifications, 1);

    await tester.pump(const Duration(milliseconds: 80));
    controller.onCameraMoved();
    expect(controller.value, isFalse);
    expect(notifications, 1);

    await tester.pump(const Duration(milliseconds: 80));
    expect(controller.value, isFalse);

    await tester.pump(const Duration(milliseconds: 40));
    expect(controller.value, isTrue);
    expect(notifications, 2);
  });
}
