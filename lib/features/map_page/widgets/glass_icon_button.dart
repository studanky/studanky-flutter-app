import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';

/// Circular frosted-glass map control with an accessible tap target.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.fill,
  });

  static const double _diameter = 44;

  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GlassSurface(
        borderRadius: const BorderRadius.all(Radius.circular(_diameter / 2)),
        fill: fill,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: _diameter,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
