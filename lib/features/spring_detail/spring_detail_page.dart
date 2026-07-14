import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_sheet.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

/// Max width of the sheet on large screens (tablets); below this it stretches
/// to the available width.
const double _maxSheetWidth = 640;

/// The spring detail, presented as a routed, non-opaque overlay above the map
/// (`/map/spring/:documentId`).
///
/// Presented as a draggable sheet, as a real go_router page, so the detail is
/// addressable and deep-linkable (e.g. from a QR scan). The map stays mounted
/// below because the route is non-opaque and pushed onto the root navigator
/// above `/map`.
///
/// At the half-open detent the map above the sheet stays **crisp** — the whole
/// point of a partial sheet over a map is keeping the place in context
/// (Google/Apple Maps pattern; the map page parks the spring in the visible
/// strip). The frosted backdrop only fades in as the sheet is dragged towards
/// full height, where the map stops being useful context anyway.
class SpringDetailPage extends StatefulWidget {
  const SpringDetailPage({required this.documentId, this.marker, super.key});

  /// Identifies which spring to show (path param). Always present.
  final String documentId;

  /// The already-loaded marker for an instant header. Null on a deep link / QR
  /// scan, where the sheet falls back to fetching by [documentId].
  final SpringMarkerEntity? marker;

  /// Builds the non-opaque page. The whole content slides up on entry,
  /// matching the old bottom-sheet transition.
  static Page<void> page({
    required String documentId,
    SpringMarkerEntity? marker,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      opaque: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      child: SpringDetailPage(documentId: documentId, marker: marker),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  @override
  State<SpringDetailPage> createState() => _SpringDetailPageState();
}

class _SpringDetailPageState extends State<SpringDetailPage> {
  /// Live sheet extent (fraction of screen height), fed by the sheet's
  /// [DraggableScrollableNotification]s bubbling up; drives the backdrop frost.
  final ValueNotifier<double> _sheetExtent = ValueNotifier(
    SpringDetailSheet.initialSize,
  );

  @override
  void dispose() {
    _sheetExtent.dispose();
    super.dispose();
  }

  bool _onSheetNotification(DraggableScrollableNotification notification) {
    _sheetExtent.value = notification.extent;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // The top inset caps the fully-expanded sheet below the status bar. Read it
    // straight from MediaQuery — unlike the old modal route (useSafeArea:false),
    // a page route does not strip the inset.
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final animation =
        ModalRoute.of(context)?.animation ?? const AlwaysStoppedAnimation(1.0);

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: _onSheetNotification,
      child: Stack(
        children: [
          Positioned.fill(
            child: _SheetBackdrop(
              animation: animation,
              extent: _sheetExtent,
              onTapOutside: () => context.pop(),
            ),
          ),
          // The sheet does not fill the screen (DraggableScrollableSheet sizes
          // it), so the area above stays empty for the backdrop to catch taps.
          // The top padding caps its fully-expanded height below the status bar.
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxSheetWidth),
              child: Padding(
                padding: EdgeInsets.only(top: topInset),
                child: SpringDetailSheet(
                  documentId: widget.documentId,
                  marker: widget.marker,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Backdrop behind the sheet: tap-to-dismiss for the area above it, plus a
/// frost that stays **off** while the sheet rests at its half-open detent (the
/// map is the context there) and fades in as the sheet is dragged towards full
/// height. On the way out it also fades with the route transition.
class _SheetBackdrop extends StatelessWidget {
  const _SheetBackdrop({
    required this.animation,
    required this.extent,
    required this.onTapOutside,
  });

  final Animation<double> animation;
  final ValueListenable<double> extent;
  final VoidCallback onTapOutside;

  /// Shared with the dialogs (`kBackdropBlurSigma`) so every modal backdrop
  /// frosts identically. Light by design — the map stays legible, just softened.
  static const double _maxSigma = kBackdropBlurSigma;

  /// Extent band over which the frost fades in: none up to just above the
  /// half-open detent, full strength shortly before full screen.
  static const double _frostStartExtent = 0.65;
  static const double _frostFullExtent = 0.95;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapOutside,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([animation, extent]),
        builder: (context, _) {
          final routeT = Curves.easeOut.transform(
            animation.value.clamp(0.0, 1.0),
          );
          final frostT =
              ((extent.value - _frostStartExtent) /
                      (_frostFullExtent - _frostStartExtent))
                  .clamp(0.0, 1.0);
          final sigma = _maxSigma * routeT * frostT;
          // Skip the BackdropFilter entirely while there is nothing to frost —
          // a 0-sigma filter still costs a saveLayer on the whole map.
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
