// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBO _$UserBOFromJson(Map<String, dynamic> json) => UserBO(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String,
  confirmed: json['confirmed'] as bool,
  blocked: json['blocked'] as bool,
);

Map<String, dynamic> _$UserBOToJson(UserBO instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'confirmed': instance.confirmed,
  'blocked': instance.blocked,
};
