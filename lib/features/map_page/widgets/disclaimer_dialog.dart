import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_dialog_card.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Opens a focused dialog that shows *only* the potability disclaimer — the
/// fuller "what the app shows / marker legend" content lives in the About
/// dialog (zadání §12). Triggered by tapping the bottom disclaimer.
Future<void> showDisclaimerDialog(BuildContext context) {
  return showBlurredDialog<void>(
    context: context,
    child: const _DisclaimerCard(),
  );
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final l10n = context.l10n;

    return AppDialogCard(
      icon: Icons.warning_amber_rounded,
      iconColor: colors.secondaryVariant1,
      title: l10n.map_potability_disclaimer_title,
      maxWidth: 420,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.map_potability_disclaimer_body,
              style: text.body2.copyWith(color: colors.neutral700),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(l10n.map_potability_disclaimer_confirm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
