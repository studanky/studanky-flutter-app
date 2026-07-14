import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Left vertical stack of floating glass controls over the map (zadání §7),
/// ordered as help, favourites, then compass/location. The right edge is
/// reserved for the zoom slider.
class MapControlStack extends StatelessWidget {
  const MapControlStack({
    super.key,
    required this.locationStatus,
    required this.isLocating,
    required this.rotationRad,
    required this.centered,
    required this.onLocation,
    required this.onFavorites,
    required this.onHelp,
  });

  final LocationStatus locationStatus;
  final bool isLocating;
  final double rotationRad;
  final bool centered;
  final VoidCallback onLocation;
  final VoidCallback onFavorites;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final l10n = context.l10n;

    // The location/compass control has one job at a time. Rotation wins: if
    // north is not up, the red outlined navigation arrow means "tap to reset
    // north" regardless of location centering. With north already up, the same
    // glyph becomes a location state: filled blue when centered, neutral
    // outline when not.
    //
    // Top → bottom: help · favourites · location/compass.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassIconButton(
          semanticLabel: l10n.map_help,
          onTap: onHelp,
          child: Icon(
            Icons.help_outline_rounded,
            size: 20,
            color: colors.neutral700,
          ),
        ),
        const SizedBox(height: 10),
        GlassIconButton(
          semanticLabel: l10n.map_favorites,
          onTap: onFavorites,
          // Entry to "Moje studánky" (my saved list). A neutral glass tile like
          // the others — the outline bookmark alone carries the "saved list"
          // meaning (no fill, no count badge), so the control stack stays calm.
          child: Icon(
            Icons.bookmark_border_rounded,
            size: 20,
            color: colors.neutral700,
          ),
        ),
        const SizedBox(height: 10),
        GlassIconButton(
          semanticLabel: l10n.map_my_location,
          onTap: isLocating ? null : onLocation,
          child: isLocating
              // primaryInteractive over the glass tile: the brand blue only
              // reached ~2.8:1 there, under the 3:1 floor for meaningful
              // graphics in the active centered state.
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: colors.primaryInteractive,
                  ),
                )
              : _NavigationCompassIcon(
                  rotationRad: rotationRad,
                  centered: centered,
                ),
        ),
      ],
    );
  }
}

/// 44×44 frosted-glass square button built on the shared [GlassSurface] so it
/// matches the search bar and zoom slider exactly (same blur, edge, shadow and
/// corner radius). A neutral glass tile in every state.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
  });

  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GlassSurface(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            customBorder: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(kGlassRadius)),
            ),
            child: SizedBox(width: 44, height: 44, child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}

class _NavigationCompassIcon extends StatelessWidget {
  const _NavigationCompassIcon({
    required this.rotationRad,
    required this.centered,
  });

  final double rotationRad;
  final bool centered;

  static const double _size = 24;
  static const double _northEpsilonRad = math.pi / 180;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final rotation = _signedRotation(rotationRad);
    final northUp = rotation.abs() <= _northEpsilonRad;

    final IconData icon;
    final Color color;

    if (!northUp) {
      icon = Icons.navigation_outlined;
      color = colors.errorText;
    } else if (centered) {
      icon = Icons.navigation_rounded;
      color = colors.primaryInteractive;
    } else {
      icon = Icons.navigation_outlined;
      color = colors.neutral700;
    }

    return Transform.rotate(
      angle: northUp ? 0 : rotation,
      child: Icon(icon, size: _size, color: color),
    );
  }

  double _signedRotation(double radians) {
    const fullTurn = math.pi * 2;
    final normalized = radians % fullTurn;
    if (normalized > math.pi) return normalized - fullTurn;
    if (normalized < -math.pi) return normalized + fullTurn;
    return normalized;
  }
}
