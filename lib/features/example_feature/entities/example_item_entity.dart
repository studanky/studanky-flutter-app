import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_item_entity.freezed.dart';

@freezed
abstract class ExampleItemEntity with _$ExampleItemEntity {
  const factory ExampleItemEntity({
    required String id,
    required String title,
    required String description,
    required DateTime createdAt,
  }) = _ExampleItemEntity;
}
