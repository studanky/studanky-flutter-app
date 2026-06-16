import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';

/// iOS-style trailing-edge swipe action for rounded list tiles.
///
/// Only [child] moves horizontally. The whole row, including vertical spacing,
/// collapses after the delete slide finishes.
class SwipeToDeleteTile extends StatefulWidget {
  const SwipeToDeleteTile({
    super.key,
    required this.child,
    required this.deleteSemanticLabel,
    required this.onDelete,
  });

  final Widget child;
  final String deleteSemanticLabel;
  final Future<void> Function() onDelete;

  @override
  State<SwipeToDeleteTile> createState() => _SwipeToDeleteTileState();
}

class _SwipeToDeleteTileState extends State<SwipeToDeleteTile> {
  static const Duration _snapDuration = Duration(milliseconds: 180);
  static const Duration _deleteSlideDuration = Duration(milliseconds: 220);
  static const Duration _collapseDuration = Duration(milliseconds: 200);
  static const double _velocityDeleteThreshold = -700;

  double _dragOffset = 0;
  bool _isDragging = false;
  bool _isDeleting = false;
  bool _isCollapsed = false;

  double _maxReveal(double width) => math.min(112, width * 0.45);

  void _onDragUpdate(DragUpdateDetails details, double width) {
    if (_isDeleting) return;
    setState(() {
      _isDragging = true;
      _dragOffset = (_dragOffset + details.delta.dx).clamp(
        -_maxReveal(width),
        0.0,
      );
    });
  }

  void _onDragEnd(DragEndDetails details, double width) {
    if (_isDeleting) return;

    final shouldDelete =
        _dragOffset.abs() >= width * 0.32 ||
        (details.primaryVelocity ?? 0) <= _velocityDeleteThreshold;

    if (shouldDelete) {
      unawaited(_delete(width));
      return;
    }

    setState(() {
      _isDragging = false;
      _dragOffset = 0;
    });
  }

  Future<void> _delete(double width) async {
    setState(() {
      _isDragging = false;
      _isDeleting = true;
      _dragOffset = -width;
    });

    await Future<void>.delayed(_deleteSlideDuration);
    if (!mounted) return;

    setState(() => _isCollapsed = true);

    await Future<void>.delayed(_collapseDuration);
    if (!mounted) return;

    await widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.topCenter,
            heightFactor: _isCollapsed ? 0 : 1,
            duration: _collapseDuration,
            curve: Curves.easeInOutCubic,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: AnimatedOpacity(
                opacity: _isCollapsed ? 0 : 1,
                duration: _collapseDuration,
                curve: Curves.easeOutCubic,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kRadiusControl),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: colors.error),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Semantics(
                                label: widget.deleteSemanticLabel,
                                child: ExcludeSemantics(
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: colors.onError,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: _isDragging
                            ? Duration.zero
                            : _isDeleting
                            ? _deleteSlideDuration
                            : _snapDuration,
                        curve: Curves.easeOutCubic,
                        transform: Matrix4.translationValues(_dragOffset, 0, 0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onHorizontalDragUpdate: (details) =>
                              _onDragUpdate(details, width),
                          onHorizontalDragEnd: (details) =>
                              _onDragEnd(details, width),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
