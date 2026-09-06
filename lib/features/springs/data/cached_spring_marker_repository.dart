import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/core/api/utils/api_result.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_marker_repository.dart';
import 'package:studanky_flutter_app/features/springs/data/spring_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'cached_spring_marker_repository.g.dart';

/// Viewport cache keyed by a fixed lat/lng grid.
///
/// Coverage is a *set of tiles*, not a rectangle. That distinction is the whole
/// point: a single "last fetched bounds" rectangle is destroyed by the next pan,
/// so returning to an area you already visited re-fetches it. Independently
/// retained tiles make a pan back free while they remain inside the session
/// cache — and the camera still never pulls more than the area it is looking at.
///
/// Each tile carries its request locale and fetch timestamp, so locale/age
/// staleness expires per area rather than creating an immortal full cache per
/// locale. Retention and an LRU capacity bound keep a long-running session from
/// accumulating every area the user has ever visited.
class CachedSpringMarkerRepository implements SpringMarkerRepository {
  CachedSpringMarkerRepository(
    this._repository, {
    DateTime Function()? clock,
    this.maxAge = defaultMaxAge,
    this.tileSize = defaultTileSize,
    Duration? retentionAge,
    this.maxTileCount = defaultMaxTileCount,
  }) : _now = clock ?? DateTime.now,
       retentionAge = retentionAge ?? maxAge * defaultRetentionMultiplier,
       assert(tileSize > 0),
       assert(maxAge > Duration.zero),
       assert(retentionAge == null || retentionAge >= maxAge),
       assert(maxTileCount > 0);

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

  /// Stale tiles may remain useful during a short back-and-forth map session,
  /// but retaining them indefinitely only grows memory. Six cache lifetimes
  /// keeps that navigation cheap while old regions disappear after 30 minutes
  /// with the default TTL.
  static const int defaultRetentionMultiplier = 6;

  /// Hard safety bound for session memory. This is deliberately well above a
  /// padded phone/tablet viewport at the minimum supported zoom, so normal
  /// camera loads are retained as a whole while an unusually long journey is
  /// still bounded.
  static const int defaultMaxTileCount = 32768;

  final SpringRepository _repository;
  final DateTime Function() _now;
  final Duration maxAge;
  final double tileSize;
  final Duration retentionAge;
  final int maxTileCount;

  final Map<_Tile, _TileData> _tiles = {};
  int _accessSequence = 0;

  @override
  bool covers(SpringBounds bounds, {required String languageTag}) {
    final now = _now();
    final deadline = now.subtract(maxAge);
    var containsTile = false;
    var allFresh = true;
    for (final tile in _tilesIn(bounds)) {
      containsTile = true;
      final data = _touch(tile);
      if (!(data?.isFreshAt(deadline, languageTag: languageTag) ?? false)) {
        allFresh = false;
      }
    }
    return containsTile && allFresh;
  }

  @override
  bool hasDataFor(SpringBounds bounds, {required String languageTag}) {
    var containsTile = false;
    var allPresent = true;
    for (final tile in _tilesIn(bounds)) {
      containsTile = true;
      if (_touch(tile)?.languageTag != languageTag) allPresent = false;
    }
    return containsTile && allPresent;
  }

  @override
  Future<ApiResult<List<SpringMarkerEntity>>> load(
    SpringBounds bounds, {
    required String languageTag,
  }) async {
    final rect = _requestRect(bounds, languageTag);
    // No tiles to aim at — a box that wraps the antimeridian, which this
    // Czech-focused grid does not model. It remains uncovered rather than
    // being cached as an empty successful area.
    if (rect == null) return ApiResult.success(_allSprings());

    final result = await _repository.fetchMapMarkers(
      bounds: rect.toBounds(tileSize),
      languageTag: languageTag,
    );

    switch (result) {
      case Success(:final data):
        _absorb(rect, data, languageTag);
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
  _TileRect? _requestRect(SpringBounds bounds, String languageTag) {
    final now = _now();
    final tiles = _tilesIn(bounds).toList(growable: false);
    if (tiles.isEmpty) return null;

    final deadline = now.subtract(maxAge);
    final stale = tiles
        .where(
          (tile) =>
              !(_touch(tile)?.isFreshAt(deadline, languageTag: languageTag) ??
                  false),
        )
        .toList(growable: false);

    // A forced refresh over fully fresh tiles has nothing stale to aim at, but
    // still has to put a real request on the wire — so it re-fetches the
    // viewport.
    return _TileRect.spanning(stale.isEmpty ? tiles : stale);
  }

  void _absorb(
    _TileRect rect,
    List<SpringMarkerEntity> data,
    String languageTag,
  ) {
    final fetchedAt = _now();
    // Retention is memory housekeeping, not coverage logic. Amortize its O(n)
    // scan onto successful cache writes instead of every camera/state query.
    _purgeExpired(fetchedAt);
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
        languageTag: languageTag,
        lastAccessOrder: ++_accessSequence,
      );
    }
    _enforceCapacity();
  }

  _TileData? _touch(_Tile tile) {
    final data = _tiles[tile];
    if (data != null) data.lastAccessOrder = ++_accessSequence;
    return data;
  }

  void _purgeExpired(DateTime now) {
    final deadline = now.subtract(retentionAge);
    _tiles.removeWhere((_, data) => !data.fetchedAt.isAfter(deadline));
  }

  void _enforceCapacity() {
    final overflow = _tiles.length - maxTileCount;
    if (overflow <= 0) return;

    final leastRecentlyUsed = _tiles.entries.toList(growable: false)
      ..sort(
        (a, b) => a.value.lastAccessOrder.compareTo(b.value.lastAccessOrder),
      );
    for (final entry in leastRecentlyUsed.take(overflow)) {
      _tiles.remove(entry.key);
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
  _TileData({
    required this.springs,
    required this.fetchedAt,
    required this.languageTag,
    required this.lastAccessOrder,
  });

  final List<SpringMarkerEntity> springs;
  final DateTime fetchedAt;
  final String languageTag;
  int lastAccessOrder;

  bool isFreshAt(DateTime deadline, {required String languageTag}) =>
      this.languageTag == languageTag && fetchedAt.isAfter(deadline);
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
SpringMarkerRepository springMarkerRepository(Ref ref) =>
    CachedSpringMarkerRepository(ref.watch(springRepositoryProvider));
