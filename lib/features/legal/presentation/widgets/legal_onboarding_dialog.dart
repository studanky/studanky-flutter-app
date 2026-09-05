import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/widgets/app_dialog_card.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/features/legal/presentation/widgets/legal_onboarding_progress_dots.dart';
import 'package:studanky_flutter_app/features/legal/presentation/widgets/legal_onboarding_step.dart';
import 'package:studanky_flutter_app/features/legal/providers/legal_onboarding_provider.dart';
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
    Navigator.of(context).pop();
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
                LegalOnboardingProgressDots(
                  count: _steps(context).length,
                  index: _index,
                ),
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
      LegalOnboardingStep(
        icon: Icons.volunteer_activism_rounded,
        title: l10n.legal_onboarding_step_welcome_title,
        body: l10n.legal_onboarding_step_welcome_body,
        bullets: [
          l10n.legal_onboarding_step_welcome_bullet_community,
          l10n.legal_onboarding_step_welcome_bullet_feedback,
        ],
      ),
      LegalOnboardingStep(
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
