import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class InlineRetryMessage extends StatelessWidget {
  const InlineRetryMessage({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.appTextStyles;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: text.body2.copyWith(color: colors.neutral700),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onRetry,
          child: Text(context.l10n.error_widget_default_try_again),
        ),
      ],
    );
  }
}
