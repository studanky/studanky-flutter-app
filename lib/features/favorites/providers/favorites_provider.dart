import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/features/favorites/data/favorites_repository.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'favorites_provider.g.dart';

/// Owns the list of favourited springs (newest first) and keeps it persisted.
///
/// Reads are synchronous (SharedPreferences is resolved at startup), so the
/// state is available immediately for the map button, the popup and the detail
/// toggle.
@Riverpod(keepAlive: true)
class FavoritesController extends _$FavoritesController {
  FavoritesRepository get _repository => ref.read(favoritesRepositoryProvider);

  @override
  List<SpringMarkerEntity> build() => _repository.read();

  bool isFavorite(String documentId) =>
      state.any((spring) => spring.documentId == documentId);

  /// Adds [spring] to favourites, or removes it if already saved. Returns the
  /// new favourite status (true = now saved).
  Future<bool> toggle(SpringMarkerEntity spring) async {
    final nowFavorite = !isFavorite(spring.documentId);
    state = nowFavorite
        ? [spring, ...state]
        : state
              .where((s) => s.documentId != spring.documentId)
              .toList(growable: false);
    await _repository.write(state);
    return nowFavorite;
  }

  Future<void> remove(String documentId) async {
    if (!isFavorite(documentId)) return;
    state = state
        .where((s) => s.documentId != documentId)
        .toList(growable: false);
    await _repository.write(state);
  }
}
