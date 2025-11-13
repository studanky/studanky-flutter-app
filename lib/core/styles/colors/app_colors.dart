import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_dark.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_light.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_scheme.dart';

class AppColors implements AppColorsScheme {
  factory AppColors() {
    return _appColors;
  }
  AppColors._internal();
  static final AppColors _appColors = AppColors._internal();

  AppColorsScheme _currentScheme = AppColorsLight();

  // This method is never called in the app yet
  void setTheme(ThemeMode themeMode) {
    _currentScheme = themeMode == ThemeMode.dark
        ? AppColorsDark()
        : AppColorsLight();
  }

  @override
  Color get neutral900 => _currentScheme.neutral900;

  @override
  Color get neutral800 => _currentScheme.neutral800;

  @override
  Color get neutral700 => _currentScheme.neutral700;

  @override
  Color get neutral500 => _currentScheme.neutral500;

  @override
  Color get neutral300 => _currentScheme.neutral300;

  @override
  Color get neutral200 => _currentScheme.neutral200;

  @override
  Color get onNeutral => _currentScheme.onNeutral;

  @override
  Color get primary900 => _currentScheme.primary900;

  @override
  Color get primaryMain => _currentScheme.primaryMain;

  @override
  Color get primary500 => _currentScheme.primary500;

  @override
  Color get primary200 => _currentScheme.primary200;

  @override
  Color get primary100 => _currentScheme.primary100;

  @override
  Color get primary50 => _currentScheme.primary50;

  @override
  Color get onPrimary => _currentScheme.onPrimary;

  @override
  Color get secondaryVariant1 => _currentScheme.secondaryVariant1;

  @override
  Color get secondaryVariant2 => _currentScheme.secondaryVariant2;

  @override
  Color get secondaryBeige => _currentScheme.secondaryBeige;

  @override
  Color get onSecondary => _currentScheme.onSecondary;

  @override
  Color get terciaryPurple => _currentScheme.terciaryPurple;

  @override
  Color get error => _currentScheme.error;

  @override
  Color get onError => _currentScheme.onError;

  @override
  Color get success => _currentScheme.success;

  @override
  Color get onSuccess => _currentScheme.onSuccess;
}
