import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/legal/legal_config.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_dialog_card.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/legal/providers/legal_onboarding_provider.dart';
import 'package:studanky_flutter_app/features/legal/widgets/legal_link_button.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

Future<void> showLegalOnboardingDialog(BuildContext context) {
  return showBlurredDialog<void>(
    context: context,
    barrierDismissible: false,
    child: const PopScope(canPop: false, child: _LegalOnboardingCard()),
  );
}

class _LegalOnboardingCard extends ConsumerStatefulWidget {
  const _LegalOnboardingCard();

  @override
  ConsumerState<_LegalOnboardingCard> createState() =>
      _LegalOnboardingCardState();
}

class _LegalOnboardingCardState extends ConsumerState<_LegalOnboardingCard> {
  late final PageController _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    unawaited(
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Future<void> _finish() async {
    await ref.read(legalOnboardingProvider.notifier).acknowledge();
    if (!mounted) return;
    unawaited(Navigator.of(context).maybePop());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLast = _index == _steps(context).length - 1;

    return AppDialogCard(
      icon: Icons.water_drop_rounded,
      title: l10n.legal_onboarding_title,
      showHeader: false,
      showCloseButton: false,
      maxWidth: 560,
      maxHeightFactor: 0.94,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SizedBox(
              height: 500,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _index = index),
                children: _steps(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              children: [
                _Dots(count: _steps(context).length, index: _index),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _index == 0 ? null : () => _goTo(_index - 1),
                        child: Text(l10n.legal_onboarding_back),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: isLast ? _finish : () => _goTo(_index + 1),
                        child: Text(
                          isLast
                              ? l10n.legal_onboarding_finish
                              : l10n.legal_onboarding_next,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _steps(BuildContext context) {
    final l10n = context.l10n;

    return [
      _OnboardingStep(
        icon: Icons.volunteer_activism_rounded,
        title: l10n.legal_onboarding_step_welcome_title,
        body: l10n.legal_onboarding_step_welcome_body,
        bullets: [
          l10n.legal_onboarding_step_welcome_bullet_community,
          l10n.legal_onboarding_step_welcome_bullet_feedback,
        ],
        child: LegalLinkButton(
          icon: Icons.public_rounded,
          label: l10n.legal_onboarding_website_link,
          uri: LegalConfig.websiteUrl,
        ),
      ),
      _OnboardingStep(
        icon: Icons.warning_amber_rounded,
        title: l10n.legal_onboarding_step_water_title,
        body: l10n.legal_onboarding_step_water_body,
        bullets: [
          l10n.legal_onboarding_step_water_bullet_flow,
          l10n.legal_onboarding_step_water_bullet_marked,
          l10n.legal_onboarding_step_water_bullet_quality,
        ],
        accent: true,
      ),
    ];
  }
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({
    required this.icon,
    required this.title,
    required this.body,
    this.bullets = const [],
    this.child,
    this.accent = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final List<String> bullets;
  final Widget? child;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
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
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(kRadiusControl),
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
                _Bullet(text: bullet, accent: accent),
            ],
            if (child != null) ...[const SizedBox(height: 12), child!],
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.accent});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

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
              style: Styles.textStyles.body2.copyWith(color: colors.neutral800),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: i == index ? 18 : 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: i == index ? colors.primaryMain : colors.neutral300,
              borderRadius: BorderRadius.circular(kRadiusPill),
            ),
          ),
      ],
    );
  }
}
