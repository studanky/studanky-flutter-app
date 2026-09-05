import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/controllers/map_marker_state.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/map_view_config.dart';

enum MapEmptyOverlayMode { hidden, empty, refreshing }

/// Owns the delayed empty-map presentation state independently of the view.
class MapEmptyStateController extends ChangeNotifier {
  Timer? _revealTimer;
  MapMarkerState _markerState = const MapMarkerState();
  MapEmptyOverlayMode _mode = MapEmptyOverlayMode.hidden;

  MapEmptyOverlayMode get mode => _mode;
  bool get isVisible => _mode != MapEmptyOverlayMode.hidden;
  bool get isRefreshing => _mode == MapEmptyOverlayMode.refreshing;

  void sync(MapMarkerState state) {
    _markerState = state;
    _revealTimer?.cancel();

    if (state.hasVisibleMarkers) {
      _setMode(MapEmptyOverlayMode.hidden);
      return;
    }

    if (state.status.isLoading || !state.visibleBoundsLoaded) {
      if (isVisible) _setMode(MapEmptyOverlayMode.refreshing);
      return;
    }

    if (state.status.hasError) {
      if (isVisible) _setMode(MapEmptyOverlayMode.empty);
      return;
    }

    if (!_isEligible(state)) {
      _setMode(MapEmptyOverlayMode.hidden);
      return;
    }

    if (isVisible) {
      _setMode(MapEmptyOverlayMode.empty);
      return;
    }

    _revealTimer = Timer(MapViewConfig.emptyStateRevealDelay, () {
      if (_isEligible(_markerState)) _setMode(MapEmptyOverlayMode.empty);
    });
  }

  void markRefreshing() {
    _revealTimer?.cancel();
    if (isVisible) _setMode(MapEmptyOverlayMode.refreshing);
  }

  bool _isEligible(MapMarkerState state) =>
      state.visibleBoundsLoaded &&
      !state.hasVisibleMarkers &&
      !state.status.isLoading &&
      !state.status.hasError;

  void _setMode(MapEmptyOverlayMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    super.dispose();
  }
}
