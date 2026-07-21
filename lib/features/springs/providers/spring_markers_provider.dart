import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_marker_source.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'spring_markers_provider.freezed.dart';

/// Deliberately **not** `autoDispose`: this is the session cache. The map page
/// and its cluster index come and go with the route, the fetched springs do
/// not — a returning map re-clusters from memory instead of re-fetching.
final springMarkersProvider =
    NotifierProvider<SpringMarkersNotifier, SpringMarkersState>(
      SpringMarkersNotifier.new,
    );

@freezed
abstract class SpringMarkersState with _$SpringMarkersState {
  const factory SpringMarkersState({
    /// Loading/error of the fetch. [springs] stays intact while one runs, so
    /// this is a thin status channel, not the source of markers.
    @Default(AsyncValue<void>.data(null)) AsyncValue<void> status,

    /// Every spring fetched so far. Which *areas* those cover is the source's
    /// business — ask [SpringMarkersNotifier.hasDataFor] rather than inferring
    /// coverage from this list, because an area that genuinely holds no springs
    /// contributes nothing to it.
    @Default(<SpringMarkerEntity>[]) List<SpringMarkerEntity> springs,
  }) = _SpringMarkersState;
}

/// Owns the fetched springs for the whole app session and coalesces the
/// requests that fill them, delegating *when* to fetch to [SpringMarkerSource].
///
/// Everything here is about not disturbing the map: a covered area returns
/// without touching state, an unchanged refresh keeps the previous list
/// instance, and a failure leaves the last known springs on screen.
class SpringMarkersNotifier extends Notifier<SpringMarkersState> {
  final Logger _logger = Logger('SpringMarkersNotifier');

  SpringMarkerSource get _source => ref.read(springMarkerSourceProvider);

  /// The running drain, so concurrent callers join it instead of stacking.
  Future<void>? _inFlight;

  /// Camera waiting to be fetched. Latest wins — an area the user has already
  /// panned past is not worth a request.
  SpringBounds? _pending;
  bool _pendingForce = false;

  @override
  SpringMarkersState build() => const SpringMarkersState();

  /// Whether [bounds] already has data to draw, however old.
  bool hasDataFor(SpringBounds bounds) => _source.hasDataFor(bounds);

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
  Future<void> ensureLoaded(SpringBounds bounds, {bool force = false}) {
    if (!force && _source.covers(bounds)) return Future<void>.value();

    _pending = bounds;
    _pendingForce |= force;

    return _inFlight ??= _drain().whenComplete(() => _inFlight = null);
  }

  Future<void> _drain() async {
    while (_pending != null) {
      final bounds = _pending!;
      final force = _pendingForce;
      _pending = null;
      _pendingForce = false;

      // The round that just finished may already have covered this camera —
      // a wide fetch usually subsumes the pan that was queued behind it.
      if (!force && _source.covers(bounds)) continue;

      await _load(bounds);
    }
  }

  Future<void> _load(SpringBounds bounds) async {
    state = state.copyWith(status: const AsyncValue<void>.loading());

    final result = await _source.load(bounds);

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
