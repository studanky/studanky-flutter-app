import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_dark.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_light.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_scheme.dart';

/// Builds the app's light and dark [ThemeData] from the shared
/// [AppColorsScheme] tokens, using Plus Jakarta Sans (the design typeface).
///
/// These [ThemeData]s drive Material widgets; the `Styles.appColors` singleton
/// is kept in sync separately (see the `MaterialApp.builder` in main.dart) so
/// hand-rolled widgets read the same palette.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColorsLight());

  static ThemeData dark() => _build(AppColorsDark());

  static ThemeData _build(AppColorsScheme c) {
    final isDark = c.brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: c.brightness,
      primary: c.primaryMain,
      onPrimary: c.onPrimary,
      primaryContainer: c.primary100,
      onPrimaryContainer: c.primary900,
      secondary: c.secondaryVariant1,
      onSecondary: c.onSecondary,
      secondaryContainer: c.secondaryBeige,
      onSecondaryContainer: c.secondaryVariant1,
      tertiary: c.terciaryPurple,
      onTertiary: c.neutral900,
      error: c.error,
      onError: c.onError,
      surface: c.onNeutral,
      onSurface: c.neutral900,
      surfaceContainerHighest: c.neutral200,
      onSurfaceVariant: c.neutral700,
      outline: c.neutral500,
      outlineVariant: c.neutral300,
      shadow: const Color(0xFF000000),
    );

    final baseTextTheme = isDark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      baseTextTheme,
    ).apply(bodyColor: c.neutral900, displayColor: c.neutral900);

    return ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: c.neutral700),
      splashFactory: InkSparkle.splashFactory,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.neutral900,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: c.onNeutral),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.primaryMain),
    );
  }
}
