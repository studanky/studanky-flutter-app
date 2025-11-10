import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/features/map_page/repositories/map_marker_repository.dart';
import 'package:studanky_flutter_app/features/spring_getter/providers/spring_repository_provider.dart';

final mapMarkerRepositoryProvider = Provider<MapMarkerRepository>((ref) {
  final springRepository = ref.watch(springRepositoryProvider);
  return MapMarkerRepositoryImpl(springRepository);
});
