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

  /// Decorative-only grey (dividers, hairlines, disabled strokes). Too low in
  /// contrast for anything that must be read — never use it for text or for
  /// icons that carry meaning; that's what [textHint] and [neutral700] are for.
  Color get neutral500;

  Color get neutral300;

  Color get neutral200;

  Color get onNeutral;

  /// The lightest grey that still reads as text: placeholders/hints and
  /// de-emphasised helper copy. Tuned to clear WCAG AA (≥4.5:1) on the app's
  /// surfaces *including* the translucent glass panels over the map — unlike
  /// [neutral500], which is decoration-only.
  Color get textHint;

  /// Deep step of the primary ramp: accents over pale tints (empty-state
  /// icon, onPrimaryContainer).
  Color get primary900;

  /// The brand water blue — markers, clusters and decorative accents. For
  /// *text* roles use [primaryInteractive].
  Color get primaryMain;

  /// Pale tint of the primary — containers and soft icon coins.
  Color get primary100;

  Color get onPrimary;

  /// Primary hue in its *interactive text* role: button labels, filled-button
  /// backgrounds under [onPrimary] text, links. [primaryMain] is the brand
  /// accent for markers and icons (needs ≥3:1); text needs ≥4.5:1 (WCAG AA),
  /// which the brand blue doesn't reach on light surfaces — so interactive
  /// text/fills use this deeper step instead.
  Color get primaryInteractive;

  Color get secondaryVariant1;

  Color get secondaryBeige;

  Color get onSecondary;

  Color get error;

  /// [error] in its *text* role (inline validation, error copy). The error
  /// fill colour only reaches icon-level contrast (~3:1) on light surfaces;
  /// running text needs this deeper step to clear WCAG AA (≥4.5:1).
  Color get errorText;

  Color get onError;

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

  /// Ring around filled map pins and cluster badges. Stays white in both
  /// themes: its job is separating the pin from the map tiles (light tiles →
  /// white ring + shadow, dark tiles → white ring), independent of what
  /// [onPrimary] resolves to.
  Color get markerRing;

  Color get statusNotFlowing;

  Color get statusStale;

  /// "No data" pin colour. Intentionally the plain readable grey — one value,
  /// not a new hue — kept as its own token so call sites stay semantic.
  Color get statusUnknown => neutral700;
}
