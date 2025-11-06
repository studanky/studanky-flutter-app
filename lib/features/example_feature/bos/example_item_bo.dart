import 'package:json_annotation/json_annotation.dart';

part 'example_item_bo.g.dart';

@JsonSerializable()
class ExampleItemBO {
  const ExampleItemBO({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory ExampleItemBO.fromJson(Map<String, dynamic> json) =>
      _$ExampleItemBOFromJson(json);

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$ExampleItemBOToJson(this);
}
