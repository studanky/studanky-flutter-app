import 'package:json_annotation/json_annotation.dart';

part 'spring_owner_dto.g.dart';

/// The B2B owner of a spring (e.g. ČHMÚ) as returned when `owner` is populated
/// (api-reference.md §3.2).
@JsonSerializable()
class SpringOwnerDto {
  const SpringOwnerDto({required this.name, this.documentId, this.type});

  factory SpringOwnerDto.fromJson(Map<String, dynamic> json) =>
      _$SpringOwnerDtoFromJson(json);

  final String? documentId;
  final String name;
  final String? type;

  Map<String, dynamic> toJson() => _$SpringOwnerDtoToJson(this);
}
