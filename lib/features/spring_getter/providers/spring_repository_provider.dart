import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/features/spring_getter/providers/spring_source_provider.dart';
import 'package:studanky_flutter_app/features/spring_getter/repositories/spring_repository.dart';

final springRepositoryProvider = Provider<SpringRepository>((ref) {
  final source = ref.watch(springSourceProvider);
  return SpringRepositoryImpl(source);
});
