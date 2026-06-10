import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_scheme.dart';

/// Light theme — premium "daylight on water" palette (sky blue), tuned for
/// outdoor readability over a light map. Token roles are *semantic*: e.g.
/// [neutral900] is the strongest text, [onNeutral] is the surface/card colour.
class AppColorsLight extends AppColorsScheme {
  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get background => const Color(0xFFF0F4F8);

  @override
  Color get glassFill => const Color(0x8CFFFFFF); // white @ 55%

  @override
  Color get glassBorder => const Color(0xBFFFFFFF); // white @ 75%

  @override
  Color get neutral900 => const Color(0xFF191A1A);

  @override
  Color get neutral800 => const Color(0xFF393A3A);

  @override
  Color get neutral700 => const Color(0xFF646767);

  @override
  Color get neutral500 => const Color(0xFFAAB2B4);

  @override
  Color get neutral300 => const Color(0xFFE4E9EA);

  @override
  Color get neutral200 => const Color(0xFFF4F4F4);

  @override
  Color get onNeutral => const Color(0xFFFFFFFF);

  @override
  Color get primary900 => const Color(0xFF255C83);

  @override
  Color get primaryMain => const Color(0xFF0B97D2);

  @override
  Color get primary500 => const Color(0xFF60C1EE);

  @override
  Color get primary200 => const Color(0xFF94D4EF);

  @override
  Color get primary100 => const Color(0xFFCCE6F1);

  @override
  Color get primary50 => const Color(0xFFEAF6FC);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  @override
  Color get secondaryVariant1 => const Color(0xFFD1750A);

  @override
  Color get secondaryVariant2 => const Color(0xFFFFD4B1);

  @override
  Color get secondaryBeige => const Color(0xFFFFF5E6);

  @override
  Color get onSecondary => const Color(0xFFFFFFFF);

  @override
  Color get terciaryPurple => const Color(0xFFF7E7FF);

  @override
  Color get error => const Color(0xFFEE5521);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  @override
  Color get success => const Color(0xFF477F42);

  @override
  Color get onSuccess => const Color(0xFFFFFFFF);
}
