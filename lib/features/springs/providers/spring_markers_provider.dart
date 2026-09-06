import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/springs/data/cached_spring_marker_repository.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_marker_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/providers/spring_markers_state.dart';

/// Deliberately **not** `autoDispose`: this is the session cache. The map page
/// and its cluster index come and go with the route, the fetched springs do
/// not — a returning map re-clusters from memory instead of re-fetching.
final springMarkersProvider =
    NotifierProvider<SpringMarkersNotifier, SpringMarkersState>(
      SpringMarkersNotifier.new,
    );

/// Owns the fetched springs for the whole app session and coalesces the
/// requests that fill them, delegating cache and fetch policy to
/// [SpringMarkerRepository].
///
/// Everything here is about not disturbing the map: a covered area returns
/// without touching state, an unchanged refresh keeps the previous list
/// instance, and a failure leaves the last known springs on screen.
class SpringMarkersNotifier extends Notifier<SpringMarkersState> {
  final Logger _logger = Logger('SpringMarkersNotifier');

  SpringMarkerRepository get _repository =>
      ref.read(springMarkerRepositoryProvider);

  /// The running drain, so concurrent callers join it instead of stacking.
  Future<void>? _inFlight;

  /// Camera waiting to be fetched. Keeping its locale and force flag in the
  /// same value makes an impossible half-updated pending state unrepresentable.
  /// Latest camera wins — an area the user has already panned past is not worth
  /// a request.
  _PendingMarkerLoad? _pending;

  @override
  SpringMarkersState build() {
    ref.onDispose(() {
      _pending = null;
      _disposed = true;
    });
    return const SpringMarkersState();
  }

  bool _disposed = false;

  /// Invalidates tile coverage for future reads without clearing the last
  /// drawable dataset. Any old-language request completing afterwards is
  /// ignored by [_load].
  void updateLanguageTag(String languageTag) {
    if (_disposed) return;
    if (state.languageTag == languageTag) return;
    state = state.copyWith(languageTag: languageTag);
    final pending = _pending;
    if (pending != null) {
      _pending = _PendingMarkerLoad(
        bounds: pending.bounds,
        languageTag: languageTag,
        force: pending.force,
      );
    }
  }

  /// Whether [bounds] already has data to draw, however old.
  bool hasDataFor(SpringBounds bounds, {required String languageTag}) =>
      _repository.hasDataFor(bounds, languageTag: languageTag);

  /// Ensures the springs inside [bounds] are loaded, and completes once they
  /// are. A no-op — no request, no state write — when the area is already
  /// covered and fresh, which is what keeps panning back to a visited area
  /// free.
  ///
  /// [force] re-fetches a covered area, used on app resume **while offline** to
  /// discover that the network came back: only a real request can, and its
  /// outcome drives the offline banner.
  ///
  /// A request arriving while another one runs is *queued*, not discarded: it
  /// replaces whatever was waiting and is served after the current round. The
  /// caller's future covers its own round, so panning into a new area mid-fetch
  /// still loads that area.
  Future<void> ensureLoaded(
    SpringBounds bounds, {
    required String languageTag,
    bool force = false,
  }) {
    updateLanguageTag(languageTag);
    if (!force && _repository.covers(bounds, languageTag: languageTag)) {
      return Future<void>.value();
    }

    _pending = _PendingMarkerLoad(
      bounds: bounds,
      languageTag: languageTag,
      force: force || (_pending?.force ?? false),
    );

    return _inFlight ??= _drain().whenComplete(() => _inFlight = null);
  }

  Future<void> _drain() async {
    while (true) {
      final request = _pending;
      if (request == null) return;
      _pending = null;

      // The round that just finished may already have covered this camera —
      // a wide fetch usually subsumes the pan that was queued behind it.
      if (!request.force &&
          _repository.covers(
            request.bounds,
            languageTag: request.languageTag,
          )) {
        continue;
      }

      await _load(request.bounds, request.languageTag);
    }
  }

  Future<void> _load(SpringBounds bounds, String languageTag) async {
    state = state.copyWith(status: const AsyncValue<void>.loading());

    final result = await _repository.load(bounds, languageTag: languageTag);

    // A locale flip can happen while the old request is on the wire. The
    // source may cache that complete old-locale response, but it is stale for
    // the active tag and must never overwrite the visible session state. A
    // queued camera round, when present, fetches the active locale next.
    if (_disposed) return;
    if (state.languageTag != languageTag) {
      // This method owns the loading state it emitted above. When no newer
      // camera round is queued, resolve that state locally instead of leaving
      // the map spinner waiting for an unrelated future camera event.
      // A pending round failed coverage for the active tag. The stale absorb
      // wrote only its old tag, and the drain resumes synchronously, so that
      // round cannot be skipped as newly covered and will settle this status.
      if (_pending == null && state.status.isLoading) {
        state = state.copyWith(status: const AsyncValue<void>.data(null));
      }
      return;
    }

    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          status: const AsyncValue<void>.data(null),
          // Keep the previous list when the data is unchanged (the common
          // outcome of a resume probe): freezed compares the state deeply, so
          // an equal state notifies nobody and the map is left alone.
          springs: listEquals(state.springs, data) ? state.springs : data,
        );
      case Failure(:final exception):
        _logger.severe('Failed to load springs', exception);
        state = state.copyWith(
          status: AsyncValue<void>.error(exception, StackTrace.current),
        );
    }
  }
}

class _PendingMarkerLoad {
  const _PendingMarkerLoad({
    required this.bounds,
    required this.languageTag,
    required this.force,
  });

  final SpringBounds bounds;
  final String languageTag;
  final bool force;
}
