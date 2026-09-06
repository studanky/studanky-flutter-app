import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location_state.freezed.dart';

enum LocationStatus { idle, ready, denied, deniedForever, serviceOff }

@freezed
abstract class UserLocationState with _$UserLocationState {
  const factory UserLocationState({
    @Default(LocationStatus.idle) LocationStatus status,
    @Default(false) bool activated,
  }) = _UserLocationState;
}
