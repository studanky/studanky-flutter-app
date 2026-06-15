import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/surface_card.dart';

/// Shared shell for the app's centred floating dialogs (About, Disclaimer,
/// Favourites) shown over the blurred backdrop. One [SurfaceCard] with a
/// standard header — icon · title · optional trailing · close — so every dialog
/// reads as the same component. Bottom sheets stay reserved for the spring
/// detail (zadání §9, §10).
class AppDialogCard extends StatelessWidget {
  const AppDialogCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.iconColor,
    this.trailing,
    this.dividerUnderHeader = false,
    this.maxWidth = 460,
    this.maxHeightFactor = 0.8,
  });

  final IconData icon;
  final String title;

  /// Body of the dialog. Owns its own scroll/padding so it can be a scroll view,
  /// a flexible list or a short fixed block.
  final Widget child;

  /// Header glyph tint; defaults to the primary blue.
  final Color? iconColor;

  /// Optional widget shown just before the close button (e.g. an item count).
  final Widget? trailing;

  final bool dividerUnderHeader;
  final double maxWidth;
  final double maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFactor;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SurfaceCard(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
                child: Row(
                  children: [
                    Icon(icon, color: iconColor ?? colors.primaryMain, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: text.h5.copyWith(color: colors.neutral900),
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      trailing!,
                    ],
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: colors.neutral700),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),
              if (dividerUnderHeader) const Divider(height: 1),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
