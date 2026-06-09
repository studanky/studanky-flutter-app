import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/spring_detail_repository.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';

part 'spring_reports_provider.freezed.dart';
part 'spring_reports_provider.g.dart';

/// Accumulated, lazily-paginated report history for one spring.
@freezed
abstract class SpringReportsState with _$SpringReportsState {
  const factory SpringReportsState({
    /// Reports loaded so far, newest first.
    @Default(<Report>[]) List<Report> reports,

    /// Status of the **first** page load — drives the section's main
    /// loading/error/empty rendering.
    @Default(AsyncValue<void>.loading()) AsyncValue<void> initialStatus,

    /// A subsequent page is being fetched (footer spinner).
    @Default(false) bool isLoadingMore,

    /// Whether another page is available after what is loaded.
    @Default(false) bool hasMore,

    /// 1-based page to request next.
    @Default(1) int nextPage,

    /// Total number of records reported by the server.
    @Default(0) int total,

    /// Error of the most recent [SpringReports.loadMore] (footer retry), kept
    /// separate so a failed page never wipes already-loaded reports.
    Object? loadMoreError,
  }) = _SpringReportsState;

  const SpringReportsState._();

  bool get isInitialLoading => initialStatus.isLoading;
  bool get hasInitialError => initialStatus.hasError;
  bool get isEmpty => reports.isEmpty && initialStatus.hasValue;
}

/// Drives infinite scroll over `GET /springs/:id/reports` (api-reference.md
/// §3.3): page 1 loads on open, further pages are appended on [SpringReports.loadMore].
@riverpod
class SpringReports extends _$SpringReports {
  SpringDetailRepository get _repository =>
      ref.read(springDetailRepositoryProvider);

  @override
  SpringReportsState build(String documentId) {
    Future.microtask(_loadInitial);
    return const SpringReportsState();
  }

  Future<void> _loadInitial() async {
    state = state.copyWith(initialStatus: const AsyncValue.loading());

    final result = await _repository.fetchReports(documentId, page: 1);
    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          reports: data.items,
          initialStatus: const AsyncValue.data(null),
          hasMore: data.hasMore,
          nextPage: data.page + 1,
          total: data.total,
          loadMoreError: null,
        );
      case Failure(:final exception):
        state = state.copyWith(
          initialStatus: AsyncValue.error(exception, StackTrace.current),
        );
    }
  }

  /// Loads and appends the next page. No-op while a load is in flight, when the
  /// first page hasn't settled, or when there is nothing more to fetch.
  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.initialStatus.isLoading) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, loadMoreError: null);

    final result = await _repository.fetchReports(
      documentId,
      page: state.nextPage,
    );
    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          reports: [...state.reports, ...data.items],
          isLoadingMore: false,
          hasMore: data.hasMore,
          nextPage: data.page + 1,
          total: data.total,
        );
      case Failure(:final exception):
        state = state.copyWith(isLoadingMore: false, loadMoreError: exception);
    }
  }

  /// Retry after a failed first page.
  Future<void> retryInitial() => _loadInitial();
}
