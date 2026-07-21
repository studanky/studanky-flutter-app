// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spring_markers_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpringMarkersState implements DiagnosticableTreeMixin {

/// Loading/error of the fetch. [springs] stays intact while one runs, so
/// this is a thin status channel, not the source of markers.
 AsyncValue<void> get status;/// Every spring fetched so far. Which *areas* those cover is the source's
/// business — ask [SpringMarkersNotifier.hasDataFor] rather than inferring
/// coverage from this list, because an area that genuinely holds no springs
/// contributes nothing to it.
 List<SpringMarkerEntity> get springs;
/// Create a copy of SpringMarkersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpringMarkersStateCopyWith<SpringMarkersState> get copyWith => _$SpringMarkersStateCopyWithImpl<SpringMarkersState>(this as SpringMarkersState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpringMarkersState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('springs', springs));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpringMarkersState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.springs, springs));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(springs));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpringMarkersState(status: $status, springs: $springs)';
}


}

/// @nodoc
abstract mixin class $SpringMarkersStateCopyWith<$Res>  {
  factory $SpringMarkersStateCopyWith(SpringMarkersState value, $Res Function(SpringMarkersState) _then) = _$SpringMarkersStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<void> status, List<SpringMarkerEntity> springs
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? springs = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,springs: null == springs ? _self.springs : springs // ignore: cast_nullable_to_non_nullable
as List<SpringMarkerEntity>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<void> status,  List<SpringMarkerEntity> springs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpringMarkersState() when $default != null:
return $default(_that.status,_that.springs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<void> status,  List<SpringMarkerEntity> springs)  $default,) {final _that = this;
switch (_that) {
case _SpringMarkersState():
return $default(_that.status,_that.springs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<void> status,  List<SpringMarkerEntity> springs)?  $default,) {final _that = this;
switch (_that) {
case _SpringMarkersState() when $default != null:
return $default(_that.status,_that.springs);case _:
  return null;

}
}

}

/// @nodoc


class _SpringMarkersState with DiagnosticableTreeMixin implements SpringMarkersState {
  const _SpringMarkersState({this.status = const AsyncValue<void>.data(null), final  List<SpringMarkerEntity> springs = const <SpringMarkerEntity>[]}): _springs = springs;
  

/// Loading/error of the fetch. [springs] stays intact while one runs, so
/// this is a thin status channel, not the source of markers.
@override@JsonKey() final  AsyncValue<void> status;
/// Every spring fetched so far. Which *areas* those cover is the source's
/// business — ask [SpringMarkersNotifier.hasDataFor] rather than inferring
/// coverage from this list, because an area that genuinely holds no springs
/// contributes nothing to it.
 final  List<SpringMarkerEntity> _springs;
/// Every spring fetched so far. Which *areas* those cover is the source's
/// business — ask [SpringMarkersNotifier.hasDataFor] rather than inferring
/// coverage from this list, because an area that genuinely holds no springs
/// contributes nothing to it.
@override@JsonKey() List<SpringMarkerEntity> get springs {
  if (_springs is EqualUnmodifiableListView) return _springs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_springs);
}


/// Create a copy of SpringMarkersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpringMarkersStateCopyWith<_SpringMarkersState> get copyWith => __$SpringMarkersStateCopyWithImpl<_SpringMarkersState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpringMarkersState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('springs', springs));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpringMarkersState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._springs, _springs));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_springs));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpringMarkersState(status: $status, springs: $springs)';
}


}

/// @nodoc
abstract mixin class _$SpringMarkersStateCopyWith<$Res> implements $SpringMarkersStateCopyWith<$Res> {
  factory _$SpringMarkersStateCopyWith(_SpringMarkersState value, $Res Function(_SpringMarkersState) _then) = __$SpringMarkersStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<void> status, List<SpringMarkerEntity> springs
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? springs = null,}) {
  return _then(_SpringMarkersState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,springs: null == springs ? _self._springs : springs // ignore: cast_nullable_to_non_nullable
as List<SpringMarkerEntity>,
  ));
}


}

// dart format on
