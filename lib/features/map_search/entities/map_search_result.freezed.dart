// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapSearchResult {

 String get label; LatLng get position; MapSearchResultType get type;
/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapSearchResultCopyWith<MapSearchResult> get copyWith => _$MapSearchResultCopyWithImpl<MapSearchResult>(this as MapSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapSearchResult&&(identical(other.label, label) || other.label == label)&&(identical(other.position, position) || other.position == position)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,label,position,type);

@override
String toString() {
  return 'MapSearchResult(label: $label, position: $position, type: $type)';
}


}

/// @nodoc
abstract mixin class $MapSearchResultCopyWith<$Res>  {
  factory $MapSearchResultCopyWith(MapSearchResult value, $Res Function(MapSearchResult) _then) = _$MapSearchResultCopyWithImpl;
@useResult
$Res call({
 String label, LatLng position, MapSearchResultType type
});




}
/// @nodoc
class _$MapSearchResultCopyWithImpl<$Res>
    implements $MapSearchResultCopyWith<$Res> {
  _$MapSearchResultCopyWithImpl(this._self, this._then);

  final MapSearchResult _self;
  final $Res Function(MapSearchResult) _then;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? position = null,Object? type = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MapSearchResultType,
  ));
}

}


/// Adds pattern-matching-related methods to [MapSearchResult].
extension MapSearchResultPatterns on MapSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _MapSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  LatLng position,  MapSearchResultType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
return $default(_that.label,_that.position,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  LatLng position,  MapSearchResultType type)  $default,) {final _that = this;
switch (_that) {
case _MapSearchResult():
return $default(_that.label,_that.position,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  LatLng position,  MapSearchResultType type)?  $default,) {final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
return $default(_that.label,_that.position,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _MapSearchResult implements MapSearchResult {
  const _MapSearchResult({required this.label, required this.position, required this.type});
  

@override final  String label;
@override final  LatLng position;
@override final  MapSearchResultType type;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapSearchResultCopyWith<_MapSearchResult> get copyWith => __$MapSearchResultCopyWithImpl<_MapSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapSearchResult&&(identical(other.label, label) || other.label == label)&&(identical(other.position, position) || other.position == position)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,label,position,type);

@override
String toString() {
  return 'MapSearchResult(label: $label, position: $position, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MapSearchResultCopyWith<$Res> implements $MapSearchResultCopyWith<$Res> {
  factory _$MapSearchResultCopyWith(_MapSearchResult value, $Res Function(_MapSearchResult) _then) = __$MapSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String label, LatLng position, MapSearchResultType type
});




}
/// @nodoc
class __$MapSearchResultCopyWithImpl<$Res>
    implements _$MapSearchResultCopyWith<$Res> {
  __$MapSearchResultCopyWithImpl(this._self, this._then);

  final _MapSearchResult _self;
  final $Res Function(_MapSearchResult) _then;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? position = null,Object? type = null,}) {
  return _then(_MapSearchResult(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MapSearchResultType,
  ));
}


}

// dart format on
