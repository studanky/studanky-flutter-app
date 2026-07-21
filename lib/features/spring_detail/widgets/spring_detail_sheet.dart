import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:studanky_flutter_app/core/haptics/haptics.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/app_progress_indicator.dart';
import 'package:studanky_flutter_app/core/widgets/error_widget.dart';
import 'package:studanky_flutter_app/core/widgets/glass_snack_bar.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_detail_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_reports_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/utils/spring_actions.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/map_picker_sheet.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/report_history_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_detail_header.dart';
import 'package:studanky_flutter_app/features/spring_detail/widgets/spring_photo_view.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// The spring detail content: a draggable sheet that starts at half height and
/// can be dragged to full screen. Hosted by `SpringDetailOverlay`, which owns
/// the in-map presentation (entrance slide + extent-driven frost).
class SpringDetailSheet extends StatefulWidget {
  const SpringDetailSheet({
    required this.documentId,
    required this.onDismissed,
    this.marker,
    super.key,
  });

  /// Identifies which spring to load. Always present (route path param).
  final String documentId;

  /// Optional pre-loaded summary for an instant header; null on a deep link /
  /// QR scan, where the sheet falls back to fetching by [documentId].
  final SpringMarkerEntity? marker;

  /// Invoked once when the sheet is dragged/flung down past its dismiss
  /// threshold. The host closes the detail (navigates back to plain `/map`) and
  /// animates the sheet away — the sheet is a widget in the map's stack, not a
  /// route, so it cannot pop itself.
  final VoidCallback onDismissed;

  /// Opening height as a fraction of the screen. Public because the map page
  /// derives from it where to park the camera so the tapped spring stays
  /// centred in the strip left visible above the half-open sheet.
  static const double initialSize = 0.55;

  @override
  State<SpringDetailSheet> createState() => _SpringDetailSheetState();
}

class _SpringDetailSheetState extends State<SpringDetailSheet> {
  /// Opening height (half screen) — one of the two resting detents.
  static const double _initialSize = SpringDetailSheet.initialSize;

  /// Sits below half only to give a downward gesture room to cross
  /// [_dismissThreshold]; the sheet never *rests* here — it dismisses first.
  static const double _minSize = 0.1;

  /// A downward drag/fling that pulls the sheet past this extent closes the
  /// detail. Just below the half detent, so a small pull-down from half closes,
  /// while from full it mostly just settles back to half.
  static const double _dismissThreshold = 0.45;

  bool _dismissing = false;

  /// Tracks whether the sheet is currently resting at full height, so the snap
  /// detent ticks once on arrival rather than repeatedly as the extent settles.
  bool _atFull = false;

  bool _onNotification(DraggableScrollableNotification notification) {
    // Drag/fling the sheet down past the threshold → close. The sheet is a
    // widget in the map's stack (not a route), so it asks the host to navigate
    // away rather than popping itself. (Plain observation of the documented
    // extent notification — no driving the sheet's controller from here.)
    if (!_dismissing && notification.extent < _dismissThreshold) {
      _dismissing = true;
      widget.onDismissed();
    }

    // A single detent tick when the sheet locks into full height — the one
    // satisfying "snapped into place" moment. Dismissing isn't ticked: the
    // sheet visibly flying away is feedback enough.
    final atFull = notification.extent >= 0.999;
    if (atFull != _atFull) {
      _atFull = atFull;
      if (atFull) Haptics.selection();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: _onNotification,
      child: DraggableScrollableSheet(
        // Half ([snapSizes]) and full ([maxChildSize]) are the two resting
        // detents, snapped by the widget's own velocity-aware physics.
        // [minChildSize] sits below half only so a downward drag/fling has room
        // to cross [_dismissThreshold] and close the detail; the sheet never
        // rests that low. From full a gentle drag settles back to half, a firm
        // drag-down closes.
        initialChildSize: _initialSize,
        minChildSize: _minSize,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [_initialSize],
        expand: false,
        builder: (context, scrollController) {
          // Solid, opaque sheet pulled flush to the phone's bottom edge — the
          // home-indicator inset is handled by the content's own bottom padding,
          // not a gap under the sheet. Deliberately not glass: the dense
          // freshness data (status, ages, history) must read cleanly over the
          // map, so the sheet stays a solid surface — legibility over effect.
          return ClipRSuperellipse(
            // Squircle top corners only; the bottom runs off the screen edge.
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(kRadiusCard),
            ),
            // The grouped background (lighter than the section cards) so the
            // iOS-style inset sections read as cards floating on the sheet.
            child: Material(
              color: colors.background,
              child: _SpringDetailBody(
                documentId: widget.documentId,
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
  const _SpringDetailBody({
    required this.documentId,
    required this.marker,
    required this.scrollController,
  });

  final String documentId;
  final SpringMarkerEntity? marker;
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

  String get _documentId => widget.documentId;

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

    final detailAsync = ref.watch(
      springDetailProvider(_documentId, locale: locale),
    );
    final detail = detailAsync.value;
    final config = ref.watch(platformConfigControllerProvider);
    final reportsState = ref.watch(springReportsProvider(_documentId));

    // Header renders from the marker immediately (tap/search/favourites) and is
    // enriched by the detail. On a deep link / QR scan there is no marker, so
    // the header waits for the detail to resolve.
    final name = detail?.name ?? marker?.name;
    final position = detail?.position ?? marker?.position;
    final status = detail?.status ?? marker?.status;
    final statusUpdatedAt = detail?.statusUpdatedAt ?? marker?.statusUpdatedAt;

    final isFavorite = ref.watch(
      favoritesControllerProvider.select(
        (favorites) => favorites.any((s) => s.documentId == _documentId),
      ),
    );

    // Current-state metrics: the spring's denormalised "last_*" values, falling
    // back to the newest report until the detail resolves. Clarity is a
    // per-report field, so it always comes from the latest report.
    final latestReport = reportsState.reports.isEmpty
        ? null
        : reportsState.reports.first;
    final clarity = latestReport?.waterClarity;
    final maxFlowScale = config.maxFlowScale;

    return ScrollEdgeEffect(
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          const SliverToBoxAdapter(child: _Grabber()),
          if (name == null || position == null || status == null)
            // Deep-link entry without a marker: nothing to render until the
            // detail resolves — show a spinner, or a graceful error (with retry)
            // if the id is unknown.
            SliverFillRemaining(
              hasScrollBody: false,
              child: detailAsync.hasError
                  ? AppErrorWidget(
                      error: detailAsync.error!,
                      stackTrace: detailAsync.stackTrace ?? StackTrace.empty,
                      onRefresh: () => ref.invalidate(
                        springDetailProvider(_documentId, locale: locale),
                      ),
                    )
                  : const AppProgressIndicator(),
            )
          else ...[
            if (detail?.photo != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: ClipRSuperellipse(
                    borderRadius: BorderRadius.circular(kRadiusControl),
                    child: SpringPhotoView(photo: detail!.photo),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SpringDetailHeader(
                name: name,
                statusIcon: config.iconFor(status.wireValue, statusUpdatedAt),
                statusUpdatedAt: statusUpdatedAt,
                position: position,
                description: detail?.description,
                flowScale: detail?.lastFlowScale ?? latestReport?.flowScale,
                flowRateLps:
                    detail?.lastFlowRateLps ?? latestReport?.flowRateLps,
                clarity: clarity,
                maxFlowScale: maxFlowScale,
                onShare: () => _share(name, position),
                onNavigate: () => _openInMap(name, position),
                onCopyCoordinates: () => _copyCoordinates(position),
                isFavorite: isFavorite,
                onToggleFavorite: () {
                  // Saving is the rewarding action (medium); un-saving is a
                  // lighter tick.
                  isFavorite ? Haptics.selection() : Haptics.toggle();
                  ref
                      .read(favoritesControllerProvider.notifier)
                      // Store the freshest summary available so the favourites
                      // list stays useful.
                      .toggle(
                        SpringMarkerEntity(
                          documentId: _documentId,
                          name: name,
                          position: position,
                          status: status,
                          statusUpdatedAt: statusUpdatedAt,
                        ),
                      );
                },
              ),
            ),
            ...buildReportHistorySlivers(
              context,
              state: reportsState,
              maxFlowScale: maxFlowScale,
              onRetry: () => ref
                  .read(springReportsProvider(_documentId).notifier)
                  .retryInitial(),
              onRetryLoadMore: () => ref
                  .read(springReportsProvider(_documentId).notifier)
                  .loadMore(),
            ),
            // Bottom breathing room + the home-indicator inset: the glass sheet
            // runs flush to the bottom edge, so the content clears the safe area
            // itself.
            SliverToBoxAdapter(
              child: SizedBox(
                height: 24 + MediaQuery.viewPaddingOf(context).bottom,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _share(String name, LatLng position) {
    return SpringActions.share(
      context.l10n,
      documentId: _documentId,
      name: name,
      position: position,
    );
  }

  /// Opens the spring as a pinned marker in a maps app the user actually has.
  /// Shows the picker only when there is a real choice: 0 installed → silent
  /// Mapy.cz web fallback, 1 → open it directly, 2+ → let the user pick.
  Future<void> _openInMap(String name, LatLng position) async {
    final maps = await SpringActions.installedMaps();
    if (!mounted) return;

    final AvailableMap chosen;
    if (maps.isEmpty) {
      final opened = await SpringActions.openInBrowser(position);
      if (!opened && mounted) {
        showGlassSnackBar(
          context,
          message: context.l10n.spring_detail_navigation_failed,
        );
      }
      return;
    } else if (maps.length == 1) {
      chosen = maps.single;
    } else {
      final picked = await showMapPickerSheet(context, maps: maps);
      if (picked == null) return; // dismissed without choosing
      chosen = picked;
    }

    final opened = await SpringActions.showMarker(
      chosen,
      position: position,
      title: name,
    );
    if (!opened && mounted) {
      showGlassSnackBar(
        context,
        message: context.l10n.spring_detail_navigation_failed,
      );
    }
  }

  Future<void> _copyCoordinates(LatLng position) async {
    await SpringActions.copyCoordinates(position);
    if (!mounted) return;
    showGlassSnackBar(
      context,
      message: context.l10n.spring_detail_coordinates_copied,
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
