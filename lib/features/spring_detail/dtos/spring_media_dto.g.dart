// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spring_media_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpringMediaDto _$SpringMediaDtoFromJson(Map<String, dynamic> json) =>
    SpringMediaDto(
      url: json['url'] as String,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      formats: json['formats'] == null
          ? null
          : SpringMediaFormatsDto.fromJson(
              json['formats'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SpringMediaDtoToJson(SpringMediaDto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'formats': instance.formats?.toJson(),
    };

SpringMediaFormatsDto _$SpringMediaFormatsDtoFromJson(
  Map<String, dynamic> json,
) => SpringMediaFormatsDto(
  thumbnail: json['thumbnail'] == null
      ? null
      : SpringMediaFormatDto.fromJson(
          json['thumbnail'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SpringMediaFormatsDtoToJson(
  SpringMediaFormatsDto instance,
) => <String, dynamic>{'thumbnail': instance.thumbnail?.toJson()};

SpringMediaFormatDto _$SpringMediaFormatDtoFromJson(
  Map<String, dynamic> json,
) => SpringMediaFormatDto(url: json['url'] as String);

Map<String, dynamic> _$SpringMediaFormatDtoToJson(
  SpringMediaFormatDto instance,
) => <String, dynamic>{'url': instance.url};
