import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/haptics/haptics.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Vertical zoom control whose horizontal centre is meant to sit on the right
/// viewport edge. The parent clips the outside half, leaving a larger
/// semicircular thumb to drag.
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

  /// Stepped zoom change for semantic increase/decrease actions.
  final ValueChanged<double> onStep;

  /// The map page positions the slider with `right: -width / 2`, so this value
  /// is part of the component contract.
  static const double width = 88;
  static const double preferredHeight = 480;

  static const double _thumbDiameter = 56;
  static const double _thumbRadius = _thumbDiameter / 2;
  static const double _edgeShadowPadding = 30;

  /// 0 (min zoom, bottom) … 1 (max zoom, top).
  double get _fraction =>
      ((zoom - minZoom) / (maxZoom - minZoom)).clamp(0.0, 1.0);

  String _semanticValue(double value) => value.toStringAsFixed(1);

  static double _verticalInsetFor(double height) {
    if (height <= 1) return 0;
    return math.min(_thumbRadius + _edgeShadowPadding, (height - 1) / 2);
  }

  static double _trackTravelFor(double height) {
    final verticalInset = _verticalInsetFor(height);
    return math.max(1.0, height - verticalInset * 2);
  }

  void _step(double delta) {
    Haptics.selection();
    onStep(delta);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Semantics(
      slider: true,
      label: '${l10n.map_zoom_in} / ${l10n.map_zoom_out}',
      value: _semanticValue(zoom.clamp(minZoom, maxZoom)),
      increasedValue: _semanticValue((zoom + 1).clamp(minZoom, maxZoom)),
      decreasedValue: _semanticValue((zoom - 1).clamp(minZoom, maxZoom)),
      onIncrease: () => _step(1),
      onDecrease: () => _step(-1),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.hasBoundedHeight
              ? constraints.maxHeight
              : preferredHeight;
          final height = math.min(preferredHeight, availableHeight);

          return SizedBox(
            width: width,
            height: height,
            child: _ZoomTrack(
              fraction: _fraction,
              minZoom: minZoom,
              maxZoom: maxZoom,
              onChanged: onChanged,
            ),
          );
        },
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
    final verticalInset = MapZoomSlider._verticalInsetFor(height);
    final trackTravel = MapZoomSlider._trackTravelFor(height);

    // Top = max zoom, bottom = min zoom.
    final y = localY.clamp(verticalInset, height - verticalInset);
    final f = (1 - ((y - verticalInset) / trackTravel)).clamp(0.0, 1.0);
    onChanged(minZoom + f * (maxZoom - minZoom));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final centerY =
            MapZoomSlider._verticalInsetFor(height) +
            (1 - fraction) * MapZoomSlider._trackTravelFor(height);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _emit(d.localPosition.dy, height),
          onVerticalDragStart: (d) => _emit(d.localPosition.dy, height),
          onVerticalDragUpdate: (d) => _emit(d.localPosition.dy, height),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: MapZoomSlider.width / 2 - MapZoomSlider._thumbRadius,
                top: centerY - MapZoomSlider._thumbRadius,
                child: const _ZoomThumb(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ZoomThumb extends StatelessWidget {
  const _ZoomThumb();

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      borderRadius: BorderRadius.circular(MapZoomSlider._thumbRadius),
      child: const SizedBox.square(
        dimension: MapZoomSlider._thumbDiameter,
        child: _ThumbDragIndicator(),
      ),
    );
  }
}

class _ThumbDragIndicator extends StatelessWidget {
  const _ThumbDragIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return CustomPaint(
      painter: _ThumbDragIndicatorPainter(
        color: colors.neutral700.withValues(alpha: 0.82),
      ),
    );
  }
}

class _ThumbDragIndicatorPainter extends CustomPainter {
  const _ThumbDragIndicatorPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final visibleHalfCenter = Offset(size.width / 4, size.height / 2);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final up = Path()
      ..moveTo(visibleHalfCenter.dx - 5, visibleHalfCenter.dy - 3)
      ..lineTo(visibleHalfCenter.dx, visibleHalfCenter.dy - 8)
      ..lineTo(visibleHalfCenter.dx + 5, visibleHalfCenter.dy - 3);
    final down = Path()
      ..moveTo(visibleHalfCenter.dx - 5, visibleHalfCenter.dy + 3)
      ..lineTo(visibleHalfCenter.dx, visibleHalfCenter.dy + 8)
      ..lineTo(visibleHalfCenter.dx + 5, visibleHalfCenter.dy + 3);

    canvas
      ..drawPath(up, paint)
      ..drawPath(down, paint);
  }

  @override
  bool shouldRepaint(covariant _ThumbDragIndicatorPainter oldDelegate) =>
      oldDelegate.color != color;
}
