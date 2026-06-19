import 'dart:ui' show ImageFilter;

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
/// It reproduces the previous modal-bottom-sheet presentation — a full-bleed
/// frosted backdrop behind a draggable sheet — but as a real go_router page, so
/// the detail is addressable and deep-linkable (e.g. from a QR scan). The map
/// stays mounted below because the route is non-opaque and pushed onto the root
/// navigator above `/map`.
class SpringDetailPage extends StatelessWidget {
  const SpringDetailPage({required this.documentId, this.marker, super.key});

  /// Identifies which spring to show (path param). Always present.
  final String documentId;

  /// The already-loaded marker for an instant header. Null on a deep link / QR
  /// scan, where the sheet falls back to fetching by [documentId].
  final SpringMarkerEntity? marker;

  /// Builds the non-opaque page. The whole content slides up on entry (matching
  /// the old bottom-sheet transition) while the backdrop blur eases in.
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
  Widget build(BuildContext context) {
    // The top inset caps the fully-expanded sheet below the status bar. Read it
    // straight from MediaQuery — unlike the old modal route (useSafeArea:false),
    // a page route does not strip the inset.
    final topInset = MediaQuery.viewPaddingOf(context).top;
    final animation =
        ModalRoute.of(context)?.animation ?? const AlwaysStoppedAnimation(1.0);

    return Stack(
      children: [
        Positioned.fill(
          child: _SheetBackdrop(
            animation: animation,
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
              child: SpringDetailSheet(documentId: documentId, marker: marker),
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-bleed frosted backdrop behind the sheet: a light gaussian blur over the
/// map whose strength eases in/out with the page transition, plus an explicit
/// tap-to-dismiss for the area above the sheet.
class _SheetBackdrop extends StatelessWidget {
  const _SheetBackdrop({required this.animation, required this.onTapOutside});

  final Animation<double> animation;
  final VoidCallback onTapOutside;

  /// Shared with the dialogs (`kBackdropBlurSigma`) so every modal backdrop
  /// frosts identically. Light by design — the map stays legible, just softened.
  static const double _maxSigma = kBackdropBlurSigma;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapOutside,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = Curves.easeOut.transform(animation.value.clamp(0.0, 1.0));
          final sigma = _maxSigma * t;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}
