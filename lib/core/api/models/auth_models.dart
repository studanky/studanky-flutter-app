import 'package:json_annotation/json_annotation.dart';
import 'package:studanky_flutter_app/core/api/bos/user_bo.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class LoginRequest {
  LoginRequest({required this.identifier, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  final String identifier;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  final String username;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AuthResponse {
  AuthResponse({this.jwt, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  final String? jwt; // JWT is optional for registration with email verification
  final UserBO user;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class ForgotPasswordRequest {
  ForgotPasswordRequest({required this.email});

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  final String email;

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  ResetPasswordRequest({
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  final String code;
  final String password;
  final String passwordConfirmation;

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      ChangePasswordRequest(
        currentPassword: json['currentPassword'] as String,
        password: json['password'] as String,
        passwordConfirmation: json['passwordConfirmation'] as String,
      );

  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  Map<String, dynamic> toJson() => {
    'currentPassword': currentPassword,
    'password': password,
    'passwordConfirmation': passwordConfirmation,
  };
}

@JsonSerializable()
class SendEmailConfirmationRequest {
  SendEmailConfirmationRequest({required this.email});

  factory SendEmailConfirmationRequest.fromJson(Map<String, dynamic> json) =>
      _$SendEmailConfirmationRequestFromJson(json);

  final String email;

  Map<String, dynamic> toJson() => _$SendEmailConfirmationRequestToJson(this);
}

@JsonSerializable()
class GeneratePasswordRequest {
  GeneratePasswordRequest({required this.email});

  factory GeneratePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$GeneratePasswordRequestFromJson(json);

  final String email;

  Map<String, dynamic> toJson() => _$GeneratePasswordRequestToJson(this);
}
