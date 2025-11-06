import 'package:studanky_flutter_app/features/example_feature/bos/example_item_bo.dart';
import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';

class ExampleItemMapper {
  const ExampleItemMapper._();

  static ExampleItemEntity fromBO(ExampleItemBO bo) {
    return ExampleItemEntity(
      id: bo.id,
      title: bo.title,
      description: bo.body,
      createdAt: bo.createdAt,
    );
  }
}
