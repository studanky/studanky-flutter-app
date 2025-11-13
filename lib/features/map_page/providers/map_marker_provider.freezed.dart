// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_marker_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapMarkerState {

 AsyncValue<List<MapMarkerEntity>> get markerResults; List<MapMarkerEntity> get customMarkers; LatLngBounds? get cachedBounds; LatLngBounds? get pendingBounds;
/// Create a copy of MapMarkerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapMarkerStateCopyWith<MapMarkerState> get copyWith => _$MapMarkerStateCopyWithImpl<MapMarkerState>(this as MapMarkerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapMarkerState&&(identical(other.markerResults, markerResults) || other.markerResults == markerResults)&&const DeepCollectionEquality().equals(other.customMarkers, customMarkers)&&(identical(other.cachedBounds, cachedBounds) || other.cachedBounds == cachedBounds)&&(identical(other.pendingBounds, pendingBounds) || other.pendingBounds == pendingBounds));
}


@override
int get hashCode => Object.hash(runtimeType,markerResults,const DeepCollectionEquality().hash(customMarkers),cachedBounds,pendingBounds);

@override
String toString() {
  return 'MapMarkerState(markerResults: $markerResults, customMarkers: $customMarkers, cachedBounds: $cachedBounds, pendingBounds: $pendingBounds)';
}


}

/// @nodoc
abstract mixin class $MapMarkerStateCopyWith<$Res>  {
  factory $MapMarkerStateCopyWith(MapMarkerState value, $Res Function(MapMarkerState) _then) = _$MapMarkerStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<MapMarkerEntity>> markerResults, List<MapMarkerEntity> customMarkers, LatLngBounds? cachedBounds, LatLngBounds? pendingBounds
});




}
/// @nodoc
class _$MapMarkerStateCopyWithImpl<$Res>
    implements $MapMarkerStateCopyWith<$Res> {
  _$MapMarkerStateCopyWithImpl(this._self, this._then);

  final MapMarkerState _self;
  final $Res Function(MapMarkerState) _then;

/// Create a copy of MapMarkerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? markerResults = null,Object? customMarkers = null,Object? cachedBounds = freezed,Object? pendingBounds = freezed,}) {
  return _then(_self.copyWith(
markerResults: null == markerResults ? _self.markerResults : markerResults // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<MapMarkerEntity>>,customMarkers: null == customMarkers ? _self.customMarkers : customMarkers // ignore: cast_nullable_to_non_nullable
as List<MapMarkerEntity>,cachedBounds: freezed == cachedBounds ? _self.cachedBounds : cachedBounds // ignore: cast_nullable_to_non_nullable
as LatLngBounds?,pendingBounds: freezed == pendingBounds ? _self.pendingBounds : pendingBounds // ignore: cast_nullable_to_non_nullable
as LatLngBounds?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapMarkerState].
extension MapMarkerStatePatterns on MapMarkerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapMarkerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapMarkerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapMarkerState value)  $default,){
final _that = this;
switch (_that) {
case _MapMarkerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapMarkerState value)?  $default,){
final _that = this;
switch (_that) {
case _MapMarkerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<MapMarkerEntity>> markerResults,  List<MapMarkerEntity> customMarkers,  LatLngBounds? cachedBounds,  LatLngBounds? pendingBounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapMarkerState() when $default != null:
return $default(_that.markerResults,_that.customMarkers,_that.cachedBounds,_that.pendingBounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<MapMarkerEntity>> markerResults,  List<MapMarkerEntity> customMarkers,  LatLngBounds? cachedBounds,  LatLngBounds? pendingBounds)  $default,) {final _that = this;
switch (_that) {
case _MapMarkerState():
return $default(_that.markerResults,_that.customMarkers,_that.cachedBounds,_that.pendingBounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<MapMarkerEntity>> markerResults,  List<MapMarkerEntity> customMarkers,  LatLngBounds? cachedBounds,  LatLngBounds? pendingBounds)?  $default,) {final _that = this;
switch (_that) {
case _MapMarkerState() when $default != null:
return $default(_that.markerResults,_that.customMarkers,_that.cachedBounds,_that.pendingBounds);case _:
  return null;

}
}

}

/// @nodoc


class _MapMarkerState extends MapMarkerState {
  const _MapMarkerState({this.markerResults = const AsyncValue<List<MapMarkerEntity>>.data(<MapMarkerEntity>[]), final  List<MapMarkerEntity> customMarkers = const <MapMarkerEntity>[], this.cachedBounds = null, this.pendingBounds = null}): _customMarkers = customMarkers,super._();
  

@override@JsonKey() final  AsyncValue<List<MapMarkerEntity>> markerResults;
 final  List<MapMarkerEntity> _customMarkers;
@override@JsonKey() List<MapMarkerEntity> get customMarkers {
  if (_customMarkers is EqualUnmodifiableListView) return _customMarkers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customMarkers);
}

@override@JsonKey() final  LatLngBounds? cachedBounds;
@override@JsonKey() final  LatLngBounds? pendingBounds;

/// Create a copy of MapMarkerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapMarkerStateCopyWith<_MapMarkerState> get copyWith => __$MapMarkerStateCopyWithImpl<_MapMarkerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapMarkerState&&(identical(other.markerResults, markerResults) || other.markerResults == markerResults)&&const DeepCollectionEquality().equals(other._customMarkers, _customMarkers)&&(identical(other.cachedBounds, cachedBounds) || other.cachedBounds == cachedBounds)&&(identical(other.pendingBounds, pendingBounds) || other.pendingBounds == pendingBounds));
}


@override
int get hashCode => Object.hash(runtimeType,markerResults,const DeepCollectionEquality().hash(_customMarkers),cachedBounds,pendingBounds);

@override
String toString() {
  return 'MapMarkerState(markerResults: $markerResults, customMarkers: $customMarkers, cachedBounds: $cachedBounds, pendingBounds: $pendingBounds)';
}


}

/// @nodoc
abstract mixin class _$MapMarkerStateCopyWith<$Res> implements $MapMarkerStateCopyWith<$Res> {
  factory _$MapMarkerStateCopyWith(_MapMarkerState value, $Res Function(_MapMarkerState) _then) = __$MapMarkerStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<MapMarkerEntity>> markerResults, List<MapMarkerEntity> customMarkers, LatLngBounds? cachedBounds, LatLngBounds? pendingBounds
});




}
/// @nodoc
class __$MapMarkerStateCopyWithImpl<$Res>
    implements _$MapMarkerStateCopyWith<$Res> {
  __$MapMarkerStateCopyWithImpl(this._self, this._then);

  final _MapMarkerState _self;
  final $Res Function(_MapMarkerState) _then;

/// Create a copy of MapMarkerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? markerResults = null,Object? customMarkers = null,Object? cachedBounds = freezed,Object? pendingBounds = freezed,}) {
  return _then(_MapMarkerState(
markerResults: null == markerResults ? _self.markerResults : markerResults // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<MapMarkerEntity>>,customMarkers: null == customMarkers ? _self._customMarkers : customMarkers // ignore: cast_nullable_to_non_nullable
as List<MapMarkerEntity>,cachedBounds: freezed == cachedBounds ? _self.cachedBounds : cachedBounds // ignore: cast_nullable_to_non_nullable
as LatLngBounds?,pendingBounds: freezed == pendingBounds ? _self.pendingBounds : pendingBounds // ignore: cast_nullable_to_non_nullable
as LatLngBounds?,
  ));
}


}

// dart format on
