import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_sheet.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

/// Max width of the sheet on large screens (tablets); below this it stretches
/// to the available width.
const double _maxSheetWidth = 640;

/// The spring detail presented *inside* the map page's stack — deliberately
/// not a modal route, so the map behind the half-open sheet stays fully
/// interactive: panning, zooming and one-tap switching to another spring's
/// marker all keep working (the Google/Apple Maps pattern). The URL still
/// drives it: the map page flips [documentId] when `/map/spring/:id` is
/// entered or left.
///
/// Owns the entrance/exit slide and the frost backdrop. The frost stays off at
/// the half-open detent — the crisp map *is* the context there — and fades in
/// only as the sheet approaches full height. It also ignores pointers;
/// closing is the map page's business (bare-map tap, system back, drag down).
class SpringDetailOverlay extends StatefulWidget {
  const SpringDetailOverlay({
    super.key,
    required this.documentId,
    required this.marker,
    required this.onDismissed,
    this.onExtentChanged,
  });

  /// Spring to show; null plays the exit slide and then renders nothing.
  final String? documentId;

  /// Already-loaded marker for an instant header; null on a deep link / QR
  /// scan, where the sheet fetches by [documentId].
  final SpringMarkerEntity? marker;

  /// Invoked when the sheet is dragged below its dismiss threshold. The owner
  /// navigates back to plain `/map`, which flips [documentId] to null and
  /// plays the exit slide.
  final VoidCallback onDismissed;

  /// Reports the live [DraggableScrollableSheet] extent to the map host so
  /// camera moves can target the currently visible map area.
  final ValueChanged<double>? onExtentChanged;

  @override
  State<SpringDetailOverlay> createState() => _SpringDetailOverlayState();
}

class _SpringDetailOverlayState extends State<SpringDetailOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 250),
  );
  late final Animation<Offset> _slide = _entrance
      .drive(CurveTween(curve: Curves.easeOutCubic))
      .drive(Tween(begin: const Offset(0, 1), end: Offset.zero));

  /// Live sheet extent (fraction of screen height), fed by the sheet's
  /// [DraggableScrollableNotification]s; drives the frost backdrop.
  final ValueNotifier<double> _sheetExtent = ValueNotifier(
    SpringDetailSheet.initialSize,
  );

  /// The spring being rendered. Kept alive during the exit slide (when the
  /// route param is already null) so the sheet has content to animate away
  /// with.
  ({String documentId, SpringMarkerEntity? marker})? _visible;

  @override
  void initState() {
    super.initState();
    final id = widget.documentId;
    if (id != null) {
      _visible = (documentId: id, marker: widget.marker);
      _setSheetExtent(_sheetExtent.value);
      _entrance.forward();
    }
  }

  @override
  void didUpdateWidget(SpringDetailOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    final id = widget.documentId;

    if (id == null) {
      if (_visible == null) return;
      widget.onExtentChanged?.call(SpringDetailSheet.initialSize);
      // Slide out, then drop the content. A forward() supersedes the reverse
      // ticker (its future never completes), so a reopen mid-exit is safe; the
      // guard covers the notification-driven dismiss navigating first.
      _entrance.reverse().whenComplete(() {
        if (mounted && widget.documentId == null) {
          setState(() => _visible = null);
        }
      });
      return;
    }

    if (_visible?.documentId != id) {
      setState(() {
        _visible = (documentId: id, marker: widget.marker);
      });
      // A different spring starts back at the half-open detent.
      _setSheetExtent(SpringDetailSheet.initialSize);
    }
    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _sheetExtent.dispose();
    super.dispose();
  }

  bool _onSheetNotification(DraggableScrollableNotification notification) {
    _setSheetExtent(notification.extent);
    return false;
  }

  void _setSheetExtent(double extent) {
    _sheetExtent.value = extent;
    widget.onExtentChanged?.call(extent);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    if (visible == null) return const SizedBox.shrink();

    // The top inset caps the fully-expanded sheet below the status bar.
    final topInset = MediaQuery.viewPaddingOf(context).top;

    return Stack(
      children: [
        Positioned.fill(
          child: _FrostBackdrop(animation: _entrance, extent: _sheetExtent),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxSheetWidth),
            child: Padding(
              padding: EdgeInsets.only(top: topInset),
              child: SlideTransition(
                position: _slide,
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: _onSheetNotification,
                  child: SpringDetailSheet(
                    // Keyed per spring: switching springs re-creates the sheet
                    // at the half-open detent with the scroll at the top.
                    key: ValueKey(visible.documentId),
                    documentId: visible.documentId,
                    marker: visible.marker,
                    onDismissed: widget.onDismissed,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Frost between the map and the sheet: off while the sheet rests at its
/// half-open detent (the map is the context there), fading in as the sheet is
/// dragged towards full height, and out again with the exit slide. Ignores
/// pointers — the map below stays interactive.
class _FrostBackdrop extends StatelessWidget {
  const _FrostBackdrop({required this.animation, required this.extent});

  final Animation<double> animation;
  final ValueListenable<double> extent;

  /// Shared with the dialogs (`kBackdropBlurSigma`) so every frosted backdrop
  /// reads identically. Light by design — the map stays legible, just softened.
  static const double _maxSigma = kBackdropBlurSigma;

  /// Extent band over which the frost fades in: none up to just above the
  /// half-open detent, full strength shortly before full screen.
  static const double _frostStartExtent = 0.65;
  static const double _frostFullExtent = 0.95;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge([animation, extent]),
        builder: (context, _) {
          final frostT =
              ((extent.value - _frostStartExtent) /
                      (_frostFullExtent - _frostStartExtent))
                  .clamp(0.0, 1.0);
          final sigma = _maxSigma * animation.value * frostT;
          // Skip the BackdropFilter entirely while there is nothing to frost —
          // a 0-sigma filter still costs a saveLayer over the whole map.
          if (sigma == 0) return const SizedBox.expand();
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}
