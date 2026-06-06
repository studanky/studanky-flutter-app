import 'package:json_annotation/json_annotation.dart';

part 'example_item_dto.g.dart';

@JsonSerializable()
class ExampleItemDto {
  const ExampleItemDto({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory ExampleItemDto.fromJson(Map<String, dynamic> json) =>
      _$ExampleItemDtoFromJson(json);

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$ExampleItemDtoToJson(this);
}
