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

/// Loading/error of the background fetch. Items stay visible while a new
/// fetch runs, so this is a thin status channel, not the source of markers.
 AsyncValue<void> get status;/// Clustered, drawable items for the most recent camera.
 List<MapClusterItem> get items;/// True once the currently visible camera bounds are covered by fetched
/// marker data. Lets the UI distinguish a real empty map area from a camera
/// position that is still waiting for its first fetch.
 bool get visibleBoundsLoaded;
/// Create a copy of MapMarkerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapMarkerStateCopyWith<MapMarkerState> get copyWith => _$MapMarkerStateCopyWithImpl<MapMarkerState>(this as MapMarkerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapMarkerState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.visibleBoundsLoaded, visibleBoundsLoaded) || other.visibleBoundsLoaded == visibleBoundsLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),visibleBoundsLoaded);

@override
String toString() {
  return 'MapMarkerState(status: $status, items: $items, visibleBoundsLoaded: $visibleBoundsLoaded)';
}


}

/// @nodoc
abstract mixin class $MapMarkerStateCopyWith<$Res>  {
  factory $MapMarkerStateCopyWith(MapMarkerState value, $Res Function(MapMarkerState) _then) = _$MapMarkerStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<void> status, List<MapClusterItem> items, bool visibleBoundsLoaded
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? visibleBoundsLoaded = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MapClusterItem>,visibleBoundsLoaded: null == visibleBoundsLoaded ? _self.visibleBoundsLoaded : visibleBoundsLoaded // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<void> status,  List<MapClusterItem> items,  bool visibleBoundsLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapMarkerState() when $default != null:
return $default(_that.status,_that.items,_that.visibleBoundsLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<void> status,  List<MapClusterItem> items,  bool visibleBoundsLoaded)  $default,) {final _that = this;
switch (_that) {
case _MapMarkerState():
return $default(_that.status,_that.items,_that.visibleBoundsLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<void> status,  List<MapClusterItem> items,  bool visibleBoundsLoaded)?  $default,) {final _that = this;
switch (_that) {
case _MapMarkerState() when $default != null:
return $default(_that.status,_that.items,_that.visibleBoundsLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _MapMarkerState implements MapMarkerState {
  const _MapMarkerState({this.status = const AsyncValue<void>.data(null), final  List<MapClusterItem> items = const <MapClusterItem>[], this.visibleBoundsLoaded = false}): _items = items;
  

/// Loading/error of the background fetch. Items stay visible while a new
/// fetch runs, so this is a thin status channel, not the source of markers.
@override@JsonKey() final  AsyncValue<void> status;
/// Clustered, drawable items for the most recent camera.
 final  List<MapClusterItem> _items;
/// Clustered, drawable items for the most recent camera.
@override@JsonKey() List<MapClusterItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// True once the currently visible camera bounds are covered by fetched
/// marker data. Lets the UI distinguish a real empty map area from a camera
/// position that is still waiting for its first fetch.
@override@JsonKey() final  bool visibleBoundsLoaded;

/// Create a copy of MapMarkerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapMarkerStateCopyWith<_MapMarkerState> get copyWith => __$MapMarkerStateCopyWithImpl<_MapMarkerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapMarkerState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.visibleBoundsLoaded, visibleBoundsLoaded) || other.visibleBoundsLoaded == visibleBoundsLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),visibleBoundsLoaded);

@override
String toString() {
  return 'MapMarkerState(status: $status, items: $items, visibleBoundsLoaded: $visibleBoundsLoaded)';
}


}

/// @nodoc
abstract mixin class _$MapMarkerStateCopyWith<$Res> implements $MapMarkerStateCopyWith<$Res> {
  factory _$MapMarkerStateCopyWith(_MapMarkerState value, $Res Function(_MapMarkerState) _then) = __$MapMarkerStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<void> status, List<MapClusterItem> items, bool visibleBoundsLoaded
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? visibleBoundsLoaded = null,}) {
  return _then(_MapMarkerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MapClusterItem>,visibleBoundsLoaded: null == visibleBoundsLoaded ? _self.visibleBoundsLoaded : visibleBoundsLoaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
