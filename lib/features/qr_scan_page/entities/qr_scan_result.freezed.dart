// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_scan_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrScanResult {

 String get value; BarcodeFormat? get format; DateTime get scannedAt;
/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrScanResultCopyWith<QrScanResult> get copyWith => _$QrScanResultCopyWithImpl<QrScanResult>(this as QrScanResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrScanResult&&(identical(other.value, value) || other.value == value)&&(identical(other.format, format) || other.format == format)&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt));
}


@override
int get hashCode => Object.hash(runtimeType,value,format,scannedAt);

@override
String toString() {
  return 'QrScanResult(value: $value, format: $format, scannedAt: $scannedAt)';
}


}

/// @nodoc
abstract mixin class $QrScanResultCopyWith<$Res>  {
  factory $QrScanResultCopyWith(QrScanResult value, $Res Function(QrScanResult) _then) = _$QrScanResultCopyWithImpl;
@useResult
$Res call({
 String value, BarcodeFormat? format, DateTime scannedAt
});




}
/// @nodoc
class _$QrScanResultCopyWithImpl<$Res>
    implements $QrScanResultCopyWith<$Res> {
  _$QrScanResultCopyWithImpl(this._self, this._then);

  final QrScanResult _self;
  final $Res Function(QrScanResult) _then;

/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? format = freezed,Object? scannedAt = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BarcodeFormat?,scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [QrScanResult].
extension QrScanResultPatterns on QrScanResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrScanResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrScanResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrScanResult value)  $default,){
final _that = this;
switch (_that) {
case _QrScanResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrScanResult value)?  $default,){
final _that = this;
switch (_that) {
case _QrScanResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  BarcodeFormat? format,  DateTime scannedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrScanResult() when $default != null:
return $default(_that.value,_that.format,_that.scannedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  BarcodeFormat? format,  DateTime scannedAt)  $default,) {final _that = this;
switch (_that) {
case _QrScanResult():
return $default(_that.value,_that.format,_that.scannedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  BarcodeFormat? format,  DateTime scannedAt)?  $default,) {final _that = this;
switch (_that) {
case _QrScanResult() when $default != null:
return $default(_that.value,_that.format,_that.scannedAt);case _:
  return null;

}
}

}

/// @nodoc


class _QrScanResult extends QrScanResult {
  const _QrScanResult({required this.value, required this.format, required this.scannedAt}): super._();
  

@override final  String value;
@override final  BarcodeFormat? format;
@override final  DateTime scannedAt;

/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrScanResultCopyWith<_QrScanResult> get copyWith => __$QrScanResultCopyWithImpl<_QrScanResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrScanResult&&(identical(other.value, value) || other.value == value)&&(identical(other.format, format) || other.format == format)&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt));
}


@override
int get hashCode => Object.hash(runtimeType,value,format,scannedAt);

@override
String toString() {
  return 'QrScanResult(value: $value, format: $format, scannedAt: $scannedAt)';
}


}

/// @nodoc
abstract mixin class _$QrScanResultCopyWith<$Res> implements $QrScanResultCopyWith<$Res> {
  factory _$QrScanResultCopyWith(_QrScanResult value, $Res Function(_QrScanResult) _then) = __$QrScanResultCopyWithImpl;
@override @useResult
$Res call({
 String value, BarcodeFormat? format, DateTime scannedAt
});




}
/// @nodoc
class __$QrScanResultCopyWithImpl<$Res>
    implements _$QrScanResultCopyWith<$Res> {
  __$QrScanResultCopyWithImpl(this._self, this._then);

  final _QrScanResult _self;
  final $Res Function(_QrScanResult) _then;

/// Create a copy of QrScanResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? format = freezed,Object? scannedAt = null,}) {
  return _then(_QrScanResult(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BarcodeFormat?,scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
