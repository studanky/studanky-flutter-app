import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_bo.g.dart';

@JsonSerializable(explicitToJson: true)
class UserBO {
  UserBO({
    required this.id,
    required this.username,
    required this.email,
    required this.confirmed,
    required this.blocked,
  });

  factory UserBO.fromJson(Map<String, dynamic> json) => _$UserBOFromJson(json);

  final int id;
  final String username;
  final String email;
  final bool confirmed;
  final bool blocked;

  Map<String, dynamic> toJson() => _$UserBOToJson(this);
}
