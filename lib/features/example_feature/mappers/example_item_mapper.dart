import 'package:studanky_flutter_app/features/example_feature/dtos/example_item_dto.dart';
import 'package:studanky_flutter_app/features/example_feature/entities/example_item_entity.dart';

class ExampleItemMapper {
  const ExampleItemMapper._();

  static ExampleItemEntity fromDto(ExampleItemDto dto) {
    return ExampleItemEntity(
      id: dto.id,
      title: dto.title,
      description: dto.body,
      createdAt: dto.createdAt,
    );
  }
}
