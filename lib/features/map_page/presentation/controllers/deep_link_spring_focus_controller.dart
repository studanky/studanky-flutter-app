import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_detail.dart';
import 'package:studanky_flutter_app/features/spring_detail/providers/spring_detail_provider.dart';

/// Owns the route-scoped detail subscription and focuses a shared spring once
/// its authoritative position and the map camera are both ready.
class DeepLinkSpringFocusController {
  DeepLinkSpringFocusController(this._ref, this._isMounted, this._onFocus);

  final WidgetRef _ref;
  final bool Function() _isMounted;
  final Future<void> Function(LatLng position) _onFocus;

  ProviderSubscription<AsyncValue<SpringDetail>>? _subscription;
  ({String documentId, String languageTag})? _subscriptionKey;
  ({String documentId, LatLng position})? _pending;
  String? _documentId;
  String? _focusedDocumentId;
  bool _mapReady = false;
  bool _scheduled = false;

  void update({required String? documentId, required String? languageTag}) {
    if (_documentId != documentId) {
      _documentId = documentId;
      _pending = null;
      _focusedDocumentId = null;
      _scheduled = false;
    }

    final key = documentId == null || languageTag == null
        ? null
        : (documentId: documentId, languageTag: languageTag);
    if (_subscriptionKey == key) return;

    _subscription?.close();
    _subscription = null;
    _subscriptionKey = key;
    if (key == null) return;

    _subscription = _ref.listenManual<AsyncValue<SpringDetail>>(
      springDetailProvider(key.documentId, languageTag: key.languageTag),
      (_, next) {
        final detail = next.value;
        if (detail != null) _queue(key.documentId, detail.position);
      },
      fireImmediately: true,
    );
  }

  void markMapReady() {
    _mapReady = true;
    _schedulePendingFocus();
  }

  void _queue(String documentId, LatLng position) {
    if (!_isMounted() ||
        _documentId != documentId ||
        _focusedDocumentId == documentId) {
      return;
    }
    _pending = (documentId: documentId, position: position);
    _schedulePendingFocus();
  }

  void _schedulePendingFocus() {
    if (!_mapReady || _pending == null || _scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      final pending = _pending;
      if (!_isMounted() ||
          !_mapReady ||
          pending == null ||
          _documentId != pending.documentId ||
          _focusedDocumentId == pending.documentId) {
        return;
      }

      _pending = null;
      _focusedDocumentId = pending.documentId;
      unawaited(_onFocus(pending.position));
    });
  }

  void dispose() {
    _subscription?.close();
  }
}
