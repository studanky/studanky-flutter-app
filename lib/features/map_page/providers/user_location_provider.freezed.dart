// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_location_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserLocationState {

 LocationStatus get status; bool get activated;
/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLocationStateCopyWith<UserLocationState> get copyWith => _$UserLocationStateCopyWithImpl<UserLocationState>(this as UserLocationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLocationState&&(identical(other.status, status) || other.status == status)&&(identical(other.activated, activated) || other.activated == activated));
}


@override
int get hashCode => Object.hash(runtimeType,status,activated);

@override
String toString() {
  return 'UserLocationState(status: $status, activated: $activated)';
}


}

/// @nodoc
abstract mixin class $UserLocationStateCopyWith<$Res>  {
  factory $UserLocationStateCopyWith(UserLocationState value, $Res Function(UserLocationState) _then) = _$UserLocationStateCopyWithImpl;
@useResult
$Res call({
 LocationStatus status, bool activated
});




}
/// @nodoc
class _$UserLocationStateCopyWithImpl<$Res>
    implements $UserLocationStateCopyWith<$Res> {
  _$UserLocationStateCopyWithImpl(this._self, this._then);

  final UserLocationState _self;
  final $Res Function(UserLocationState) _then;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? activated = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LocationStatus,activated: null == activated ? _self.activated : activated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserLocationState].
extension UserLocationStatePatterns on UserLocationState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLocationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLocationState value)  $default,){
final _that = this;
switch (_that) {
case _UserLocationState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLocationState value)?  $default,){
final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocationStatus status,  bool activated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
return $default(_that.status,_that.activated);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocationStatus status,  bool activated)  $default,) {final _that = this;
switch (_that) {
case _UserLocationState():
return $default(_that.status,_that.activated);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocationStatus status,  bool activated)?  $default,) {final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
return $default(_that.status,_that.activated);case _:
  return null;

}
}

}

/// @nodoc


class _UserLocationState implements UserLocationState {
  const _UserLocationState({this.status = LocationStatus.idle, this.activated = false});
  

@override@JsonKey() final  LocationStatus status;
@override@JsonKey() final  bool activated;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLocationStateCopyWith<_UserLocationState> get copyWith => __$UserLocationStateCopyWithImpl<_UserLocationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLocationState&&(identical(other.status, status) || other.status == status)&&(identical(other.activated, activated) || other.activated == activated));
}


@override
int get hashCode => Object.hash(runtimeType,status,activated);

@override
String toString() {
  return 'UserLocationState(status: $status, activated: $activated)';
}


}

/// @nodoc
abstract mixin class _$UserLocationStateCopyWith<$Res> implements $UserLocationStateCopyWith<$Res> {
  factory _$UserLocationStateCopyWith(_UserLocationState value, $Res Function(_UserLocationState) _then) = __$UserLocationStateCopyWithImpl;
@override @useResult
$Res call({
 LocationStatus status, bool activated
});




}
/// @nodoc
class __$UserLocationStateCopyWithImpl<$Res>
    implements _$UserLocationStateCopyWith<$Res> {
  __$UserLocationStateCopyWithImpl(this._self, this._then);

  final _UserLocationState _self;
  final $Res Function(_UserLocationState) _then;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? activated = null,}) {
  return _then(_UserLocationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LocationStatus,activated: null == activated ? _self.activated : activated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
