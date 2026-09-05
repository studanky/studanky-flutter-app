import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/platform_config/entities/spring_icon.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/spring_detail_header.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

void main() {
  const springName = 'Pramen U Tří lip';
  const springDescription =
      'Historický pramen s chladnou vodou nedaleko lesní cesty.';

  Future<void> pumpHeader(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SpringDetailHeader(
              name: springName,
              statusIcon: SpringIcon.flowing,
              statusUpdatedAt: null,
              position: const LatLng(50.0755, 14.4378),
              description: springDescription,
              flowScale: null,
              flowRateLps: null,
              clarity: null,
              maxFlowScale: 5,
              onShare: () {},
              onNavigate: () {},
              onCopyCoordinates: () {},
              isFavorite: false,
              onToggleFavorite: () {},
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doubleTapText(WidgetTester tester, Finder textFinder) async {
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(of: textFinder, matching: find.byType(RichText)),
    );
    final firstCharacterBox = paragraph
        .getBoxesForSelection(
          const TextSelection(baseOffset: 0, extentOffset: 1),
        )
        .single
        .toRect();
    final tapPosition = paragraph.localToGlobal(firstCharacterBox.center);
    final gesture = await tester.startGesture(tapPosition);
    addTearDown(gesture.removePointer);

    await gesture.up();
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.down(tapPosition);
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
  }

  testWidgets('name and description use separate native selection areas', (
    tester,
  ) async {
    await pumpHeader(tester);

    final nameSelectionArea = find.ancestor(
      of: find.text(springName),
      matching: find.byType(SelectionArea),
    );
    final descriptionSelectionArea = find.ancestor(
      of: find.text(springDescription),
      matching: find.byType(SelectionArea),
    );

    expect(nameSelectionArea, findsOneWidget);
    expect(descriptionSelectionArea, findsOneWidget);
    expect(find.byType(SelectionArea), findsNWidgets(2));

    // No custom menu is supplied: SelectionArea's default builder uses the
    // platform-adaptive Material/Cupertino text selection toolbar.
    expect(
      tester.widget<SelectionArea>(nameSelectionArea).contextMenuBuilder,
      isNotNull,
    );
    expect(
      tester.widget<SelectionArea>(descriptionSelectionArea).contextMenuBuilder,
      isNotNull,
    );
  });

  testWidgets(
    'double tap selects title text and offers copy',
    (tester) async {
      await pumpHeader(tester);

      await doubleTapText(tester, find.text(springName));

      final copyLabel = MaterialLocalizations.of(
        tester.element(find.text(springName)),
      ).copyButtonLabel;
      expect(find.byType(AdaptiveTextSelectionToolbar), findsOneWidget);
      expect(find.text(copyLabel), findsOneWidget);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets(
    'double tap selects description text and offers copy',
    (tester) async {
      await pumpHeader(tester);

      await doubleTapText(tester, find.text(springDescription));

      final copyLabel = MaterialLocalizations.of(
        tester.element(find.text(springDescription)),
      ).copyButtonLabel;
      expect(find.byType(AdaptiveTextSelectionToolbar), findsOneWidget);
      expect(find.text(copyLabel), findsOneWidget);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );
}
