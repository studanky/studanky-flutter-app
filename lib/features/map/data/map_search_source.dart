import 'package:studanky_flutter_app/features/map/models/map_search_result.dart';

/// Contract implemented by all marker search backends.
abstract class MapSearchSource {
  Future<List<MapSearchResult>> search(String query);
}
