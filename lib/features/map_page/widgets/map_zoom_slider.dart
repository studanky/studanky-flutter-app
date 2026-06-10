import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

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
    final iconColor = colors.neutral700;

    Widget stepper(IconData icon, VoidCallback onTap) => InkResponse(
      onTap: onTap,
      radius: 18,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );

    return _ZoomGlass(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          stepper(Icons.add_rounded, () => onStep(1)),
          const SizedBox(height: 6),
          SizedBox(
            height: 120,
            child: _ZoomTrack(
              fraction: _fraction,
              minZoom: minZoom,
              maxZoom: maxZoom,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(height: 6),
          stepper(Icons.remove_rounded, () => onStep(-1)),
        ],
      ),
    );
  }
}

/// Glass pill flush with the screen's right edge (rounded on the left only).
class _ZoomGlass extends StatelessWidget {
  const _ZoomGlass({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    const radius = BorderRadius.horizontal(left: Radius.circular(20));

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.14),
            blurRadius: isDark ? 28 : 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: colors.glassFill,
              borderRadius: radius,
              border: Border(
                top: BorderSide(color: colors.glassBorder),
                left: BorderSide(color: colors.glassBorder),
                bottom: BorderSide(color: colors.glassBorder),
              ),
            ),
            child: child,
          ),
        ),
      ),
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
