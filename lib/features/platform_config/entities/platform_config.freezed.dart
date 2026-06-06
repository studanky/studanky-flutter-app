// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlatformConfig {

/// Age after which a status is considered "stale" (spec default 14 days).
 Duration get freshnessThreshold;/// l/s → 1–5 mapping table. Empty until the ranges component is populated.
 List<FlowRange> get flowScaleRanges;
/// Create a copy of PlatformConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformConfigCopyWith<PlatformConfig> get copyWith => _$PlatformConfigCopyWithImpl<PlatformConfig>(this as PlatformConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformConfig&&(identical(other.freshnessThreshold, freshnessThreshold) || other.freshnessThreshold == freshnessThreshold)&&const DeepCollectionEquality().equals(other.flowScaleRanges, flowScaleRanges));
}


@override
int get hashCode => Object.hash(runtimeType,freshnessThreshold,const DeepCollectionEquality().hash(flowScaleRanges));

@override
String toString() {
  return 'PlatformConfig(freshnessThreshold: $freshnessThreshold, flowScaleRanges: $flowScaleRanges)';
}


}

/// @nodoc
abstract mixin class $PlatformConfigCopyWith<$Res>  {
  factory $PlatformConfigCopyWith(PlatformConfig value, $Res Function(PlatformConfig) _then) = _$PlatformConfigCopyWithImpl;
@useResult
$Res call({
 Duration freshnessThreshold, List<FlowRange> flowScaleRanges
});




}
/// @nodoc
class _$PlatformConfigCopyWithImpl<$Res>
    implements $PlatformConfigCopyWith<$Res> {
  _$PlatformConfigCopyWithImpl(this._self, this._then);

  final PlatformConfig _self;
  final $Res Function(PlatformConfig) _then;

/// Create a copy of PlatformConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? freshnessThreshold = null,Object? flowScaleRanges = null,}) {
  return _then(_self.copyWith(
freshnessThreshold: null == freshnessThreshold ? _self.freshnessThreshold : freshnessThreshold // ignore: cast_nullable_to_non_nullable
as Duration,flowScaleRanges: null == flowScaleRanges ? _self.flowScaleRanges : flowScaleRanges // ignore: cast_nullable_to_non_nullable
as List<FlowRange>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformConfig].
extension PlatformConfigPatterns on PlatformConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformConfig value)  $default,){
final _that = this;
switch (_that) {
case _PlatformConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformConfig value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Duration freshnessThreshold,  List<FlowRange> flowScaleRanges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformConfig() when $default != null:
return $default(_that.freshnessThreshold,_that.flowScaleRanges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Duration freshnessThreshold,  List<FlowRange> flowScaleRanges)  $default,) {final _that = this;
switch (_that) {
case _PlatformConfig():
return $default(_that.freshnessThreshold,_that.flowScaleRanges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Duration freshnessThreshold,  List<FlowRange> flowScaleRanges)?  $default,) {final _that = this;
switch (_that) {
case _PlatformConfig() when $default != null:
return $default(_that.freshnessThreshold,_that.flowScaleRanges);case _:
  return null;

}
}

}

/// @nodoc


class _PlatformConfig extends PlatformConfig {
  const _PlatformConfig({required this.freshnessThreshold, required final  List<FlowRange> flowScaleRanges}): _flowScaleRanges = flowScaleRanges,super._();
  

/// Age after which a status is considered "stale" (spec default 14 days).
@override final  Duration freshnessThreshold;
/// l/s → 1–5 mapping table. Empty until the ranges component is populated.
 final  List<FlowRange> _flowScaleRanges;
/// l/s → 1–5 mapping table. Empty until the ranges component is populated.
@override List<FlowRange> get flowScaleRanges {
  if (_flowScaleRanges is EqualUnmodifiableListView) return _flowScaleRanges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_flowScaleRanges);
}


/// Create a copy of PlatformConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformConfigCopyWith<_PlatformConfig> get copyWith => __$PlatformConfigCopyWithImpl<_PlatformConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformConfig&&(identical(other.freshnessThreshold, freshnessThreshold) || other.freshnessThreshold == freshnessThreshold)&&const DeepCollectionEquality().equals(other._flowScaleRanges, _flowScaleRanges));
}


@override
int get hashCode => Object.hash(runtimeType,freshnessThreshold,const DeepCollectionEquality().hash(_flowScaleRanges));

@override
String toString() {
  return 'PlatformConfig(freshnessThreshold: $freshnessThreshold, flowScaleRanges: $flowScaleRanges)';
}


}

/// @nodoc
abstract mixin class _$PlatformConfigCopyWith<$Res> implements $PlatformConfigCopyWith<$Res> {
  factory _$PlatformConfigCopyWith(_PlatformConfig value, $Res Function(_PlatformConfig) _then) = __$PlatformConfigCopyWithImpl;
@override @useResult
$Res call({
 Duration freshnessThreshold, List<FlowRange> flowScaleRanges
});




}
/// @nodoc
class __$PlatformConfigCopyWithImpl<$Res>
    implements _$PlatformConfigCopyWith<$Res> {
  __$PlatformConfigCopyWithImpl(this._self, this._then);

  final _PlatformConfig _self;
  final $Res Function(_PlatformConfig) _then;

/// Create a copy of PlatformConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? freshnessThreshold = null,Object? flowScaleRanges = null,}) {
  return _then(_PlatformConfig(
freshnessThreshold: null == freshnessThreshold ? _self.freshnessThreshold : freshnessThreshold // ignore: cast_nullable_to_non_nullable
as Duration,flowScaleRanges: null == flowScaleRanges ? _self._flowScaleRanges : flowScaleRanges // ignore: cast_nullable_to_non_nullable
as List<FlowRange>,
  ));
}


}

// dart format on
