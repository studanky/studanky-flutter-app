import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'spring_marker_source.g.dart';

/// Fetch strategy for map markers **and the bookkeeping of what is already
/// covered**. The single place that decides when the network is touched, so the
/// layers above it (session store, cluster index, map page) never deal with
/// bounding boxes at all.
///
/// [covers] and [hasDataFor] are deliberately *synchronous*, and deliberately
/// separate: the first answers "does this need a request", the second "do we
/// have an answer to show". They differ for data that is present but past its
/// time-to-live — that area still draws its markers while a refresh runs
/// behind it.
abstract class SpringMarkerSource {
  /// Whether [bounds] is fully fetched **and still fresh**. False means
  /// [load] has work to do.
  bool covers(SpringBounds bounds);

  /// Whether [bounds] has been fetched at all, however long ago. Drives "there
  /// are no springs here": a stale answer is still an answer, and withdrawing
  /// the message during a background refresh would make it blink.
  bool hasDataFor(SpringBounds bounds);

  /// Fetches whatever [bounds] still needs and returns **all** markers known
  /// afterwards — never just the new ones, so callers can treat the result as
  /// the complete dataset.
  Future<ApiResult<List<SpringMarkerEntity>>> load(SpringBounds bounds);
}

/// Viewport cache keyed by a fixed lat/lng grid.
///
/// Coverage is a *set of tiles*, not a rectangle. That distinction is the whole
/// point: a single "last fetched bounds" rectangle is destroyed by the next pan,
/// so returning to an area you already visited re-fetches it. A tile set only
/// grows, so a pan back is free — while the camera still never pulls more than
/// the area it is actually looking at.
///
/// Each tile carries its own fetch timestamp, so staleness expires per area
/// rather than all at once, and a long-running session keeps refreshing what
/// the user is actually looking at.
class TileGridSpringMarkerSource implements SpringMarkerSource {
  TileGridSpringMarkerSource(
    this._repository, {
    DateTime Function()? clock,
    this.maxAge = defaultMaxAge,
    this.tileSize = defaultTileSize,
  }) : _now = clock ?? DateTime.now;

  /// Grid step in degrees. At Czech latitudes one tile is roughly 55 × 36 km —
  /// far larger than a viewport at browsing zoom, so ordinary panning stays
  /// inside already-fetched tiles, and small enough that zooming into a region
  /// never drags the rest of the country along.
  static const double defaultTileSize = 0.5;

  /// How long a tile stays fresh.
  ///
  /// Sized against two opposing facts. Statuses change **several times a day**
  /// — they are not a once-daily ČHMÚ sync but user reports arriving as people
  /// walk past springs — so hours would leave the map confidently wrong.
  /// Meanwhile a browsing session (zoom in, pan away, come back, open a detail,
  /// come back again) runs a few minutes at most, and re-fetching *inside* one
  /// is exactly the reloading this cache exists to stop.
  ///
  /// Five minutes clears a whole session, so panning back is always free, while
  /// a report published now reaches other users within five minutes of them
  /// looking that way. The map is trip-planning advice, not a live gauge, so
  /// that is well inside tolerance — and the marker already renders its own
  /// staleness from `status_updated_at`, which is about the *reading's* age and
  /// stays honest regardless of how long the tile was cached.
  static const Duration defaultMaxAge = Duration(minutes: 5);

  final SpringRepository _repository;
  final DateTime Function() _now;
  final Duration maxAge;
  final double tileSize;

  final Map<_Tile, _TileData> _tiles = {};

  @override
  bool covers(SpringBounds bounds) {
    final deadline = _now().subtract(maxAge);
    return _tilesIn(bounds).every((tile) => _tiles[tile]?.isFreshAt(deadline) ?? false);
  }

  @override
  bool hasDataFor(SpringBounds bounds) => _tilesIn(bounds).every(_tiles.containsKey);

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> load(SpringBounds bounds) async {
    final rect = _requestRect(bounds);
    // No tiles to aim at — a box that wraps the antimeridian, which this
    // grid does not model. [covers] already reports such a camera as covered,
    // so only a forced probe can land here; there is nothing to request.
    if (rect == null) return ApiResult.success(_allSprings());

    final result = await _repository.fetchMapMarkers(rect.toBounds(tileSize));

    switch (result) {
      case Success(:final data):
        _absorb(rect, data);
        return ApiResult.success(_allSprings());
      case Failure(:final exception):
        // Tiles keep their previous contents and timestamps: a failed refresh
        // must neither blank the map nor pass off missing data as fetched.
        return ApiResult.failure(exception);
    }
  }

  /// The grid-aligned rectangle to request. Aiming at tile boundaries rather
  /// than at the raw viewport is what makes a tile's contents *complete* — a
  /// request clipped mid-tile would leave a hole that coverage bookkeeping
  /// could not see.
  _TileRect? _requestRect(SpringBounds bounds) {
    final tiles = _tilesIn(bounds).toList(growable: false);
    if (tiles.isEmpty) return null;

    final deadline = _now().subtract(maxAge);
    final stale = tiles
        .where((tile) => !(_tiles[tile]?.isFreshAt(deadline) ?? false))
        .toList(growable: false);

    // A forced refresh over fully fresh tiles has nothing stale to aim at, but
    // still has to put a real request on the wire — so it re-fetches the
    // viewport.
    return _TileRect.spanning(stale.isEmpty ? tiles : stale);
  }

  void _absorb(_TileRect rect, List<SpringMarkerEntity> data) {
    final fetchedAt = _now();
    final grouped = <_Tile, List<SpringMarkerEntity>>{};

    for (final spring in data) {
      final tile = _tileFor(spring);
      // A spring sitting exactly on the rectangle's outer edge belongs to a
      // tile this request did not cover completely. Leave it to that tile's own
      // fetch instead of recording half an answer.
      if (!rect.contains(tile)) continue;
      (grouped[tile] ??= <SpringMarkerEntity>[]).add(spring);
    }

    // Every tile in the rectangle is rewritten, including those that came back
    // empty — "no springs here" is worth caching. Rewriting rather than merging
    // is also what lets a spring deleted on the backend disappear.
    for (final tile in rect.tiles) {
      _tiles[tile] = _TileData(
        springs: grouped[tile] ?? const <SpringMarkerEntity>[],
        fetchedAt: fetchedAt,
      );
    }
  }

  /// Every cached spring, deduped by `documentId`, most recently fetched tile
  /// winning.
  ///
  /// A spring lives in exactly one tile — the one [_tileFor] puts it in — so
  /// the same row cannot land in two tiles from one response, not even sitting
  /// exactly on a boundary. Duplicates come from *coordinates changing*: a
  /// correction that moves a spring across a tile edge leaves the old tile
  /// holding it until that tile is re-fetched, and two pins for one spring
  /// would show meanwhile.
  ///
  /// Picking by [_TileData.fetchedAt] rather than by iteration order matters:
  /// tiles are walked in the order they were first created, which says nothing
  /// about how recently each was refreshed, so "last one wins" could keep the
  /// stale copy. Writing an existing key leaves its original position, so the
  /// result order stays stable — an unchanged dataset has to compare equal
  /// upstream or the cluster index rebuilds on every fetch.
  List<SpringMarkerEntity> _allSprings() {
    final byId = <String, SpringMarkerEntity>{};
    final takenFrom = <String, DateTime>{};

    for (final data in _tiles.values) {
      for (final spring in data.springs) {
        final incumbent = takenFrom[spring.documentId];
        if (incumbent != null && incumbent.isAfter(data.fetchedAt)) continue;
        byId[spring.documentId] = spring;
        takenFrom[spring.documentId] = data.fetchedAt;
      }
    }

    return byId.values.toList(growable: false);
  }

  _Tile _tileFor(SpringMarkerEntity spring) => _Tile(
    _index(spring.position.longitude),
    _index(spring.position.latitude),
  );

  int _index(double degrees) => (degrees / tileSize).floor();

  /// Every tile the box touches. Bounded in practice by the map's minimum zoom:
  /// the widest camera spans a few thousand tiles, which is cheap to walk on
  /// each camera change.
  Iterable<_Tile> _tilesIn(SpringBounds bounds) sync* {
    for (var x = _index(bounds.west); x <= _index(bounds.east); x++) {
      for (var y = _index(bounds.south); y <= _index(bounds.north); y++) {
        yield _Tile(x, y);
      }
    }
  }
}

@immutable
class _Tile {
  const _Tile(this.x, this.y);

  final int x;
  final int y;

  @override
  bool operator ==(Object other) =>
      other is _Tile && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

class _TileData {
  const _TileData({required this.springs, required this.fetchedAt});

  final List<SpringMarkerEntity> springs;
  final DateTime fetchedAt;

  bool isFreshAt(DateTime deadline) => fetchedAt.isAfter(deadline);
}

/// A rectangular block of tiles — what a single request covers.
class _TileRect {
  const _TileRect({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  factory _TileRect.spanning(List<_Tile> tiles) {
    var minX = tiles.first.x;
    var maxX = tiles.first.x;
    var minY = tiles.first.y;
    var maxY = tiles.first.y;

    for (final tile in tiles.skip(1)) {
      if (tile.x < minX) minX = tile.x;
      if (tile.x > maxX) maxX = tile.x;
      if (tile.y < minY) minY = tile.y;
      if (tile.y > maxY) maxY = tile.y;
    }

    return _TileRect(minX: minX, maxX: maxX, minY: minY, maxY: maxY);
  }

  final int minX;
  final int maxX;
  final int minY;
  final int maxY;

  bool contains(_Tile tile) =>
      tile.x >= minX && tile.x <= maxX && tile.y >= minY && tile.y <= maxY;

  Iterable<_Tile> get tiles sync* {
    for (var x = minX; x <= maxX; x++) {
      for (var y = minY; y <= maxY; y++) {
        yield _Tile(x, y);
      }
    }
  }

  SpringBounds toBounds(double tileSize) => SpringBounds(
    west: minX * tileSize,
    east: (maxX + 1) * tileSize,
    south: minY * tileSize,
    north: (maxY + 1) * tileSize,
  );
}

@Riverpod(keepAlive: true)
SpringMarkerSource springMarkerSource(Ref ref) =>
    TileGridSpringMarkerSource(ref.watch(springRepositoryProvider));
