import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/widgets/app_progress_indicator.dart';
import 'package:studanky_flutter_app/core/widgets/error_widget.dart';
import 'package:studanky_flutter_app/core/widgets/glass_snack_bar.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/services/spring_map_service.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/controllers/spring_detail_controller.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/services/spring_detail_action_service.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/map_picker_sheet.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/report_history_section.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/sheet_grabber.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/spring_detail_header.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/widgets/spring_photo_view.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Scrollable detail view backed by one presentation controller.
class SpringDetailView extends ConsumerStatefulWidget {
  const SpringDetailView({
    required this.documentId,
    required this.marker,
    required this.scrollController,
    super.key,
  });

  final String documentId;
  final SpringMarkerEntity? marker;
  final ScrollController scrollController;

  @override
  ConsumerState<SpringDetailView> createState() => _SpringDetailViewState();
}

class _SpringDetailViewState extends ConsumerState<SpringDetailView> {
  static const double _loadMoreThreshold = 400;
  String? _languageTag;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageTag = Localizations.localeOf(context).toLanguageTag();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final scrollController = widget.scrollController;
    final languageTag = _languageTag;
    if (!scrollController.hasClients || languageTag == null) return;
    final position = scrollController.position;
    if (position.pixels < position.maxScrollExtent - _loadMoreThreshold) return;
    ref
        .read(
          springDetailControllerProvider(
            widget.documentId,
            languageTag: languageTag,
            marker: widget.marker,
          ).notifier,
        )
        .loadMoreReports();
  }

  @override
  Widget build(BuildContext context) {
    final languageTag = Localizations.localeOf(context).toLanguageTag();
    final provider = springDetailControllerProvider(
      widget.documentId,
      languageTag: languageTag,
      marker: widget.marker,
    );
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final name = state.name;
    final position = state.position;
    return ScrollEdgeEffect(
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          const SliverToBoxAdapter(child: SheetGrabber()),
          if (!state.canRender)
            SliverFillRemaining(
              hasScrollBody: false,
              child: state.detailAsync.hasError
                  ? AppErrorWidget(
                      error: state.detailAsync.error!,
                      stackTrace:
                          state.detailAsync.stackTrace ?? StackTrace.empty,
                      onRefresh: controller.retryDetail,
                    )
                  : const AppProgressIndicator(),
            )
          else ...[
            if (state.detail?.photo != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: ClipRSuperellipse(
                    borderRadius: BorderRadius.circular(kRadiusControl),
                    child: SpringPhotoView(photo: state.detail!.photo!),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SpringDetailHeader(
                name: name!,
                statusIcon: state.statusIcon!,
                statusUpdatedAt: state.statusUpdatedAt,
                position: position!,
                description: state.detail?.description,
                flowScale: state.flowScale,
                flowRateLps: state.flowRateLps,
                clarity: state.clarity,
                maxFlowScale: state.maxFlowScale,
                onShare: () => _share(name, position),
                onNavigate: () => _openInMap(name, position),
                onCopyCoordinates: () => _copyCoordinates(position),
                isFavorite: state.isFavorite,
                onToggleFavorite: controller.toggleFavorite,
              ),
            ),
            ...buildReportHistorySlivers(
              context,
              state: state.reports,
              maxFlowScale: state.maxFlowScale,
              onRetry: controller.retryReports,
              onRetryLoadMore: controller.loadMoreReports,
            ),
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

  SpringDetailActionService get _actions =>
      ref.read(springDetailActionServiceProvider);

  Future<void> _share(String name, LatLng position) {
    return _actions.share(
      context.l10n,
      documentId: widget.documentId,
      name: name,
      position: position,
    );
  }

  Future<void> _openInMap(String name, LatLng position) async {
    final maps = await _actions.installedMaps(position: position, title: name);
    if (!mounted) return;

    final SpringMapOption chosen;
    if (maps.isEmpty) {
      final opened = await _actions.openMapFallback(position);
      if (!opened && mounted) _showNavigationFailure();
      return;
    } else if (maps.length == 1) {
      chosen = maps.single;
    } else {
      final picked = await showMapPickerSheet(context, maps: maps);
      if (picked == null) return;
      chosen = picked;
    }

    final opened = await _actions.openMap(chosen);
    if (!opened && mounted) _showNavigationFailure();
  }

  void _showNavigationFailure() {
    showGlassSnackBar(
      context,
      message: context.l10n.spring_detail_navigation_failed,
    );
  }

  Future<void> _copyCoordinates(LatLng position) async {
    await _actions.copyCoordinates(position);
    if (!mounted) return;
    showGlassSnackBar(
      context,
      message: context.l10n.spring_detail_coordinates_copied,
    );
  }
}
