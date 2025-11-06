import 'package:studanky_flutter_app/features/spring_getter/data/spring_source.dart';
import 'package:studanky_flutter_app/features/spring_getter/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/spring_getter/entities/spring_entity.dart';

abstract class SpringRepository {
  Future<List<SpringEntity>> fetchSprings(SpringBounds bounds);

  Future<List<SpringEntity>> fetchAllSprings();
}

class SpringRepositoryImpl implements SpringRepository {
  SpringRepositoryImpl(this._source);

  final SpringSource _source;

  @override
  Future<List<SpringEntity>> fetchSprings(SpringBounds bounds) {
    return _source.loadSprings(bounds);
  }

  @override
  Future<List<SpringEntity>> fetchAllSprings() {
    return _source.loadSprings(SpringBounds.global);
  }
}
