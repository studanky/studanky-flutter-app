import 'package:studanky_flutter_app/features/spring_getter/entities/spring_bounds.dart';
import 'package:studanky_flutter_app/features/spring_getter/entities/spring_entity.dart';

abstract class SpringSource {
  Future<List<SpringEntity>> loadSprings(SpringBounds bounds);
}

class InMemorySpringSource implements SpringSource {
  InMemorySpringSource(this._springs);

  final List<SpringEntity> _springs;

  List<SpringEntity> get allSprings => List.unmodifiable(_springs);

  @override
  Future<List<SpringEntity>> loadSprings(SpringBounds bounds) async {
    return _springs
        .where(
          (spring) => bounds.containsPosition(
            latitude: spring.position.latitude,
            longitude: spring.position.longitude,
          ),
        )
        .toList(growable: false);
  }
}
