import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

class LegalOnboardingBullet extends StatelessWidget {
  const LegalOnboardingBullet({
    super.key,
    required this.text,
    required this.accent,
  });

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: accent ? colors.secondaryVariant1 : colors.primaryMain,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: context.appTextStyles.body2.copyWith(
                color: colors.neutral800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
