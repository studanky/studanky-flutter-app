import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/map_control_stack.dart';
import 'package:studanky_flutter_app/l10n/app_localizations.dart';

void main() {
  testWidgets('location control emphasizes only the centered north-up state', (
    tester,
  ) async {
    final previousBrightness = AppColors().brightness;
    AppColors().setBrightness(Brightness.light);
    addTearDown(() => AppColors().setBrightness(previousBrightness));

    Future<void> pumpControl({
      required bool centered,
      double rotationRad = 0,
    }) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MapControlStack(
            locationStatus: LocationStatus.ready,
            isLocating: false,
            rotationRad: rotationRad,
            centered: centered,
            onLocation: () {},
            onFavorites: () {},
            onHelp: () {},
          ),
        ),
      ),
    );

    GlassSurface locationSurface() =>
        tester.widgetList<GlassSurface>(find.byType(GlassSurface)).last;

    await pumpControl(centered: true);

    expect(
      tester.widget<Icon>(find.byIcon(Icons.navigation_rounded)).color,
      Styles.appColors.primaryMain,
    );
    expect(
      locationSurface().fill,
      Styles.appColors.onNeutral.withValues(alpha: 0.92),
    );

    await pumpControl(centered: false);

    expect(
      tester.widget<Icon>(find.byIcon(Icons.navigation_outlined)).color,
      Styles.appColors.neutral700,
    );
    expect(locationSurface().fill, isNull);

    await pumpControl(centered: true, rotationRad: math.pi / 4);

    expect(
      tester.widget<Icon>(find.byIcon(Icons.navigation_outlined)).color,
      Styles.appColors.errorText,
    );
    expect(locationSurface().fill, isNull);
  });
}
