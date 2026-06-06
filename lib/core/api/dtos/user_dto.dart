import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDto {
  UserDto({
    required this.id,
    required this.username,
    required this.email,
    required this.confirmed,
    required this.blocked,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  final int id;
  final String username;
  final String email;
  final bool confirmed;
  final bool blocked;

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
