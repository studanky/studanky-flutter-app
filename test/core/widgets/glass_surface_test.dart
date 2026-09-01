import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';

void main() {
  testWidgets('glass surfaces share the nearest backdrop group', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BackdropGroup(
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassSurface(child: SizedBox(width: 40, height: 40)),
              GlassSurface(child: SizedBox(width: 40, height: 40)),
            ],
          ),
        ),
      ),
    );

    final filters = find.byType(BackdropFilter);
    expect(filters, findsNWidgets(2));

    final first = tester.renderObject<RenderBackdropFilter>(filters.first);
    final second = tester.renderObject<RenderBackdropFilter>(filters.last);

    expect(first.backdropKey, isNotNull);
    expect(second.backdropKey, same(first.backdropKey));
  });

  testWidgets('glass surface still works without a backdrop group', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GlassSurface(child: SizedBox(width: 40, height: 40)),
      ),
    );

    final filter = tester.renderObject<RenderBackdropFilter>(
      find.byType(BackdropFilter),
    );
    expect(filter.backdropKey, isNull);
  });
}
