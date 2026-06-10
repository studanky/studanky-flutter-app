import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/blurred_dialog.dart';

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

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Material(
        color: colors.onNeutral,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: colors.secondaryVariant1,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tekoucí voda ≠ pitná voda',
                      style: text.title1.copyWith(color: colors.neutral900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Aplikace informuje pouze o tom, zda je ve studánce hlášený tok '
                'vody. Neověřuje zdravotní nezávadnost ani pitnost vody. '
                'Užívání vody je na vlastní odpovědnost.',
                style: text.body2.copyWith(color: colors.neutral700),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(
                    'Rozumím',
                    style: text.button.copyWith(color: colors.primaryMain),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
