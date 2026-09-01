import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_zoom_slider.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

void main() {
  const initialZoom = 10.0;

  Future<List<double>> pumpSlider(WidgetTester tester) async {
    final emittedZooms = <double>[];

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: MapZoomSlider(
              zoom: initialZoom,
              minZoom: 5,
              maxZoom: 19,
              onChanged: emittedZooms.add,
              onStep: (_) {},
            ),
          ),
        ),
      ),
    );

    return emittedZooms;
  }

  testWidgets('dragging down zooms in like one-finger quick zoom', (
    tester,
  ) async {
    final emittedZooms = await pumpSlider(tester);

    await tester.drag(find.byType(GestureDetector), const Offset(0, 100));

    expect(emittedZooms, isNotEmpty);
    expect(emittedZooms.last, greaterThan(initialZoom));
  });

  testWidgets('dragging up zooms out like one-finger quick zoom', (
    tester,
  ) async {
    final emittedZooms = await pumpSlider(tester);

    await tester.drag(find.byType(GestureDetector), const Offset(0, -100));

    expect(emittedZooms, isNotEmpty);
    expect(emittedZooms.last, lessThan(initialZoom));
  });
}
