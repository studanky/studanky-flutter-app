import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

part 'spring_markers_state.freezed.dart';

@freezed
abstract class SpringMarkersState with _$SpringMarkersState {
  const factory SpringMarkersState({
    @Default(AsyncValue<void>.data(null)) AsyncValue<void> status,
    @Default(<SpringMarkerEntity>[]) List<SpringMarkerEntity> springs,
    String? languageTag,
  }) = _SpringMarkersState;
}
