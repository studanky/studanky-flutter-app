// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flow_range.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FlowRange {

 int get scale; double get minLps; double get maxLps;
/// Create a copy of FlowRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlowRangeCopyWith<FlowRange> get copyWith => _$FlowRangeCopyWithImpl<FlowRange>(this as FlowRange, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlowRange&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.minLps, minLps) || other.minLps == minLps)&&(identical(other.maxLps, maxLps) || other.maxLps == maxLps));
}


@override
int get hashCode => Object.hash(runtimeType,scale,minLps,maxLps);

@override
String toString() {
  return 'FlowRange(scale: $scale, minLps: $minLps, maxLps: $maxLps)';
}


}

/// @nodoc
abstract mixin class $FlowRangeCopyWith<$Res>  {
  factory $FlowRangeCopyWith(FlowRange value, $Res Function(FlowRange) _then) = _$FlowRangeCopyWithImpl;
@useResult
$Res call({
 int scale, double minLps, double maxLps
});




}
/// @nodoc
class _$FlowRangeCopyWithImpl<$Res>
    implements $FlowRangeCopyWith<$Res> {
  _$FlowRangeCopyWithImpl(this._self, this._then);

  final FlowRange _self;
  final $Res Function(FlowRange) _then;

/// Create a copy of FlowRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scale = null,Object? minLps = null,Object? maxLps = null,}) {
  return _then(_self.copyWith(
scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as int,minLps: null == minLps ? _self.minLps : minLps // ignore: cast_nullable_to_non_nullable
as double,maxLps: null == maxLps ? _self.maxLps : maxLps // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FlowRange].
extension FlowRangePatterns on FlowRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlowRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlowRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlowRange value)  $default,){
final _that = this;
switch (_that) {
case _FlowRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlowRange value)?  $default,){
final _that = this;
switch (_that) {
case _FlowRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scale,  double minLps,  double maxLps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlowRange() when $default != null:
return $default(_that.scale,_that.minLps,_that.maxLps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scale,  double minLps,  double maxLps)  $default,) {final _that = this;
switch (_that) {
case _FlowRange():
return $default(_that.scale,_that.minLps,_that.maxLps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scale,  double minLps,  double maxLps)?  $default,) {final _that = this;
switch (_that) {
case _FlowRange() when $default != null:
return $default(_that.scale,_that.minLps,_that.maxLps);case _:
  return null;

}
}

}

/// @nodoc


class _FlowRange extends FlowRange {
  const _FlowRange({required this.scale, required this.minLps, required this.maxLps}): super._();
  

@override final  int scale;
@override final  double minLps;
@override final  double maxLps;

/// Create a copy of FlowRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlowRangeCopyWith<_FlowRange> get copyWith => __$FlowRangeCopyWithImpl<_FlowRange>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlowRange&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.minLps, minLps) || other.minLps == minLps)&&(identical(other.maxLps, maxLps) || other.maxLps == maxLps));
}


@override
int get hashCode => Object.hash(runtimeType,scale,minLps,maxLps);

@override
String toString() {
  return 'FlowRange(scale: $scale, minLps: $minLps, maxLps: $maxLps)';
}


}

/// @nodoc
abstract mixin class _$FlowRangeCopyWith<$Res> implements $FlowRangeCopyWith<$Res> {
  factory _$FlowRangeCopyWith(_FlowRange value, $Res Function(_FlowRange) _then) = __$FlowRangeCopyWithImpl;
@override @useResult
$Res call({
 int scale, double minLps, double maxLps
});




}
/// @nodoc
class __$FlowRangeCopyWithImpl<$Res>
    implements _$FlowRangeCopyWith<$Res> {
  __$FlowRangeCopyWithImpl(this._self, this._then);

  final _FlowRange _self;
  final $Res Function(_FlowRange) _then;

/// Create a copy of FlowRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scale = null,Object? minLps = null,Object? maxLps = null,}) {
  return _then(_FlowRange(
scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as int,minLps: null == minLps ? _self.minLps : minLps // ignore: cast_nullable_to_non_nullable
as double,maxLps: null == maxLps ? _self.maxLps : maxLps // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
