import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_bo.g.dart';

@JsonSerializable()
class UserProfileBO {
  UserProfileBO({
    required this.id,
    required this.documentId,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.cowshedDocumentIds,
  });

  factory UserProfileBO.fromJson(Map<String, dynamic> json) =>
      _$UserProfileBOFromJson(json);

  final int id;
  final String documentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final List<String> cowshedDocumentIds;

  Map<String, dynamic> toJson() => _$UserProfileBOToJson(this);
}
