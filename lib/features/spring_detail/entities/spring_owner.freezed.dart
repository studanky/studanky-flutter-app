// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spring_owner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpringOwner {

 String get name; String? get type;
/// Create a copy of SpringOwner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpringOwnerCopyWith<SpringOwner> get copyWith => _$SpringOwnerCopyWithImpl<SpringOwner>(this as SpringOwner, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpringOwner&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,name,type);

@override
String toString() {
  return 'SpringOwner(name: $name, type: $type)';
}


}

/// @nodoc
abstract mixin class $SpringOwnerCopyWith<$Res>  {
  factory $SpringOwnerCopyWith(SpringOwner value, $Res Function(SpringOwner) _then) = _$SpringOwnerCopyWithImpl;
@useResult
$Res call({
 String name, String? type
});




}
/// @nodoc
class _$SpringOwnerCopyWithImpl<$Res>
    implements $SpringOwnerCopyWith<$Res> {
  _$SpringOwnerCopyWithImpl(this._self, this._then);

  final SpringOwner _self;
  final $Res Function(SpringOwner) _then;

/// Create a copy of SpringOwner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpringOwner].
extension SpringOwnerPatterns on SpringOwner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpringOwner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpringOwner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpringOwner value)  $default,){
final _that = this;
switch (_that) {
case _SpringOwner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpringOwner value)?  $default,){
final _that = this;
switch (_that) {
case _SpringOwner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpringOwner() when $default != null:
return $default(_that.name,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? type)  $default,) {final _that = this;
switch (_that) {
case _SpringOwner():
return $default(_that.name,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _SpringOwner() when $default != null:
return $default(_that.name,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _SpringOwner implements SpringOwner {
  const _SpringOwner({required this.name, this.type});
  

@override final  String name;
@override final  String? type;

/// Create a copy of SpringOwner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpringOwnerCopyWith<_SpringOwner> get copyWith => __$SpringOwnerCopyWithImpl<_SpringOwner>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpringOwner&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,name,type);

@override
String toString() {
  return 'SpringOwner(name: $name, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SpringOwnerCopyWith<$Res> implements $SpringOwnerCopyWith<$Res> {
  factory _$SpringOwnerCopyWith(_SpringOwner value, $Res Function(_SpringOwner) _then) = __$SpringOwnerCopyWithImpl;
@override @useResult
$Res call({
 String name, String? type
});




}
/// @nodoc
class __$SpringOwnerCopyWithImpl<$Res>
    implements _$SpringOwnerCopyWith<$Res> {
  __$SpringOwnerCopyWithImpl(this._self, this._then);

  final _SpringOwner _self;
  final $Res Function(_SpringOwner) _then;

/// Create a copy of SpringOwner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = freezed,}) {
  return _then(_SpringOwner(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
