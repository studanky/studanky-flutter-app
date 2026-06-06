// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_cluster_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapClusterItem {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapClusterItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MapClusterItem()';
}


}

/// @nodoc
class $MapClusterItemCopyWith<$Res>  {
$MapClusterItemCopyWith(MapClusterItem _, $Res Function(MapClusterItem) __);
}


/// Adds pattern-matching-related methods to [MapClusterItem].
extension MapClusterItemPatterns on MapClusterItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Cluster value)?  cluster,TResult Function( SpringPoint value)?  spring,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Cluster() when cluster != null:
return cluster(_that);case SpringPoint() when spring != null:
return spring(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Cluster value)  cluster,required TResult Function( SpringPoint value)  spring,}){
final _that = this;
switch (_that) {
case Cluster():
return cluster(_that);case SpringPoint():
return spring(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Cluster value)?  cluster,TResult? Function( SpringPoint value)?  spring,}){
final _that = this;
switch (_that) {
case Cluster() when cluster != null:
return cluster(_that);case SpringPoint() when spring != null:
return spring(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LatLng position,  int count,  double expansionZoom)?  cluster,TResult Function( SpringMarkerEntity spring)?  spring,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Cluster() when cluster != null:
return cluster(_that.position,_that.count,_that.expansionZoom);case SpringPoint() when spring != null:
return spring(_that.spring);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LatLng position,  int count,  double expansionZoom)  cluster,required TResult Function( SpringMarkerEntity spring)  spring,}) {final _that = this;
switch (_that) {
case Cluster():
return cluster(_that.position,_that.count,_that.expansionZoom);case SpringPoint():
return spring(_that.spring);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LatLng position,  int count,  double expansionZoom)?  cluster,TResult? Function( SpringMarkerEntity spring)?  spring,}) {final _that = this;
switch (_that) {
case Cluster() when cluster != null:
return cluster(_that.position,_that.count,_that.expansionZoom);case SpringPoint() when spring != null:
return spring(_that.spring);case _:
  return null;

}
}

}

/// @nodoc


class Cluster implements MapClusterItem {
  const Cluster({required this.position, required this.count, required this.expansionZoom});
  

 final  LatLng position;
 final  int count;
 final  double expansionZoom;

/// Create a copy of MapClusterItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClusterCopyWith<Cluster> get copyWith => _$ClusterCopyWithImpl<Cluster>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cluster&&(identical(other.position, position) || other.position == position)&&(identical(other.count, count) || other.count == count)&&(identical(other.expansionZoom, expansionZoom) || other.expansionZoom == expansionZoom));
}


@override
int get hashCode => Object.hash(runtimeType,position,count,expansionZoom);

@override
String toString() {
  return 'MapClusterItem.cluster(position: $position, count: $count, expansionZoom: $expansionZoom)';
}


}

/// @nodoc
abstract mixin class $ClusterCopyWith<$Res> implements $MapClusterItemCopyWith<$Res> {
  factory $ClusterCopyWith(Cluster value, $Res Function(Cluster) _then) = _$ClusterCopyWithImpl;
@useResult
$Res call({
 LatLng position, int count, double expansionZoom
});




}
/// @nodoc
class _$ClusterCopyWithImpl<$Res>
    implements $ClusterCopyWith<$Res> {
  _$ClusterCopyWithImpl(this._self, this._then);

  final Cluster _self;
  final $Res Function(Cluster) _then;

/// Create a copy of MapClusterItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,Object? count = null,Object? expansionZoom = null,}) {
  return _then(Cluster(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,expansionZoom: null == expansionZoom ? _self.expansionZoom : expansionZoom // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class SpringPoint implements MapClusterItem {
  const SpringPoint(this.spring);
  

 final  SpringMarkerEntity spring;

/// Create a copy of MapClusterItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpringPointCopyWith<SpringPoint> get copyWith => _$SpringPointCopyWithImpl<SpringPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpringPoint&&(identical(other.spring, spring) || other.spring == spring));
}


@override
int get hashCode => Object.hash(runtimeType,spring);

@override
String toString() {
  return 'MapClusterItem.spring(spring: $spring)';
}


}

/// @nodoc
abstract mixin class $SpringPointCopyWith<$Res> implements $MapClusterItemCopyWith<$Res> {
  factory $SpringPointCopyWith(SpringPoint value, $Res Function(SpringPoint) _then) = _$SpringPointCopyWithImpl;
@useResult
$Res call({
 SpringMarkerEntity spring
});


$SpringMarkerEntityCopyWith<$Res> get spring;

}
/// @nodoc
class _$SpringPointCopyWithImpl<$Res>
    implements $SpringPointCopyWith<$Res> {
  _$SpringPointCopyWithImpl(this._self, this._then);

  final SpringPoint _self;
  final $Res Function(SpringPoint) _then;

/// Create a copy of MapClusterItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? spring = null,}) {
  return _then(SpringPoint(
null == spring ? _self.spring : spring // ignore: cast_nullable_to_non_nullable
as SpringMarkerEntity,
  ));
}

/// Create a copy of MapClusterItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpringMarkerEntityCopyWith<$Res> get spring {
  
  return $SpringMarkerEntityCopyWith<$Res>(_self.spring, (value) {
    return _then(_self.copyWith(spring: value));
  });
}
}

// dart format on
