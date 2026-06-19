import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_scheme.dart';

/// Dark theme — deep "night water" palette. Token *roles* match the light
/// scheme (e.g. [neutral900] is still the strongest text, [onNeutral] is still
/// the surface/card colour) so every existing `Styles.appColors.xxx` usage
/// renders correctly without changes — only the values flip for a dark surface.
class AppColorsDark extends AppColorsScheme {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  Color get background => const Color(0xFF0A1628);

  @override
  Color get glassFill => const Color(0x8C081228); // deep navy @ 55%

  @override
  Color get glassBorder => const Color(0x1AFFFFFF); // white @ 10%

  // Text / neutral ramp — inverted: 900 is the brightest text on dark.
  @override
  Color get neutral900 => const Color(0xFFE8EFF7);

  @override
  Color get neutral800 => const Color(0xFFC7D5E4);

  @override
  Color get neutral700 => const Color(0xFF93A9C0);

  @override
  Color get neutral500 => const Color(0xFF647E99);

  @override
  Color get neutral300 => const Color(0xFF24385A);

  @override
  Color get neutral200 => const Color(0xFF16243C);

  // Surface / card colour layered above [background].
  @override
  Color get onNeutral => const Color(0xFF0F1F38);

  @override
  Color get primary900 => const Color(0xFF0E3A57);

  @override
  Color get primaryMain => const Color(0xFF38BDF8);

  @override
  Color get primary500 => const Color(0xFF60C1EE);

  @override
  Color get primary200 => const Color(0xFF2A5170);

  @override
  Color get primary100 => const Color(0xFF173049);

  @override
  Color get primary50 => const Color(0xFF0F2236);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  @override
  Color get secondaryVariant1 => const Color(0xFFD9851A);

  @override
  Color get secondaryVariant2 => const Color(0xFF5A3A1E);

  @override
  Color get secondaryBeige => const Color(0xFF2A2113);

  @override
  Color get onSecondary => const Color(0xFFFFFFFF);

  @override
  Color get terciaryPurple => const Color(0xFF2A2138);

  @override
  Color get error => const Color(0xFFFF6B4A);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  @override
  Color get success => const Color(0xFF5FA85A);

  @override
  Color get onSuccess => const Color(0xFFFFFFFF);

  // Trust green for the "verified · ČHMÚ" badge, brightened for dark surfaces.
  @override
  Color get verified => const Color(0xFF5FC97D);

  // Vivid gold for the "saved to My Springs" state.
  @override
  Color get saved => const Color(0xFFFBBF24);

  // Spring status palette, brightened for the inverted dark map. Roles match the
  // light scheme: confident blue / warm red for flow, cool slate for stale and
  // neutral grey for the hollow unknown pin.
  @override
  Color get statusFlowing => const Color(0xFF38BDF8);

  @override
  Color get statusNotFlowing => const Color(0xFFFF6B4A);

  @override
  Color get statusStale => const Color(0xFF7E93AD);

  @override
  Color get statusUnknown => const Color(0xFF93A9C0);
}
