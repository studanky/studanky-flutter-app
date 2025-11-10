// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_search_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapSearchState {

 String get query; List<MapSearchResult> get results; bool get isSearching; String? get error; MapSearchResult? get selected;
/// Create a copy of MapSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapSearchStateCopyWith<MapSearchState> get copyWith => _$MapSearchStateCopyWithImpl<MapSearchState>(this as MapSearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapSearchState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.error, error) || other.error == error)&&(identical(other.selected, selected) || other.selected == selected));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(results),isSearching,error,selected);

@override
String toString() {
  return 'MapSearchState(query: $query, results: $results, isSearching: $isSearching, error: $error, selected: $selected)';
}


}

/// @nodoc
abstract mixin class $MapSearchStateCopyWith<$Res>  {
  factory $MapSearchStateCopyWith(MapSearchState value, $Res Function(MapSearchState) _then) = _$MapSearchStateCopyWithImpl;
@useResult
$Res call({
 String query, List<MapSearchResult> results, bool isSearching, String? error, MapSearchResult? selected
});




}
/// @nodoc
class _$MapSearchStateCopyWithImpl<$Res>
    implements $MapSearchStateCopyWith<$Res> {
  _$MapSearchStateCopyWithImpl(this._self, this._then);

  final MapSearchState _self;
  final $Res Function(MapSearchState) _then;

/// Create a copy of MapSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? results = null,Object? isSearching = null,Object? error = freezed,Object? selected = freezed,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<MapSearchResult>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as MapSearchResult?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapSearchState].
extension MapSearchStatePatterns on MapSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapSearchState value)  $default,){
final _that = this;
switch (_that) {
case _MapSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _MapSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  List<MapSearchResult> results,  bool isSearching,  String? error,  MapSearchResult? selected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapSearchState() when $default != null:
return $default(_that.query,_that.results,_that.isSearching,_that.error,_that.selected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  List<MapSearchResult> results,  bool isSearching,  String? error,  MapSearchResult? selected)  $default,) {final _that = this;
switch (_that) {
case _MapSearchState():
return $default(_that.query,_that.results,_that.isSearching,_that.error,_that.selected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  List<MapSearchResult> results,  bool isSearching,  String? error,  MapSearchResult? selected)?  $default,) {final _that = this;
switch (_that) {
case _MapSearchState() when $default != null:
return $default(_that.query,_that.results,_that.isSearching,_that.error,_that.selected);case _:
  return null;

}
}

}

/// @nodoc


class _MapSearchState implements MapSearchState {
  const _MapSearchState({this.query = '', final  List<MapSearchResult> results = const <MapSearchResult>[], this.isSearching = false, this.error, this.selected}): _results = results;
  

@override@JsonKey() final  String query;
 final  List<MapSearchResult> _results;
@override@JsonKey() List<MapSearchResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey() final  bool isSearching;
@override final  String? error;
@override final  MapSearchResult? selected;

/// Create a copy of MapSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapSearchStateCopyWith<_MapSearchState> get copyWith => __$MapSearchStateCopyWithImpl<_MapSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapSearchState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.error, error) || other.error == error)&&(identical(other.selected, selected) || other.selected == selected));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_results),isSearching,error,selected);

@override
String toString() {
  return 'MapSearchState(query: $query, results: $results, isSearching: $isSearching, error: $error, selected: $selected)';
}


}

/// @nodoc
abstract mixin class _$MapSearchStateCopyWith<$Res> implements $MapSearchStateCopyWith<$Res> {
  factory _$MapSearchStateCopyWith(_MapSearchState value, $Res Function(_MapSearchState) _then) = __$MapSearchStateCopyWithImpl;
@override @useResult
$Res call({
 String query, List<MapSearchResult> results, bool isSearching, String? error, MapSearchResult? selected
});




}
/// @nodoc
class __$MapSearchStateCopyWithImpl<$Res>
    implements _$MapSearchStateCopyWith<$Res> {
  __$MapSearchStateCopyWithImpl(this._self, this._then);

  final _MapSearchState _self;
  final $Res Function(_MapSearchState) _then;

/// Create a copy of MapSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? results = null,Object? isSearching = null,Object? error = freezed,Object? selected = freezed,}) {
  return _then(_MapSearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<MapSearchResult>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as MapSearchResult?,
  ));
}


}

// dart format on
