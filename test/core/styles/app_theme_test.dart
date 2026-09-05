import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_dark.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_light.dart';
import 'package:studanky_flutter_app/core/styles/text_styles/text_styles.dart';
import 'package:studanky_flutter_app/core/styles/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  test('light and dark palettes own independent immutable tokens', () {
    final lightColors = AppColors.fromScheme(AppColorsLight());
    final darkColors = AppColors.fromScheme(AppColorsDark());

    expect(lightColors.brightness, Brightness.light);
    expect(darkColors.brightness, Brightness.dark);
    expect(lightColors.background, isNot(darkColors.background));
  });

  test('custom color tokens interpolate during theme transitions', () {
    final light = AppColors.fromScheme(AppColorsLight());
    final dark = AppColors.fromScheme(AppColorsDark());

    expect(light.lerp(dark, 0).background, light.background);
    expect(light.lerp(dark, 1).background, dark.background);
  });

  test('equivalent custom theme extensions have value equality', () {
    _withoutFontLoaderOutput(() {
      expect(
        AppColors.fromScheme(AppColorsLight()),
        AppColors.fromScheme(AppColorsLight()),
      );
      expect(TextStyles(), TextStyles());
    });
  });

  test('theme instances stay stable across app-root rebuilds', () {
    _withoutFontLoaderOutput(() {
      expect(AppTheme.light(), same(AppTheme.light()));
      expect(AppTheme.dark(), same(AppTheme.dark()));
    });
  });
}

T _withoutFontLoaderOutput<T>(T Function() body) {
  return runZoned(
    body,
    // The unit test intentionally constructs style objects without bundling a
    // font asset into the test target. Runtime fetching is disabled above; the
    // package reports that expected fallback through print(), which is outside
    // the equality behavior under test.
    zoneSpecification: ZoneSpecification(print: (_, _, _, _) {}),
  );
}
