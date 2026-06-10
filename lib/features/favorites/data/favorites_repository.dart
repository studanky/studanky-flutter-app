import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studanky_flutter_app/core/providers/shared_preferences_provider.dart';
import 'package:studanky_flutter_app/features/favorites/dtos/favorite_spring_dto.dart';
import 'package:studanky_flutter_app/features/favorites/mappers/favorite_spring_mapper.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'favorites_repository.g.dart';

/// Local, non-sensitive persistence of favourited springs as a JSON array in
/// [SharedPreferences]. Order is preserved (newest first, as written by the
/// controller).
class FavoritesRepository {
  FavoritesRepository(this._prefs);

  final SharedPreferences _prefs;
  final _logger = Logger('FavoritesRepository');

  static const String _key = 'favorite_springs';

  /// Reads all favourites; returns an empty list when nothing is stored or the
  /// payload is unreadable (e.g. an older schema).
  List<SpringMarkerEntity> read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return const [];

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map(
            (item) => FavoriteSpringMapper.fromDto(
              FavoriteSpringDto.fromJson(item as Map<String, dynamic>),
            ),
          )
          .toList(growable: false);
    } catch (error, stackTrace) {
      _logger.warning('Discarding unreadable favourites', error, stackTrace);
      return const [];
    }
  }

  Future<void> write(List<SpringMarkerEntity> favorites) async {
    final payload = favorites
        .map((spring) => FavoriteSpringMapper.toDto(spring).toJson())
        .toList(growable: false);
    await _prefs.setString(_key, jsonEncode(payload));
  }
}

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(Ref ref) =>
    FavoritesRepository(ref.watch(sharedPreferencesProvider));
