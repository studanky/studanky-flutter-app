import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/haptics/haptics.dart';
import 'package:studanky_flutter_app/features/favorites/providers/favorites_provider.dart';
import 'package:studanky_flutter_app/features/platform_config/providers/platform_config_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/controllers/spring_detail_view_state.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_detail_provider.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_reports_provider.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'spring_detail_controller.g.dart';

/// Composes detail, reports, favourites and platform config into one UI state
/// and exposes the commands available from the detail screen.
@riverpod
class SpringDetailController extends _$SpringDetailController {
  @override
  SpringDetailViewState build(
    String documentId, {
    required String languageTag,
    SpringMarkerEntity? marker,
  }) {
    final detailAsync = ref.watch(
      springDetailProvider(documentId, languageTag: languageTag),
    );
    final reports = ref.watch(springReportsProvider(documentId));
    final config = ref.watch(platformConfigControllerProvider);
    final isFavorite = ref.watch(
      favoritesControllerProvider.select(
        (favorites) =>
            favorites.any((spring) => spring.documentId == documentId),
      ),
    );

    return SpringDetailViewState(
      detailAsync: detailAsync,
      reports: reports,
      config: config,
      marker: marker,
      isFavorite: isFavorite,
    );
  }

  Future<void> toggleFavorite() async {
    final candidate = state.favoriteCandidate(documentId);
    if (candidate == null) return;
    state.isFavorite ? Haptics.selection() : Haptics.toggle();
    await ref.read(favoritesControllerProvider.notifier).toggle(candidate);
  }

  void retryDetail() {
    ref.invalidate(springDetailProvider(documentId, languageTag: languageTag));
  }

  Future<void> retryReports() =>
      ref.read(springReportsProvider(documentId).notifier).retryInitial();

  Future<void> loadMoreReports() =>
      ref.read(springReportsProvider(documentId).notifier).loadMore();
}
