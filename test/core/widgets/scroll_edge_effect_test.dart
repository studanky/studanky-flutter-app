import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';

void main() {
  testWidgets('shows edge effects only for overflowing content', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 320,
          height: 200,
          child: ScrollEdgeEffect(
            child: ListView.builder(
              itemExtent: 40,
              itemCount: 2,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(_edgeOpacities(tester), const [0, 0]);
  });

  testWidgets('updates top and bottom edge visibility while scrolling', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 320,
          height: 200,
          child: ScrollEdgeEffect(
            child: ListView.builder(
              itemExtent: 40,
              itemCount: 20,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(_edgeOpacities(tester), const [0, 1]);

    await tester.drag(find.byType(ListView), const Offset(0, -120));
    await tester.pump();

    expect(_edgeOpacities(tester), const [1, 1]);
  });
}

List<double> _edgeOpacities(WidgetTester tester) {
  return tester
      .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
      .map((widget) => widget.opacity)
      .toList(growable: false);
}
