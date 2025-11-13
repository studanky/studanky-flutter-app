import 'package:flutter/material.dart';

class TextStyles {
  TextStyle h3 = const TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w500,
    height: 48 / 32,
    letterSpacing: -0.02,
  );

  TextStyle h4 = const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    letterSpacing: -0.02,
  );

  TextStyle h5 = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 30 / 20,
  );

  TextStyle title1 = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  TextStyle title2 = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
  );

  TextStyle body1 = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  TextStyle body2 = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  TextStyle link = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    decoration: TextDecoration.underline,
  );

  TextStyle button = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.02,
  );
}
