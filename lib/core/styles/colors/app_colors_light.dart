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

  // Fill bumped from 55% so the floating glass controls read as a distinct
  // surface over busy/light map tiles instead of blending in — still clearly
  // translucent (you see the blurred map through it), just more defined.
  @override
  Color get glassFill => const Color(0xA6FFFFFF); // white @ 65%

  // Crisper top rim so the glass edge stays legible against light terrain.
  @override
  Color get glassBorder => const Color(0xD9FFFFFF); // white @ 85%

  @override
  Color get neutral900 => const Color(0xFF191A1A);

  @override
  Color get neutral800 => const Color(0xFF393A3A);

  @override
  Color get neutral700 => const Color(0xFF646767);

  @override
  Color get neutral500 => const Color(0xFFAAB2B4);

  // Darkest "light grey" that still clears WCAG AA (4.5:1+) on white *and* on
  // the 55% glass over the palest Mapy.cz tiles (measured 5.1:1 over forest
  // green, the worst case).
  @override
  Color get textHint => const Color(0xFF5A6468);

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
  Color get primary100 => const Color(0xFFCCE6F1);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  // One step deeper than the brand blue: white button labels on the brand
  // #0B97D2 only reach 3.3:1, this fill lifts them to 4.9:1 (WCAG AA for the
  // 14px button text) while staying unmistakably the same water blue.
  @override
  Color get primaryInteractive => const Color(0xFF0077B0);

  @override
  Color get secondaryVariant1 => const Color(0xFFD1750A);

  @override
  Color get secondaryBeige => const Color(0xFFFFF5E6);

  @override
  Color get onSecondary => const Color(0xFFFFFFFF);

  @override
  Color get error => const Color(0xFFEE5521);

  // The error hue as *text*: #EE5521 is icon-grade only (3.5:1 on white);
  // this deeper step reads at 5.1:1.
  @override
  Color get errorText => const Color(0xFFC93A10);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  // Trust green for the "verified · ČHMÚ" provenance badge — distinct from the
  // water-blue so official data reads as verified, not as a link/brand element.
  @override
  Color get verified => const Color(0xFF137A43);

  // Vivid gold for the "saved to My Springs" state — the conventional
  // "saved/starred" accent (Google's rating gold, Apple's favourites amber).
  // Deliberately below the 3:1 icon floor (~2.2:1 on white): the state is
  // carried by the glyph itself (filled vs. outline bookmark), so the colour
  // is a redundant enhancement — WCAG 1.4.11-safe. The deepest gold that
  // still reads "zářivá" rather than brown.
  @override
  Color get saved => const Color(0xFFF59E0B);

  // Spring status palette — distinct in hue *and* value so the marker reads at a
  // glance on a light map, with the glyph carrying the meaning for colour-blind
  // users. Stale is a cool desaturated slate (never the warm red of "not
  // flowing"); unknown is a plain grey shown as a hollow pin.
  @override
  Color get statusFlowing => const Color(0xFF0B97D2);

  // White in both themes — the ring separates pins from map tiles and must not
  // follow [onPrimary] (which is navy in dark mode).
  @override
  Color get markerRing => const Color(0xFFFFFFFF);

  @override
  Color get statusNotFlowing => const Color(0xFFEE5521);

  @override
  Color get statusStale => const Color(0xFF5F6B7A);
}
