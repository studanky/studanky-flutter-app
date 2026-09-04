import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_dark.dart';
import 'package:studanky_flutter_app/core/styles/colors/app_colors_light.dart';
import 'package:studanky_flutter_app/core/styles/text_styles/text_styles.dart';

extension AppStylesContext on BuildContext {
  AppColors get appColors {
    final colors = Theme.of(this).extension<AppColors>();
    if (colors != null) return colors;
    final fallback = Theme.of(this).brightness == Brightness.dark
        ? AppColorsDark()
        : AppColorsLight();
    return AppColors.fromScheme(fallback);
  }

  TextStyles get appTextStyles {
    final styles = Theme.of(this).extension<TextStyles>();
    return styles ?? TextStyles();
  }
}
