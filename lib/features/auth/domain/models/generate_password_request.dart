import 'package:json_annotation/json_annotation.dart';

part 'generate_password_request.g.dart';

@JsonSerializable()
class GeneratePasswordRequest {
  GeneratePasswordRequest({required this.email});

  factory GeneratePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$GeneratePasswordRequestFromJson(json);

  final String email;

  Map<String, dynamic> toJson() => _$GeneratePasswordRequestToJson(this);
}
