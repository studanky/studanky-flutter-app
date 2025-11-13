// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_scan_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrScanState {

 AsyncValue<QrScanResult?> get capture;
/// Create a copy of QrScanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrScanStateCopyWith<QrScanState> get copyWith => _$QrScanStateCopyWithImpl<QrScanState>(this as QrScanState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrScanState&&(identical(other.capture, capture) || other.capture == capture));
}


@override
int get hashCode => Object.hash(runtimeType,capture);

@override
String toString() {
  return 'QrScanState(capture: $capture)';
}


}

/// @nodoc
abstract mixin class $QrScanStateCopyWith<$Res>  {
  factory $QrScanStateCopyWith(QrScanState value, $Res Function(QrScanState) _then) = _$QrScanStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<QrScanResult?> capture
});




}
/// @nodoc
class _$QrScanStateCopyWithImpl<$Res>
    implements $QrScanStateCopyWith<$Res> {
  _$QrScanStateCopyWithImpl(this._self, this._then);

  final QrScanState _self;
  final $Res Function(QrScanState) _then;

/// Create a copy of QrScanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? capture = null,}) {
  return _then(_self.copyWith(
capture: null == capture ? _self.capture : capture // ignore: cast_nullable_to_non_nullable
as AsyncValue<QrScanResult?>,
  ));
}

}


/// Adds pattern-matching-related methods to [QrScanState].
extension QrScanStatePatterns on QrScanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrScanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrScanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrScanState value)  $default,){
final _that = this;
switch (_that) {
case _QrScanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrScanState value)?  $default,){
final _that = this;
switch (_that) {
case _QrScanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<QrScanResult?> capture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrScanState() when $default != null:
return $default(_that.capture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<QrScanResult?> capture)  $default,) {final _that = this;
switch (_that) {
case _QrScanState():
return $default(_that.capture);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<QrScanResult?> capture)?  $default,) {final _that = this;
switch (_that) {
case _QrScanState() when $default != null:
return $default(_that.capture);case _:
  return null;

}
}

}

/// @nodoc


class _QrScanState extends QrScanState {
  const _QrScanState({this.capture = const AsyncValue<QrScanResult?>.data(null)}): super._();
  

@override@JsonKey() final  AsyncValue<QrScanResult?> capture;

/// Create a copy of QrScanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrScanStateCopyWith<_QrScanState> get copyWith => __$QrScanStateCopyWithImpl<_QrScanState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrScanState&&(identical(other.capture, capture) || other.capture == capture));
}


@override
int get hashCode => Object.hash(runtimeType,capture);

@override
String toString() {
  return 'QrScanState(capture: $capture)';
}


}

/// @nodoc
abstract mixin class _$QrScanStateCopyWith<$Res> implements $QrScanStateCopyWith<$Res> {
  factory _$QrScanStateCopyWith(_QrScanState value, $Res Function(_QrScanState) _then) = __$QrScanStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<QrScanResult?> capture
});




}
/// @nodoc
class __$QrScanStateCopyWithImpl<$Res>
    implements _$QrScanStateCopyWith<$Res> {
  __$QrScanStateCopyWithImpl(this._self, this._then);

  final _QrScanState _self;
  final $Res Function(_QrScanState) _then;

/// Create a copy of QrScanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? capture = null,}) {
  return _then(_QrScanState(
capture: null == capture ? _self.capture : capture // ignore: cast_nullable_to_non_nullable
as AsyncValue<QrScanResult?>,
  ));
}


}

// dart format on
