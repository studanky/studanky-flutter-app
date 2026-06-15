import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Subtle vertical zoom control flush to the right edge (zadání §11): a glass
/// pill with `+` / `−` steppers and a draggable thumb. Up = zoom in, down =
/// zoom out. Reports a target zoom; the page applies it to the map camera.
class MapZoomSlider extends StatelessWidget {
  const MapZoomSlider({
    super.key,
    required this.zoom,
    required this.minZoom,
    required this.maxZoom,
    required this.onChanged,
    required this.onStep,
  });

  /// Current camera zoom.
  final double zoom;
  final double minZoom;
  final double maxZoom;

  /// Continuous target zoom while dragging the thumb / tapping the track.
  final ValueChanged<double> onChanged;

  /// Stepped change from the `+` / `−` buttons (e.g. +1 / -1).
  final ValueChanged<double> onStep;

  /// 0 (min zoom, bottom) … 1 (max zoom, top).
  double get _fraction =>
      ((zoom - minZoom) / (maxZoom - minZoom)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final l10n = context.l10n;
    final iconColor = colors.neutral700;

    // 44pt-tall tap target (HIG) at the pill's slim width — the press axis on a
    // vertical slider is vertical, so height is what matters for thumb accuracy.
    Widget stepper(IconData icon, String label, VoidCallback onTap) => Semantics(
      button: true,
      label: label,
      child: InkResponse(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        radius: 22,
        child: SizedBox(
          height: 44,
          width: 28,
          child: Center(child: Icon(icon, size: 18, color: iconColor)),
        ),
      ),
    );

    return _ZoomGlass(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          stepper(Icons.add_rounded, l10n.map_zoom_in, () => onStep(1)),
          SizedBox(
            height: 120,
            child: _ZoomTrack(
              fraction: _fraction,
              minZoom: minZoom,
              maxZoom: maxZoom,
              onChanged: onChanged,
            ),
          ),
          stepper(Icons.remove_rounded, l10n.map_zoom_out, () => onStep(-1)),
        ],
      ),
    );
  }
}

/// Glass pill flush with the screen's right edge: the shared [GlassSurface]
/// rounded on the left only, with its right hairline dropped so it reads as
/// part of the screen edge.
class _ZoomGlass extends StatelessWidget {
  const _ZoomGlass({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    const radius = BorderRadius.horizontal(left: Radius.circular(kGlassRadius));

    return GlassSurface(
      borderRadius: radius,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      border: Border(
        top: BorderSide(color: colors.glassBorder, width: kGlassBorderWidth),
        left: BorderSide(color: colors.glassBorder, width: kGlassBorderWidth),
        bottom: BorderSide(color: colors.glassBorder, width: kGlassBorderWidth),
      ),
      child: child,
    );
  }
}

class _ZoomTrack extends StatelessWidget {
  const _ZoomTrack({
    required this.fraction,
    required this.minZoom,
    required this.maxZoom,
    required this.onChanged,
  });

  final double fraction;
  final double minZoom;
  final double maxZoom;
  final ValueChanged<double> onChanged;

  void _emit(double localY, double height) {
    // Top = max zoom, bottom = min zoom.
    final f = (1 - (localY / height)).clamp(0.0, 1.0);
    onChanged(minZoom + f * (maxZoom - minZoom));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _emit(d.localPosition.dy, height),
          onVerticalDragUpdate: (d) => _emit(d.localPosition.dy, height),
          child: SizedBox(
            width: 20,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Track background.
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: colors.neutral500.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Active fill (from bottom up to the thumb).
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: fraction,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [colors.primaryMain, colors.primary500],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                // Thumb.
                Align(
                  alignment: Alignment(0, 1 - fraction * 2),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: colors.onPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primaryMain.withValues(alpha: 0.7),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
