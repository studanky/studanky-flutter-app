import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

class LegalOnboardingProgressDots extends StatelessWidget {
  const LegalOnboardingProgressDots({
    super.key,
    required this.count,
    required this.index,
  });

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var dotIndex = 0; dotIndex < count; dotIndex++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: dotIndex == index ? 18 : 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: dotIndex == index ? colors.primaryMain : colors.neutral300,
              borderRadius: BorderRadius.circular(kRadiusPill),
            ),
          ),
      ],
    );
  }
}
