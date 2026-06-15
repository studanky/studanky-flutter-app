import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_dark.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_light.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_scheme.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';

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

    // Single source of truth for button shape/typography so every button in the
    // app (Navigovat, Sdílet, Rozumím, Zkusit znovu…) reads identically.
    final buttonTextStyle = GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 20 / 14,
      letterSpacing: 0.02,
    );
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kRadiusButton),
    );
    const buttonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    const buttonMinSize = Size(0, 48);

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusButton),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.primaryMain),
      dividerTheme: DividerThemeData(
        color: c.neutral200,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.primaryMain,
          foregroundColor: c.onPrimary,
          textStyle: buttonTextStyle,
          shape: buttonShape,
          padding: buttonPadding,
          minimumSize: buttonMinSize,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primaryMain,
          foregroundColor: c.onPrimary,
          elevation: 0,
          textStyle: buttonTextStyle,
          shape: buttonShape,
          padding: buttonPadding,
          minimumSize: buttonMinSize,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary900,
          side: BorderSide(color: c.neutral300),
          textStyle: buttonTextStyle,
          shape: buttonShape,
          padding: buttonPadding,
          minimumSize: buttonMinSize,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primaryMain,
          textStyle: buttonTextStyle,
          shape: buttonShape,
        ),
      ),
    );
  }
}
