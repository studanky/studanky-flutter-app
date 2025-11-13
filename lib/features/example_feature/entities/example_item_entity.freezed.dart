// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExampleItemEntity {

 String get id; String get title; String get description; DateTime get createdAt;
/// Create a copy of ExampleItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleItemEntityCopyWith<ExampleItemEntity> get copyWith => _$ExampleItemEntityCopyWithImpl<ExampleItemEntity>(this as ExampleItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,createdAt);

@override
String toString() {
  return 'ExampleItemEntity(id: $id, title: $title, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExampleItemEntityCopyWith<$Res>  {
  factory $ExampleItemEntityCopyWith(ExampleItemEntity value, $Res Function(ExampleItemEntity) _then) = _$ExampleItemEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, DateTime createdAt
});




}
/// @nodoc
class _$ExampleItemEntityCopyWithImpl<$Res>
    implements $ExampleItemEntityCopyWith<$Res> {
  _$ExampleItemEntityCopyWithImpl(this._self, this._then);

  final ExampleItemEntity _self;
  final $Res Function(ExampleItemEntity) _then;

/// Create a copy of ExampleItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ExampleItemEntity].
extension ExampleItemEntityPatterns on ExampleItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _ExampleItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleItemEntity() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExampleItemEntity():
return $default(_that.id,_that.title,_that.description,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExampleItemEntity() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ExampleItemEntity implements ExampleItemEntity {
  const _ExampleItemEntity({required this.id, required this.title, required this.description, required this.createdAt});
  

@override final  String id;
@override final  String title;
@override final  String description;
@override final  DateTime createdAt;

/// Create a copy of ExampleItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleItemEntityCopyWith<_ExampleItemEntity> get copyWith => __$ExampleItemEntityCopyWithImpl<_ExampleItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,createdAt);

@override
String toString() {
  return 'ExampleItemEntity(id: $id, title: $title, description: $description, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExampleItemEntityCopyWith<$Res> implements $ExampleItemEntityCopyWith<$Res> {
  factory _$ExampleItemEntityCopyWith(_ExampleItemEntity value, $Res Function(_ExampleItemEntity) _then) = __$ExampleItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, DateTime createdAt
});




}
/// @nodoc
class __$ExampleItemEntityCopyWithImpl<$Res>
    implements _$ExampleItemEntityCopyWith<$Res> {
  __$ExampleItemEntityCopyWithImpl(this._self, this._then);

  final _ExampleItemEntity _self;
  final $Res Function(_ExampleItemEntity) _then;

/// Create a copy of ExampleItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? createdAt = null,}) {
  return _then(_ExampleItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
