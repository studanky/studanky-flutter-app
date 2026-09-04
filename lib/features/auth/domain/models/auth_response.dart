import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';

part 'auth_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthResponse {
  AuthResponse({this.jwt, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  final String? jwt;
  final UserDto user;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
