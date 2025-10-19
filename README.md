# studanky_flutter_app

A Flutter app for exploring and cataloguing springs.

## Map Feature Architecture

The map stack is powered by Flutter Map and Riverpod:

- `lib/features/map/providers/map_marker_providers.dart` keeps the marker cache responsive. `MapMarkerState` separates fetched markers from user-added points, while `MapMarkerNotifier` lazily loads markers as the camera moves and merges them into a single list for the UI.
- `lib/features/map/providers/map_search_providers.dart` introduces debounced autocomplete powered by the Mapy.cz suggest API (with caching and a local fallback). `MapSearchNotifier` emits `MapSearchResult` entries for the UI.
- `lib/features/map/data/mapy_suggest_api_client.dart` wraps the Dio HTTP client and request building for the suggest endpoint; `lib/features/map/data/mapy_suggest_search_source.dart`, `in_memory_map_search_source.dart`, and `map_marker_source_adapter.dart` compose that client (or local data) into caching/lazy-loading `MapSearchSource` implementations, with `logger` providing structured diagnostics.
- `lib/features/map/models/mapy_suggest_response.dart`, `mapy_suggest_item.dart`, and `mapy_suggest_position.dart` contain the annotated DTOs (`json_serializable`) that decode suggest responses, ensuring the search layer stays type-safe.
- `lib/features/map/map_content.dart` renders the map, listens to camera events, and presents the search overlay. Selecting a search result recentres the map and keeps the marker cache in sync.

### Extending the Search Flow

1. Swap the search source by overriding `mapSearchSourceProvider` with your API client.
2. Update `MapSearchState` or the marker model if you need richer metadata in the results.
3. The UI pulls directly from Riverpod, so new fields surface automatically.
4. Provide a `MAPY_API_KEY` (via `--dart-define` or by editing `MapyConfig`) to enable the remote suggest API; otherwise the feature falls back to local marker search.

### Running the Feature

1. `flutter pub get`
2. `flutter run`
3. Use the search box to find existing markers (e.g. “Prague”), or pan the map to load nearby springs.
