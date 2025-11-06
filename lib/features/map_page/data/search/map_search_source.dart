import 'package:studanky_flutter_app/features/map_page/entities/map_search_result.dart';

/// Contract implemented by all marker search backends.
abstract class MapSearchSource {
  Future<List<MapSearchResult>> search(String query);
}
