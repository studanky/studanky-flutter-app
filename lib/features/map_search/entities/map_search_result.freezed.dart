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

 String get label; LatLng get position; MapSearchResultType get type;/// Parent location (region / municipality) shown under the [label] to
/// disambiguate identically named places; null when the API omits it.
 String? get subtitle;/// Geographic extent of the locality, when known. Used to fit the whole
/// place in view; null falls back to centring on [position].
 MapSearchBounds? get bounds;
/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapSearchResultCopyWith<MapSearchResult> get copyWith => _$MapSearchResultCopyWithImpl<MapSearchResult>(this as MapSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapSearchResult&&(identical(other.label, label) || other.label == label)&&(identical(other.position, position) || other.position == position)&&(identical(other.type, type) || other.type == type)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.bounds, bounds) || other.bounds == bounds));
}


@override
int get hashCode => Object.hash(runtimeType,label,position,type,subtitle,bounds);

@override
String toString() {
  return 'MapSearchResult(label: $label, position: $position, type: $type, subtitle: $subtitle, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class $MapSearchResultCopyWith<$Res>  {
  factory $MapSearchResultCopyWith(MapSearchResult value, $Res Function(MapSearchResult) _then) = _$MapSearchResultCopyWithImpl;
@useResult
$Res call({
 String label, LatLng position, MapSearchResultType type, String? subtitle, MapSearchBounds? bounds
});


$MapSearchBoundsCopyWith<$Res>? get bounds;

}
/// @nodoc
class _$MapSearchResultCopyWithImpl<$Res>
    implements $MapSearchResultCopyWith<$Res> {
  _$MapSearchResultCopyWithImpl(this._self, this._then);

  final MapSearchResult _self;
  final $Res Function(MapSearchResult) _then;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? position = null,Object? type = null,Object? subtitle = freezed,Object? bounds = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MapSearchResultType,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,bounds: freezed == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as MapSearchBounds?,
  ));
}
/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapSearchBoundsCopyWith<$Res>? get bounds {
    if (_self.bounds == null) {
    return null;
  }

  return $MapSearchBoundsCopyWith<$Res>(_self.bounds!, (value) {
    return _then(_self.copyWith(bounds: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  LatLng position,  MapSearchResultType type,  String? subtitle,  MapSearchBounds? bounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
return $default(_that.label,_that.position,_that.type,_that.subtitle,_that.bounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  LatLng position,  MapSearchResultType type,  String? subtitle,  MapSearchBounds? bounds)  $default,) {final _that = this;
switch (_that) {
case _MapSearchResult():
return $default(_that.label,_that.position,_that.type,_that.subtitle,_that.bounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  LatLng position,  MapSearchResultType type,  String? subtitle,  MapSearchBounds? bounds)?  $default,) {final _that = this;
switch (_that) {
case _MapSearchResult() when $default != null:
return $default(_that.label,_that.position,_that.type,_that.subtitle,_that.bounds);case _:
  return null;

}
}

}

/// @nodoc


class _MapSearchResult implements MapSearchResult {
  const _MapSearchResult({required this.label, required this.position, required this.type, this.subtitle, this.bounds});
  

@override final  String label;
@override final  LatLng position;
@override final  MapSearchResultType type;
/// Parent location (region / municipality) shown under the [label] to
/// disambiguate identically named places; null when the API omits it.
@override final  String? subtitle;
/// Geographic extent of the locality, when known. Used to fit the whole
/// place in view; null falls back to centring on [position].
@override final  MapSearchBounds? bounds;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapSearchResultCopyWith<_MapSearchResult> get copyWith => __$MapSearchResultCopyWithImpl<_MapSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapSearchResult&&(identical(other.label, label) || other.label == label)&&(identical(other.position, position) || other.position == position)&&(identical(other.type, type) || other.type == type)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.bounds, bounds) || other.bounds == bounds));
}


@override
int get hashCode => Object.hash(runtimeType,label,position,type,subtitle,bounds);

@override
String toString() {
  return 'MapSearchResult(label: $label, position: $position, type: $type, subtitle: $subtitle, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class _$MapSearchResultCopyWith<$Res> implements $MapSearchResultCopyWith<$Res> {
  factory _$MapSearchResultCopyWith(_MapSearchResult value, $Res Function(_MapSearchResult) _then) = __$MapSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String label, LatLng position, MapSearchResultType type, String? subtitle, MapSearchBounds? bounds
});


@override $MapSearchBoundsCopyWith<$Res>? get bounds;

}
/// @nodoc
class __$MapSearchResultCopyWithImpl<$Res>
    implements _$MapSearchResultCopyWith<$Res> {
  __$MapSearchResultCopyWithImpl(this._self, this._then);

  final _MapSearchResult _self;
  final $Res Function(_MapSearchResult) _then;

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? position = null,Object? type = null,Object? subtitle = freezed,Object? bounds = freezed,}) {
  return _then(_MapSearchResult(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MapSearchResultType,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,bounds: freezed == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as MapSearchBounds?,
  ));
}

/// Create a copy of MapSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapSearchBoundsCopyWith<$Res>? get bounds {
    if (_self.bounds == null) {
    return null;
  }

  return $MapSearchBoundsCopyWith<$Res>(_self.bounds!, (value) {
    return _then(_self.copyWith(bounds: value));
  });
}
}

/// @nodoc
mixin _$MapSearchBounds {

 LatLng get southWest; LatLng get northEast;
/// Create a copy of MapSearchBounds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapSearchBoundsCopyWith<MapSearchBounds> get copyWith => _$MapSearchBoundsCopyWithImpl<MapSearchBounds>(this as MapSearchBounds, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapSearchBounds&&(identical(other.southWest, southWest) || other.southWest == southWest)&&(identical(other.northEast, northEast) || other.northEast == northEast));
}


@override
int get hashCode => Object.hash(runtimeType,southWest,northEast);

@override
String toString() {
  return 'MapSearchBounds(southWest: $southWest, northEast: $northEast)';
}


}

/// @nodoc
abstract mixin class $MapSearchBoundsCopyWith<$Res>  {
  factory $MapSearchBoundsCopyWith(MapSearchBounds value, $Res Function(MapSearchBounds) _then) = _$MapSearchBoundsCopyWithImpl;
@useResult
$Res call({
 LatLng southWest, LatLng northEast
});




}
/// @nodoc
class _$MapSearchBoundsCopyWithImpl<$Res>
    implements $MapSearchBoundsCopyWith<$Res> {
  _$MapSearchBoundsCopyWithImpl(this._self, this._then);

  final MapSearchBounds _self;
  final $Res Function(MapSearchBounds) _then;

/// Create a copy of MapSearchBounds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? southWest = null,Object? northEast = null,}) {
  return _then(_self.copyWith(
southWest: null == southWest ? _self.southWest : southWest // ignore: cast_nullable_to_non_nullable
as LatLng,northEast: null == northEast ? _self.northEast : northEast // ignore: cast_nullable_to_non_nullable
as LatLng,
  ));
}

}


/// Adds pattern-matching-related methods to [MapSearchBounds].
extension MapSearchBoundsPatterns on MapSearchBounds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapSearchBounds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapSearchBounds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapSearchBounds value)  $default,){
final _that = this;
switch (_that) {
case _MapSearchBounds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapSearchBounds value)?  $default,){
final _that = this;
switch (_that) {
case _MapSearchBounds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LatLng southWest,  LatLng northEast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapSearchBounds() when $default != null:
return $default(_that.southWest,_that.northEast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LatLng southWest,  LatLng northEast)  $default,) {final _that = this;
switch (_that) {
case _MapSearchBounds():
return $default(_that.southWest,_that.northEast);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LatLng southWest,  LatLng northEast)?  $default,) {final _that = this;
switch (_that) {
case _MapSearchBounds() when $default != null:
return $default(_that.southWest,_that.northEast);case _:
  return null;

}
}

}

/// @nodoc


class _MapSearchBounds extends MapSearchBounds {
  const _MapSearchBounds({required this.southWest, required this.northEast}): super._();
  

@override final  LatLng southWest;
@override final  LatLng northEast;

/// Create a copy of MapSearchBounds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapSearchBoundsCopyWith<_MapSearchBounds> get copyWith => __$MapSearchBoundsCopyWithImpl<_MapSearchBounds>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapSearchBounds&&(identical(other.southWest, southWest) || other.southWest == southWest)&&(identical(other.northEast, northEast) || other.northEast == northEast));
}


@override
int get hashCode => Object.hash(runtimeType,southWest,northEast);

@override
String toString() {
  return 'MapSearchBounds(southWest: $southWest, northEast: $northEast)';
}


}

/// @nodoc
abstract mixin class _$MapSearchBoundsCopyWith<$Res> implements $MapSearchBoundsCopyWith<$Res> {
  factory _$MapSearchBoundsCopyWith(_MapSearchBounds value, $Res Function(_MapSearchBounds) _then) = __$MapSearchBoundsCopyWithImpl;
@override @useResult
$Res call({
 LatLng southWest, LatLng northEast
});




}
/// @nodoc
class __$MapSearchBoundsCopyWithImpl<$Res>
    implements _$MapSearchBoundsCopyWith<$Res> {
  __$MapSearchBoundsCopyWithImpl(this._self, this._then);

  final _MapSearchBounds _self;
  final $Res Function(_MapSearchBounds) _then;

/// Create a copy of MapSearchBounds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? southWest = null,Object? northEast = null,}) {
  return _then(_MapSearchBounds(
southWest: null == southWest ? _self.southWest : southWest // ignore: cast_nullable_to_non_nullable
as LatLng,northEast: null == northEast ? _self.northEast : northEast // ignore: cast_nullable_to_non_nullable
as LatLng,
  ));
}


}

// dart format on
