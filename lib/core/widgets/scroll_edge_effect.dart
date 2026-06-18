import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

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
                child: _ScrollEdgeOverlay(
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
                child: _ScrollEdgeOverlay(
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

class _ScrollEdgeOverlay extends StatelessWidget {
  const _ScrollEdgeOverlay({
    required this.visible,
    required this.isTop,
    required this.blurSigma,
    required this.tint,
  });

  final bool visible;
  final bool isTop;
  final double blurSigma;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colors = Styles.appColors;
    final isDark = colors.brightness == Brightness.dark;
    final baseTint = tint ?? (isDark ? colors.background : colors.onNeutral);
    final shade = isDark ? Colors.black : colors.neutral900;
    final edgeAlpha = mediaQuery.highContrast
        ? (isDark ? 0.90 : 0.94)
        : (isDark ? 0.78 : 0.88);
    final midAlpha = mediaQuery.highContrast
        ? (isDark ? 0.68 : 0.72)
        : (isDark ? 0.52 : 0.62);
    final shadeEdgeAlpha = mediaQuery.highContrast
        ? (isDark ? 0.30 : 0.12)
        : (isDark ? 0.20 : 0.07);
    final shadeMidAlpha = mediaQuery.highContrast
        ? (isDark ? 0.14 : 0.06)
        : (isDark ? 0.08 : 0.03);

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: mediaQuery.disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: ClipRect(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isTop
                  ? const [Colors.white, Colors.transparent]
                  : const [Colors.transparent, Colors.white],
            ).createShader(bounds),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.52, 1],
                          colors: isTop
                              ? [
                                  baseTint.withValues(alpha: edgeAlpha),
                                  baseTint.withValues(alpha: midAlpha),
                                  baseTint.withValues(alpha: 0),
                                ]
                              : [
                                  baseTint.withValues(alpha: 0),
                                  baseTint.withValues(alpha: midAlpha),
                                  baseTint.withValues(alpha: edgeAlpha),
                                ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.42, 1],
                          colors: isTop
                              ? [
                                  shade.withValues(alpha: shadeEdgeAlpha),
                                  shade.withValues(alpha: shadeMidAlpha),
                                  shade.withValues(alpha: 0),
                                ]
                              : [
                                  shade.withValues(alpha: 0),
                                  shade.withValues(alpha: shadeMidAlpha),
                                  shade.withValues(alpha: shadeEdgeAlpha),
                                ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox.expand(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
