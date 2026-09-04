import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_dark.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_light.dart';

void main() {
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
}
