import 'package:flutter/material.dart';

abstract class AppColorsScheme {
  /// Brightness this scheme is designed for. Lets widgets that build their own
  /// translucent/blur effects (markers, glass panels) branch on the active
  /// theme without reaching for [MediaQuery].
  Brightness get brightness;

  /// App scaffold / map backdrop colour.
  Color get background;

  /// Translucent fill for floating "glass" panels (search bar, control
  /// buttons, zoom slider) layered over the map, used behind a backdrop blur.
  Color get glassFill;

  /// Hairline border that gives glass panels their edge highlight.
  Color get glassBorder;

  Color get neutral900;

  Color get neutral800;

  Color get neutral700;

  Color get neutral500;

  Color get neutral300;

  Color get neutral200;

  Color get onNeutral;

  Color get primary900;

  Color get primaryMain;

  Color get primary500;

  Color get primary200;

  Color get primary100;

  Color get primary50;

  Color get onPrimary;

  Color get secondaryVariant1;

  Color get secondaryVariant2;

  Color get secondaryBeige;

  Color get onSecondary;

  Color get terciaryPurple;

  Color get error;

  Color get onError;

  Color get success;

  Color get onSuccess;

  /// Accent for an authoritative "verified provenance" badge (official ČHMÚ
  /// station data). A trust green, kept deliberately distinct from the brand
  /// blue so "verified" never blends with primary actions or links.
  Color get verified;

  /// Accent for the "saved to My Springs" state — the filled bookmark in the
  /// detail and the list dialog's header icon. A warm gold (the classic
  /// "saved / bookmark / star" colour), kept distinct from the brand blue so
  /// "saved/mine" reads as its own thing.
  Color get saved;

  /// Spring status palette (zadání §6). Four legible, glyph-backed states:
  /// [statusFlowing] is the confident water-blue and [statusNotFlowing] the warm
  /// red, while [statusStale] (cool, desaturated slate) and [statusUnknown]
  /// (neutral grey, rendered as a hollow pin) read neutrally so they never look
  /// like a confident flow state.
  Color get statusFlowing;

  Color get statusNotFlowing;

  Color get statusStale;

  Color get statusUnknown;
}
