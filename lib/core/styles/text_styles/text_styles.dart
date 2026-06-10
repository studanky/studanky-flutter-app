import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography scale, rendered in Plus Jakarta Sans (the design typeface).
/// Colour is intentionally left unset so each style inherits from the
/// surrounding [DefaultTextStyle] / theme and adapts to light & dark.
class TextStyles {
  TextStyle h3 = GoogleFonts.plusJakartaSans(
    fontSize: 32.0,
    fontWeight: FontWeight.w500,
    height: 48 / 32,
    letterSpacing: -0.02,
  );

  TextStyle h4 = GoogleFonts.plusJakartaSans(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    letterSpacing: -0.02,
  );

  TextStyle h5 = GoogleFonts.plusJakartaSans(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 30 / 20,
  );

  TextStyle title1 = GoogleFonts.plusJakartaSans(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  TextStyle title2 = GoogleFonts.plusJakartaSans(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
  );

  TextStyle body1 = GoogleFonts.plusJakartaSans(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  TextStyle body2 = GoogleFonts.plusJakartaSans(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  TextStyle link = GoogleFonts.plusJakartaSans(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    decoration: TextDecoration.underline,
  );

  TextStyle button = GoogleFonts.plusJakartaSans(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.02,
  );
}
