import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/features/map_page/providers/user_location_provider.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

const double _northEpsilonRad = math.pi / 180;
const double _activeLocationFillOpacity = 0.92;

double _signedRotation(double radians) {
  const fullTurn = math.pi * 2;
  final normalized = radians % fullTurn;
  if (normalized > math.pi) return normalized - fullTurn;
  if (normalized < -math.pi) return normalized + fullTurn;
  return normalized;
}

bool _isNorthUp(double rotationRad) =>
    _signedRotation(rotationRad).abs() <= _northEpsilonRad;

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
    final locationIsActive = !isLocating && centered && _isNorthUp(rotationRad);

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
          // The brand blue clears the graphics contrast floor against this
          // almost-opaque surface while staying consistent with map/search
          // accents. Other controls retain the regular translucent glass.
          fill: locationIsActive
              ? colors.onNeutral.withValues(alpha: _activeLocationFillOpacity)
              : null,
          child: isLocating
              // The regular glass stays under this transient state, so retain
              // the deeper blue that clears the graphics contrast floor.
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

/// 44×44 **circular** frosted-glass button built on the shared [GlassSurface]
/// (same blur, edge and shadow as the search bar and zoom slider). Round rather
/// than the squircle tile the other surfaces use — the map controls read as
/// classic floating map buttons. [fill] allows a stateful control to strengthen
/// its surface without changing the shared glass construction.
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

class _NavigationCompassIcon extends StatelessWidget {
  const _NavigationCompassIcon({
    required this.rotationRad,
    required this.centered,
  });

  final double rotationRad;
  final bool centered;

  static const double _size = 24;

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
      color = colors.primaryMain;
    } else {
      icon = Icons.navigation_outlined;
      color = colors.neutral700;
    }

    return Transform.rotate(
      angle: northUp ? 0 : rotation,
      child: Icon(icon, size: _size, color: color),
    );
  }
}
