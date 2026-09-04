import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_scheme.dart';

/// Immutable, context-scoped custom color tokens.
class AppColors extends ThemeExtension<AppColors> implements AppColorsScheme {
  AppColors.fromScheme(AppColorsScheme scheme)
    : brightness = scheme.brightness,
      background = scheme.background,
      glassFill = scheme.glassFill,
      glassBorder = scheme.glassBorder,
      neutral900 = scheme.neutral900,
      neutral800 = scheme.neutral800,
      neutral700 = scheme.neutral700,
      neutral500 = scheme.neutral500,
      neutral300 = scheme.neutral300,
      neutral200 = scheme.neutral200,
      onNeutral = scheme.onNeutral,
      textHint = scheme.textHint,
      primary900 = scheme.primary900,
      primaryMain = scheme.primaryMain,
      primary100 = scheme.primary100,
      onPrimary = scheme.onPrimary,
      primaryInteractive = scheme.primaryInteractive,
      secondaryVariant1 = scheme.secondaryVariant1,
      secondaryBeige = scheme.secondaryBeige,
      onSecondary = scheme.onSecondary,
      error = scheme.error,
      errorText = scheme.errorText,
      onError = scheme.onError,
      verified = scheme.verified,
      saved = scheme.saved,
      statusFlowing = scheme.statusFlowing,
      markerRing = scheme.markerRing,
      statusNotFlowing = scheme.statusNotFlowing,
      statusStale = scheme.statusStale,
      statusUnknown = scheme.statusUnknown;

  const AppColors._({
    required this.brightness,
    required this.background,
    required this.glassFill,
    required this.glassBorder,
    required this.neutral900,
    required this.neutral800,
    required this.neutral700,
    required this.neutral500,
    required this.neutral300,
    required this.neutral200,
    required this.onNeutral,
    required this.textHint,
    required this.primary900,
    required this.primaryMain,
    required this.primary100,
    required this.onPrimary,
    required this.primaryInteractive,
    required this.secondaryVariant1,
    required this.secondaryBeige,
    required this.onSecondary,
    required this.error,
    required this.errorText,
    required this.onError,
    required this.verified,
    required this.saved,
    required this.statusFlowing,
    required this.markerRing,
    required this.statusNotFlowing,
    required this.statusStale,
    required this.statusUnknown,
  });

  @override
  final Brightness brightness;
  @override
  final Color background;
  @override
  final Color glassFill;
  @override
  final Color glassBorder;
  @override
  final Color neutral900;
  @override
  final Color neutral800;
  @override
  final Color neutral700;
  @override
  final Color neutral500;
  @override
  final Color neutral300;
  @override
  final Color neutral200;
  @override
  final Color onNeutral;
  @override
  final Color textHint;
  @override
  final Color primary900;
  @override
  final Color primaryMain;
  @override
  final Color primary100;
  @override
  final Color onPrimary;
  @override
  final Color primaryInteractive;
  @override
  final Color secondaryVariant1;
  @override
  final Color secondaryBeige;
  @override
  final Color onSecondary;
  @override
  final Color error;
  @override
  final Color errorText;
  @override
  final Color onError;
  @override
  final Color verified;
  @override
  final Color saved;
  @override
  final Color statusFlowing;
  @override
  final Color markerRing;
  @override
  final Color statusNotFlowing;
  @override
  final Color statusStale;
  @override
  final Color statusUnknown;

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    Color blend(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppColors._(
      brightness: t < 0.5 ? brightness : other.brightness,
      background: blend(background, other.background),
      glassFill: blend(glassFill, other.glassFill),
      glassBorder: blend(glassBorder, other.glassBorder),
      neutral900: blend(neutral900, other.neutral900),
      neutral800: blend(neutral800, other.neutral800),
      neutral700: blend(neutral700, other.neutral700),
      neutral500: blend(neutral500, other.neutral500),
      neutral300: blend(neutral300, other.neutral300),
      neutral200: blend(neutral200, other.neutral200),
      onNeutral: blend(onNeutral, other.onNeutral),
      textHint: blend(textHint, other.textHint),
      primary900: blend(primary900, other.primary900),
      primaryMain: blend(primaryMain, other.primaryMain),
      primary100: blend(primary100, other.primary100),
      onPrimary: blend(onPrimary, other.onPrimary),
      primaryInteractive: blend(primaryInteractive, other.primaryInteractive),
      secondaryVariant1: blend(secondaryVariant1, other.secondaryVariant1),
      secondaryBeige: blend(secondaryBeige, other.secondaryBeige),
      onSecondary: blend(onSecondary, other.onSecondary),
      error: blend(error, other.error),
      errorText: blend(errorText, other.errorText),
      onError: blend(onError, other.onError),
      verified: blend(verified, other.verified),
      saved: blend(saved, other.saved),
      statusFlowing: blend(statusFlowing, other.statusFlowing),
      markerRing: blend(markerRing, other.markerRing),
      statusNotFlowing: blend(statusNotFlowing, other.statusNotFlowing),
      statusStale: blend(statusStale, other.statusStale),
      statusUnknown: blend(statusUnknown, other.statusUnknown),
    );
  }
}
