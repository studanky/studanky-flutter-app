// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      identifier: json['identifier'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'password': instance.password,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      jwt: json['jwt'] as String?,
      user: UserBO.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
      'user': instance.user.toJson(),
    };

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordRequest(
      email: json['email'] as String,
    );

Map<String, dynamic> _$ForgotPasswordRequestToJson(
        ForgotPasswordRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

ResetPasswordRequest _$ResetPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordRequest(
      code: json['code'] as String,
      password: json['password'] as String,
      passwordConfirmation: json['passwordConfirmation'] as String,
    );

Map<String, dynamic> _$ResetPasswordRequestToJson(
        ResetPasswordRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'password': instance.password,
      'passwordConfirmation': instance.passwordConfirmation,
    };

SendEmailConfirmationRequest _$SendEmailConfirmationRequestFromJson(
        Map<String, dynamic> json) =>
    SendEmailConfirmationRequest(
      email: json['email'] as String,
    );

Map<String, dynamic> _$SendEmailConfirmationRequestToJson(
        SendEmailConfirmationRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

GeneratePasswordRequest _$GeneratePasswordRequestFromJson(
        Map<String, dynamic> json) =>
    GeneratePasswordRequest(
      email: json['email'] as String,
    );

Map<String, dynamic> _$GeneratePasswordRequestToJson(
        GeneratePasswordRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
    };
