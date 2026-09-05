import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Animated bookmark control for the detail header.
class SpringFavoriteButton extends StatelessWidget {
  const SpringFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final icon = Icon(
      isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
      color: isFavorite ? colors.saved : colors.neutral700,
    );
    final animate = isFavorite && !MediaQuery.disableAnimationsOf(context);

    return IconButton(
      onPressed: onPressed,
      tooltip: isFavorite
          ? l10n.spring_detail_remove_favorite
          : l10n.spring_detail_add_favorite,
      icon: animate
          ? TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.6, end: 1),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: icon,
            )
          : icon,
    );
  }
}
