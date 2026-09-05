import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/shapes.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/legal/presentation/widgets/legal_onboarding_bullet.dart';

class LegalOnboardingStep extends StatelessWidget {
  const LegalOnboardingStep({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.bullets = const [],
    this.accent = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final List<String> bullets;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.appTextStyles;
    final iconColor = accent ? colors.secondaryVariant1 : colors.primaryMain;
    final iconBackground = accent ? colors.secondaryBeige : colors.primary100;

    return ScrollEdgeEffect(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: ShapeDecoration(
                color: iconBackground,
                shape: squircleBorder(kRadiusControl),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 18),
            Text(title, style: text.h5.copyWith(color: colors.neutral900)),
            const SizedBox(height: 10),
            Text(body, style: text.body1.copyWith(color: colors.neutral700)),
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 16),
              for (final bullet in bullets)
                LegalOnboardingBullet(text: bullet, accent: accent),
            ],
          ],
        ),
      ),
    );
  }
}
