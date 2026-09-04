import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography scale, scoped through [ThemeData.extensions].
class TextStyles extends ThemeExtension<TextStyles> {
  TextStyles()
    : h3 = GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 48 / 32,
        letterSpacing: -0.02,
      ),
      h4 = GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 32 / 24,
        letterSpacing: -0.02,
      ),
      h5 = GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 30 / 20,
      ),
      title1 = GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      ),
      title2 = GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
      ),
      body1 = GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      ),
      body2 = GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      ),
      link = GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        decoration: TextDecoration.underline,
      ),
      button = GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.02,
      );

  const TextStyles._({
    required this.h3,
    required this.h4,
    required this.h5,
    required this.title1,
    required this.title2,
    required this.body1,
    required this.body2,
    required this.link,
    required this.button,
  });

  final TextStyle h3;
  final TextStyle h4;
  final TextStyle h5;
  final TextStyle title1;
  final TextStyle title2;
  final TextStyle body1;
  final TextStyle body2;
  final TextStyle link;
  final TextStyle button;

  @override
  TextStyles copyWith() => this;

  @override
  TextStyles lerp(covariant TextStyles? other, double t) {
    if (other == null) return this;
    return TextStyles._(
      h3: TextStyle.lerp(h3, other.h3, t)!,
      h4: TextStyle.lerp(h4, other.h4, t)!,
      h5: TextStyle.lerp(h5, other.h5, t)!,
      title1: TextStyle.lerp(title1, other.title1, t)!,
      title2: TextStyle.lerp(title2, other.title2, t)!,
      body1: TextStyle.lerp(body1, other.body1, t)!,
      body2: TextStyle.lerp(body2, other.body2, t)!,
      link: TextStyle.lerp(link, other.link, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
    );
  }
}
