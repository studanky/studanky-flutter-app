import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_dto.g.dart';

@JsonSerializable()
class UserProfileDto {
  UserProfileDto({
    required this.id,
    required this.documentId,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.cowshedDocumentIds,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  final int id;
  final String documentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final List<String> cowshedDocumentIds;

  Map<String, dynamic> toJson() => _$UserProfileDtoToJson(this);
}
