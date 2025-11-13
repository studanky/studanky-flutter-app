// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_feature_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExampleFeatureState {

 AsyncValue<List<ExampleItemEntity>> get items; String get searchQuery;
/// Create a copy of ExampleFeatureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleFeatureStateCopyWith<ExampleFeatureState> get copyWith => _$ExampleFeatureStateCopyWithImpl<ExampleFeatureState>(this as ExampleFeatureState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleFeatureState&&(identical(other.items, items) || other.items == items)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,items,searchQuery);

@override
String toString() {
  return 'ExampleFeatureState(items: $items, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $ExampleFeatureStateCopyWith<$Res>  {
  factory $ExampleFeatureStateCopyWith(ExampleFeatureState value, $Res Function(ExampleFeatureState) _then) = _$ExampleFeatureStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<ExampleItemEntity>> items, String searchQuery
});




}
/// @nodoc
class _$ExampleFeatureStateCopyWithImpl<$Res>
    implements $ExampleFeatureStateCopyWith<$Res> {
  _$ExampleFeatureStateCopyWithImpl(this._self, this._then);

  final ExampleFeatureState _self;
  final $Res Function(ExampleFeatureState) _then;

/// Create a copy of ExampleFeatureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<ExampleItemEntity>>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExampleFeatureState].
extension ExampleFeatureStatePatterns on ExampleFeatureState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleFeatureState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleFeatureState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleFeatureState value)  $default,){
final _that = this;
switch (_that) {
case _ExampleFeatureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleFeatureState value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleFeatureState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<ExampleItemEntity>> items,  String searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleFeatureState() when $default != null:
return $default(_that.items,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<ExampleItemEntity>> items,  String searchQuery)  $default,) {final _that = this;
switch (_that) {
case _ExampleFeatureState():
return $default(_that.items,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<ExampleItemEntity>> items,  String searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _ExampleFeatureState() when $default != null:
return $default(_that.items,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc


class _ExampleFeatureState implements ExampleFeatureState {
  const _ExampleFeatureState({this.items = const AsyncValue<List<ExampleItemEntity>>.loading(), this.searchQuery = ''});
  

@override@JsonKey() final  AsyncValue<List<ExampleItemEntity>> items;
@override@JsonKey() final  String searchQuery;

/// Create a copy of ExampleFeatureState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleFeatureStateCopyWith<_ExampleFeatureState> get copyWith => __$ExampleFeatureStateCopyWithImpl<_ExampleFeatureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleFeatureState&&(identical(other.items, items) || other.items == items)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,items,searchQuery);

@override
String toString() {
  return 'ExampleFeatureState(items: $items, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$ExampleFeatureStateCopyWith<$Res> implements $ExampleFeatureStateCopyWith<$Res> {
  factory _$ExampleFeatureStateCopyWith(_ExampleFeatureState value, $Res Function(_ExampleFeatureState) _then) = __$ExampleFeatureStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<ExampleItemEntity>> items, String searchQuery
});




}
/// @nodoc
class __$ExampleFeatureStateCopyWithImpl<$Res>
    implements _$ExampleFeatureStateCopyWith<$Res> {
  __$ExampleFeatureStateCopyWithImpl(this._self, this._then);

  final _ExampleFeatureState _self;
  final $Res Function(_ExampleFeatureState) _then;

/// Create a copy of ExampleFeatureState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? searchQuery = null,}) {
  return _then(_ExampleFeatureState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<ExampleItemEntity>>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
