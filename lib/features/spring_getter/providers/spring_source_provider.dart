import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/spring_getter/data/spring_source.dart';
import 'package:studanky_flutter_app/features/spring_getter/entities/spring_entity.dart';

final springSourceProvider = Provider<SpringSource>((ref) {
  return InMemorySpringSource(const [
    SpringEntity(position: LatLng(49.5638, 15.9398), label: 'Zelená hora'),
    SpringEntity(position: LatLng(49.5613, 15.9380), label: 'Town Square'),
    SpringEntity(position: LatLng(49.5695, 15.9482), label: 'Pilská Reservoir'),
    SpringEntity(
      position: LatLng(49.5554, 15.9301),
      label: 'Sádek Forest Trail',
    ),
    SpringEntity(position: LatLng(49.5842, 15.9556), label: 'Sv. Jan Well'),
    SpringEntity(position: LatLng(50.0755, 14.4378), label: 'Prague Old Town'),
  ]);
});
