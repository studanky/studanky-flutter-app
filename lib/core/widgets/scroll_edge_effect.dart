import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_overlay.dart';

enum ScrollEdgeEffectEdge { top, bottom, both }

/// Soft Liquid-Glass-inspired scroll edge effect.
///
/// The overlay appears only when the wrapped scrollable can continue past that
/// edge. It clarifies that more content is available without adding hard
/// dividers or intercepting gestures.
class ScrollEdgeEffect extends StatefulWidget {
  const ScrollEdgeEffect({
    super.key,
    required this.child,
    this.edge = ScrollEdgeEffectEdge.both,
    this.edgeHeight = 64,
    this.blurSigma = 32,
    this.tint,
  });

  final Widget child;
  final ScrollEdgeEffectEdge edge;
  final double edgeHeight;
  final double blurSigma;
  final Color? tint;

  @override
  State<ScrollEdgeEffect> createState() => _ScrollEdgeEffectState();
}

class _ScrollEdgeEffectState extends State<ScrollEdgeEffect> {
  static const double _visibilityThreshold = 0.5;

  bool _showTop = false;
  bool _showBottom = false;

  bool get _usesTop =>
      widget.edge == ScrollEdgeEffectEdge.top ||
      widget.edge == ScrollEdgeEffectEdge.both;

  bool get _usesBottom =>
      widget.edge == ScrollEdgeEffectEdge.bottom ||
      widget.edge == ScrollEdgeEffectEdge.both;

  void _updateForMetrics(ScrollMetrics metrics) {
    final hasOverflow =
        metrics.maxScrollExtent - metrics.minScrollExtent >
        _visibilityThreshold;
    final showTop =
        _usesTop && hasOverflow && metrics.extentBefore > _visibilityThreshold;
    final showBottom =
        _usesBottom &&
        hasOverflow &&
        metrics.extentAfter > _visibilityThreshold;

    if (showTop == _showTop && showBottom == _showBottom) return;

    setState(() {
      _showTop = showTop;
      _showBottom = showBottom;
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      _updateForMetrics(notification.metrics);
    }
    return false;
  }

  bool _onMetricsNotification(ScrollMetricsNotification notification) {
    if (notification.depth == 0) {
      _updateForMetrics(notification.metrics);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: _onMetricsNotification,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            widget.child,
            if (_usesTop)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: widget.edgeHeight,
                child: ScrollEdgeOverlay(
                  visible: _showTop,
                  isTop: true,
                  blurSigma: widget.blurSigma,
                  tint: widget.tint,
                ),
              ),
            if (_usesBottom)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: widget.edgeHeight,
                child: ScrollEdgeOverlay(
                  visible: _showBottom,
                  isTop: false,
                  blurSigma: widget.blurSigma,
                  tint: widget.tint,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
