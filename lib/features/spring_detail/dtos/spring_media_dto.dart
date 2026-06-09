import 'package:json_annotation/json_annotation.dart';

part 'spring_media_dto.g.dart';

/// A single Strapi media entry (the spring `photo`). Only the fields the client
/// renders are modelled; always use the absolute [url] returned by the server
/// (api-reference.md §1).
@JsonSerializable()
class SpringMediaDto {
  const SpringMediaDto({
    required this.url,
    this.width,
    this.height,
    this.formats,
  });

  factory SpringMediaDto.fromJson(Map<String, dynamic> json) =>
      _$SpringMediaDtoFromJson(json);

  final String url;
  final int? width;
  final int? height;
  final SpringMediaFormatsDto? formats;

  Map<String, dynamic> toJson() => _$SpringMediaDtoToJson(this);
}

@JsonSerializable()
class SpringMediaFormatsDto {
  const SpringMediaFormatsDto({this.thumbnail});

  factory SpringMediaFormatsDto.fromJson(Map<String, dynamic> json) =>
      _$SpringMediaFormatsDtoFromJson(json);

  final SpringMediaFormatDto? thumbnail;

  Map<String, dynamic> toJson() => _$SpringMediaFormatsDtoToJson(this);
}

@JsonSerializable()
class SpringMediaFormatDto {
  const SpringMediaFormatDto({required this.url});

  factory SpringMediaFormatDto.fromJson(Map<String, dynamic> json) =>
      _$SpringMediaFormatDtoFromJson(json);

  final String url;

  Map<String, dynamic> toJson() => _$SpringMediaFormatDtoToJson(this);
}
