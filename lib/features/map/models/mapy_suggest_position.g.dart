// GENERATED CODE - MANUALLY MAINTAINED

part of 'mapy_suggest_position.dart';

MapySuggestPosition _$MapySuggestPositionFromJson(
    Map<String, dynamic> json) {
  double? parseCoordinate(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  return MapySuggestPosition(
    lat: parseCoordinate(json['lat'] ?? json['latitude']),
    lon: parseCoordinate(json['lon'] ?? json['longitude']),
  );
}

Map<String, dynamic> _$MapySuggestPositionToJson(
        MapySuggestPosition instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
    };
