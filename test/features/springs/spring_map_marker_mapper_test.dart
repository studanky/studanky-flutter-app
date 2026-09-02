import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/features/springs/dtos/spring_map_marker_dto.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_status.dart';
import 'package:studanky_flutter_app/features/springs/mappers/spring_map_marker_mapper.dart';

void main() {
  group('SpringMapMarkerMapper', () {
    test('maps every field, parsing status and coordinates', () {
      final dto = SpringMapMarkerDto(
        documentId: 'k9f2a7b3c1d0e8',
        name: 'Ostružná',
        lat: 50.18,
        lng: 17.05,
        currentStatus: 'is_flowing',
        locale: 'cs',
        statusUpdatedAt: DateTime.utc(2026, 5, 31, 5),
      );

      final entity = SpringMapMarkerMapper.fromDto(dto);

      expect(entity.documentId, 'k9f2a7b3c1d0e8');
      expect(entity.name, 'Ostružná');
      expect(entity.position.latitude, 50.18);
      expect(entity.position.longitude, 17.05);
      expect(entity.status, SpringStatus.isFlowing);
      expect(entity.servedLanguageTag, 'cs');
      expect(entity.statusUpdatedAt, DateTime.utc(2026, 5, 31, 5));
    });

    test('null timestamp is preserved', () {
      const dto = SpringMapMarkerDto(
        documentId: 'd1',
        name: 'No reports yet',
        lat: 49.0,
        lng: 14.0,
        currentStatus: 'unknown',
      );

      expect(SpringMapMarkerMapper.fromDto(dto).statusUpdatedAt, isNull);
    });

    test('accepts a pre-1.5.0 marker without locale', () {
      final dto = SpringMapMarkerDto.fromJson(const {
        'documentId': 'd1',
        'name': 'Legacy spring',
        'lat': 49.0,
        'lng': 14.0,
        'current_status': 'unknown',
      });

      expect(dto.locale, isNull);
      expect(SpringMapMarkerMapper.fromDto(dto).servedLanguageTag, isNull);
    });
  });

  group('SpringStatus.fromWire', () {
    test('parses known values', () {
      expect(SpringStatus.fromWire('is_flowing'), SpringStatus.isFlowing);
      expect(
        SpringStatus.fromWire('is_not_flowing'),
        SpringStatus.isNotFlowing,
      );
      expect(SpringStatus.fromWire('unknown'), SpringStatus.unknown);
    });

    test('falls back to unknown for null or unrecognised values', () {
      expect(SpringStatus.fromWire(null), SpringStatus.unknown);
      expect(SpringStatus.fromWire('something_new'), SpringStatus.unknown);
    });
  });
}
