import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';

/// Shows a frosted-glass snackbar that matches the app's glass language (search
/// bar, controls) instead of the default solid bar: a transparent [SnackBar]
/// whose content is a [GlassSurface], so the bar frosts whatever is behind it.
/// An optional action sits inline inside the same glass pill.
void showGlassSnackBar(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        content: _GlassSnackBarContent(
          message: message,
          actionLabel: actionLabel,
          onAction: onAction == null
              ? null
              : () {
                  messenger.hideCurrentSnackBar();
                  onAction();
                },
        ),
      ),
    );
}

class _GlassSnackBarContent extends StatelessWidget {
  const _GlassSnackBarContent({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final hasAction = actionLabel != null && onAction != null;

    return GlassSurface(
      borderRadius: BorderRadius.circular(kRadiusButton),
      padding: EdgeInsets.fromLTRB(16, 12, hasAction ? 8 : 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: text.body2.copyWith(color: colors.neutral900),
            ),
          ),
          if (hasAction) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
