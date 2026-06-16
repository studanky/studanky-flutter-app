import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_detail_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_reports_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_actions.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_history_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_header.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_photo_view.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Max width of the sheet on large screens (tablets); below this it stretches
/// to the available width.
const double _maxSheetWidth = 640;

/// Opens the spring detail as a draggable bottom sheet that starts at half
/// height and can be dragged to full screen (overlaying the bottom navigation
/// via the root navigator).
Future<void> showSpringDetailSheet(
  BuildContext context, {
  required SpringMarkerEntity marker,
}) {
  // Full-bleed frost instead of a dim: the blur sits *behind* the sheet inside
  // the modal content (so the sheet stays sharp) and spans the whole screen —
  // including the status-bar and home-indicator strips, since we opt out of
  // useSafeArea and re-apply the top inset ourselves. Tap-to-dismiss is handled
  // explicitly by the backdrop (the transparent modal barrier is unreliable once
  // full-bleed content covers it).
  //
  // Read the top inset from the *caller's* context: inside the sheet route the
  // MediaQuery top inset is stripped to 0 (it removes top padding *and*
  // viewPadding when useSafeArea is false), so reading it there would let the
  // maximised sheet slide under the status bar.
  final topInset = MediaQuery.viewPaddingOf(context).top;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    builder: (sheetContext) {
      return Stack(
        children: [
          Positioned.fill(
            child: _SheetBackdrop(
              onTapOutside: () => Navigator.of(sheetContext).maybePop(),
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
                child: SpringDetailSheet(marker: marker),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Full-bleed frosted backdrop behind the sheet: a light gaussian blur over the
/// map whose strength eases in/out with the sheet's open/close transition, plus
/// an explicit tap-to-dismiss for the area above the sheet.
class _SheetBackdrop extends StatelessWidget {
  const _SheetBackdrop({required this.onTapOutside});

  final VoidCallback onTapOutside;

  /// Light by design — the map stays legible, just softened.
  static const double _maxSigma = 8;

  @override
  Widget build(BuildContext context) {
    final animation =
        ModalRoute.of(context)?.animation ??
        const AlwaysStoppedAnimation(1.0);

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

class SpringDetailSheet extends StatefulWidget {
  const SpringDetailSheet({required this.marker, super.key});

  final SpringMarkerEntity marker;

  @override
  State<SpringDetailSheet> createState() => _SpringDetailSheetState();
}

class _SpringDetailSheetState extends State<SpringDetailSheet> {
  /// Opening height (half screen).
  static const double _initialSize = 0.55;

  /// Lets the sheet be dragged well below half so a downward swipe can cross
  /// the dismiss threshold (it never rests this low — it pops first).
  static const double _minSize = 0.1;

  /// Crossing this drag extent on the way down closes the sheet entirely.
  /// Half is **not** a snap target, so the only resting states are the opening
  /// half height and full screen: dragging up expands, dragging down dismisses
  /// — a single downward swipe from full screen closes it (never stops at half).
  static const double _dismissThreshold = 0.45;

  bool _dismissing = false;

  bool _onNotification(DraggableScrollableNotification notification) {
    if (!_dismissing && notification.extent < _dismissThreshold) {
      _dismissing = true;
      Navigator.of(context).maybePop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: _onNotification,
      child: DraggableScrollableSheet(
        initialChildSize: _initialSize,
        minChildSize: _minSize,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [1.0],
        expand: false,
        builder: (context, scrollController) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(kRadiusCard),
            ),
            // The grouped background (lighter than the section cards) so the
            // iOS-style inset sections read as cards floating on the sheet.
            child: Material(
              color: colors.background,
              child: _SpringDetailBody(
                marker: widget.marker,
                scrollController: scrollController,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Scrollable body shared by the half- and full-height states. Owns the
/// infinite-scroll trigger for the report history.
class _SpringDetailBody extends ConsumerStatefulWidget {
  const _SpringDetailBody({required this.marker, required this.scrollController});

  final SpringMarkerEntity marker;
  final ScrollController scrollController;

  @override
  ConsumerState<_SpringDetailBody> createState() => _SpringDetailBodyState();
}

class _SpringDetailBodyState extends ConsumerState<_SpringDetailBody> {
  /// Distance from the bottom at which the next page is prefetched.
  static const double _loadMoreThreshold = 400;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  String get _documentId => widget.marker.documentId;

  void _onScroll() {
    final controller = widget.scrollController;
    if (!controller.hasClients) return;
    final position = controller.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      ref.read(springReportsProvider(_documentId).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final marker = widget.marker;
    final locale = Localizations.localeOf(context).languageCode;

    final detail = ref
        .watch(springDetailProvider(_documentId, locale: locale))
        .value;
    final config = ref.watch(platformConfigControllerProvider);
    final reportsState = ref.watch(springReportsProvider(_documentId));

    // Header renders from the marker immediately and is enriched by the detail.
    final name = detail?.name ?? marker.name;
    final position = detail?.position ?? marker.position;
    final status = detail?.status ?? marker.status;
    final statusUpdatedAt = detail?.statusUpdatedAt ?? marker.statusUpdatedAt;
    final statusIcon = config.iconFor(status.wireValue, statusUpdatedAt);

    final isFavorite = ref.watch(
      favoritesControllerProvider.select(
        (favorites) =>
            favorites.any((s) => s.documentId == marker.documentId),
      ),
    );
    // Store the freshest summary available so the favourites list stays useful.
    final favoriteEntity = SpringMarkerEntity(
      documentId: marker.documentId,
      name: name,
      position: position,
      status: status,
      statusUpdatedAt: statusUpdatedAt,
    );

    // Current-state metrics: the spring's denormalised "last_*" values, falling
    // back to the newest report until the detail resolves. Clarity is a
    // per-report field, so it always comes from the latest report.
    final latestReport = reportsState.reports.isEmpty
        ? null
        : reportsState.reports.first;
    final flowScale = detail?.lastFlowScale ?? latestReport?.flowScale;
    final flowRateLps = detail?.lastFlowRateLps ?? latestReport?.flowRateLps;
    final clarity = latestReport?.waterClarity;
    final maxFlowScale = config.maxFlowScale;

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        const SliverToBoxAdapter(child: _Grabber()),
        if (detail?.photo != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kRadiusControl),
                child: SpringPhotoView(photo: detail!.photo),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: SpringDetailHeader(
            name: name,
            statusIcon: statusIcon,
            statusUpdatedAt: statusUpdatedAt,
            position: position,
            description: detail?.description,
            flowScale: flowScale,
            flowRateLps: flowRateLps,
            clarity: clarity,
            maxFlowScale: maxFlowScale,
            onShare: () => _share(name, position),
            onNavigate: () => _navigate(position),
            onCopyCoordinates: () => _copyCoordinates(position),
            isFavorite: isFavorite,
            onToggleFavorite: () => ref
                .read(favoritesControllerProvider.notifier)
                .toggle(favoriteEntity),
          ),
        ),
        ...buildReportHistorySlivers(
          context,
          state: reportsState,
          maxFlowScale: maxFlowScale,
          onRetry: () =>
              ref.read(springReportsProvider(_documentId).notifier).retryInitial(),
          onRetryLoadMore: () =>
              ref.read(springReportsProvider(_documentId).notifier).loadMore(),
        ),
        // Bottom breathing room + the home-indicator inset (the sheet is
        // full-bleed, so it clears the bottom safe area itself).
        SliverToBoxAdapter(
          child: SizedBox(height: 24 + MediaQuery.viewPaddingOf(context).bottom),
        ),
      ],
    );
  }

  Future<void> _share(String name, LatLng position) {
    return SpringActions.share(context.l10n, name: name, position: position);
  }

  Future<void> _navigate(LatLng position) async {
    final launched = await SpringActions.navigate(position);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.spring_detail_navigation_failed)),
      );
    }
  }

  Future<void> _copyCoordinates(LatLng position) async {
    await SpringActions.copyCoordinates(position);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.spring_detail_coordinates_copied)),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colors.neutral300,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
