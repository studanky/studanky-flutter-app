// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spring_markers_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpringMarkersState {

 AsyncValue<void> get status; List<SpringMarkerEntity> get springs; String? get languageTag;
/// Create a copy of SpringMarkersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpringMarkersStateCopyWith<SpringMarkersState> get copyWith => _$SpringMarkersStateCopyWithImpl<SpringMarkersState>(this as SpringMarkersState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpringMarkersState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpringMarkersState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.springs, _this.springs)&&(identical(other.languageTag, _this.languageTag) || other.languageTag == _this.languageTag));
}


@override
int get hashCode {
  final _this = this as SpringMarkersState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.springs),_this.languageTag);
}

@override
String toString() {
  final _this = this as SpringMarkersState;
  return 'SpringMarkersState(status: ${_this.status}, springs: ${_this.springs}, languageTag: ${_this.languageTag})';
}


}

/// @nodoc
abstract mixin class $SpringMarkersStateCopyWith<$Res>  {
  factory $SpringMarkersStateCopyWith(SpringMarkersState value, $Res Function(SpringMarkersState) _then) = _$SpringMarkersStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<void> status, List<SpringMarkerEntity> springs, String? languageTag
});




}
/// @nodoc
class _$SpringMarkersStateCopyWithImpl<$Res>
    implements $SpringMarkersStateCopyWith<$Res> {
  _$SpringMarkersStateCopyWithImpl(this._self, this._then);

  final SpringMarkersState _self;
  final $Res Function(SpringMarkersState) _then;

/// Create a copy of SpringMarkersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? springs = null,Object? languageTag = freezed,}) {
  return _then(SpringMarkersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,springs: null == springs ? _self.springs : springs // ignore: cast_nullable_to_non_nullable
as List<SpringMarkerEntity>,languageTag: freezed == languageTag ? _self.languageTag : languageTag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpringMarkersState].
extension SpringMarkersStatePatterns on SpringMarkersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpringMarkersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpringMarkersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpringMarkersState value)  $default,){
final _that = this;
switch (_that) {
case _SpringMarkersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpringMarkersState value)?  $default,){
final _that = this;
switch (_that) {
case _SpringMarkersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<void> status,  List<SpringMarkerEntity> springs,  String? languageTag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpringMarkersState() when $default != null:
return $default(_that.status,_that.springs,_that.languageTag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<void> status,  List<SpringMarkerEntity> springs,  String? languageTag)  $default,) {final _that = this;
switch (_that) {
case _SpringMarkersState():
return $default(_that.status,_that.springs,_that.languageTag);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<void> status,  List<SpringMarkerEntity> springs,  String? languageTag)?  $default,) {final _that = this;
switch (_that) {
case _SpringMarkersState() when $default != null:
return $default(_that.status,_that.springs,_that.languageTag);case _:
  return null;

}
}

}

/// @nodoc


class _SpringMarkersState implements SpringMarkersState {
  const _SpringMarkersState({this.status = const AsyncValue<void>.data(null),  List<SpringMarkerEntity> springs = const <SpringMarkerEntity>[], this.languageTag}): _springs = springs;
  

@override@JsonKey() final  AsyncValue<void> status;
 final  List<SpringMarkerEntity> _springs;
@override@JsonKey() List<SpringMarkerEntity> get springs {
  if (_springs is EqualUnmodifiableListView) return _springs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_springs);
}

@override final  String? languageTag;

/// Create a copy of SpringMarkersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpringMarkersStateCopyWith<_SpringMarkersState> get copyWith => __$SpringMarkersStateCopyWithImpl<_SpringMarkersState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpringMarkersState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.springs, _springs)&&(identical(other.languageTag, languageTag) || other.languageTag == languageTag));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_springs),languageTag);
}

@override
String toString() {
    return 'SpringMarkersState(status: $status, springs: $springs, languageTag: $languageTag)';
}


}

/// @nodoc
abstract mixin class _$SpringMarkersStateCopyWith<$Res> implements $SpringMarkersStateCopyWith<$Res> {
  factory _$SpringMarkersStateCopyWith(_SpringMarkersState value, $Res Function(_SpringMarkersState) _then) = __$SpringMarkersStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<void> status, List<SpringMarkerEntity> springs, String? languageTag
});




}
/// @nodoc
class __$SpringMarkersStateCopyWithImpl<$Res>
    implements _$SpringMarkersStateCopyWith<$Res> {
  __$SpringMarkersStateCopyWithImpl(this._self, this._then);

  final _SpringMarkersState _self;
  final $Res Function(_SpringMarkersState) _then;

/// Create a copy of SpringMarkersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? springs = null,Object? languageTag = freezed,}) {
  return _then(_SpringMarkersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,springs: null == springs ? _self._springs : springs // ignore: cast_nullable_to_non_nullable
as List<SpringMarkerEntity>,languageTag: freezed == languageTag ? _self.languageTag : languageTag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
