import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/widgets/backdrop_blur_scope.dart';
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

  testWidgets('blur scope disables only the backdrop render operation', (
    tester,
  ) async {
    Future<void> pumpGlass({required bool blurEnabled}) => tester.pumpWidget(
      MaterialApp(
        home: BackdropGroup(
          child: BackdropBlurScope(
            enabled: blurEnabled,
            child: const GlassSurface(child: SizedBox(width: 40, height: 40)),
          ),
        ),
      ),
    );

    await pumpGlass(blurEnabled: false);
    var filter = tester.renderObject<RenderBackdropFilter>(
      find.byType(BackdropFilter),
    );
    final glassFill = find.descendant(
      of: find.byType(GlassSurface),
      matching: find.byType(ColoredBox),
    );
    expect(filter.enabled, isFalse);
    expect(glassFill, findsOneWidget);

    await pumpGlass(blurEnabled: true);
    filter = tester.renderObject<RenderBackdropFilter>(
      find.byType(BackdropFilter),
    );
    expect(filter.enabled, isTrue);
    expect(glassFill, findsOneWidget);
  });
}
