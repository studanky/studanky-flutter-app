// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spring_marker_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpringMarkerEntity {

 String get documentId; String get name; LatLng get position; SpringStatus get status;/// Locale of the complete row selected by backend fallback. Retained as
/// response provenance even though the current marker UI does not show it.
 String? get servedLanguageTag; DateTime? get statusUpdatedAt;
/// Create a copy of SpringMarkerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpringMarkerEntityCopyWith<SpringMarkerEntity> get copyWith => _$SpringMarkerEntityCopyWithImpl<SpringMarkerEntity>(this as SpringMarkerEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpringMarkerEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpringMarkerEntity&&(identical(other.documentId, _this.documentId) || other.documentId == _this.documentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.servedLanguageTag, _this.servedLanguageTag) || other.servedLanguageTag == _this.servedLanguageTag)&&(identical(other.statusUpdatedAt, _this.statusUpdatedAt) || other.statusUpdatedAt == _this.statusUpdatedAt));
}


@override
int get hashCode {
  final _this = this as SpringMarkerEntity;
  return Object.hash(runtimeType,_this.documentId,_this.name,_this.position,_this.status,_this.servedLanguageTag,_this.statusUpdatedAt);
}

@override
String toString() {
  final _this = this as SpringMarkerEntity;
  return 'SpringMarkerEntity(documentId: ${_this.documentId}, name: ${_this.name}, position: ${_this.position}, status: ${_this.status}, servedLanguageTag: ${_this.servedLanguageTag}, statusUpdatedAt: ${_this.statusUpdatedAt})';
}


}

/// @nodoc
abstract mixin class $SpringMarkerEntityCopyWith<$Res>  {
  factory $SpringMarkerEntityCopyWith(SpringMarkerEntity value, $Res Function(SpringMarkerEntity) _then) = _$SpringMarkerEntityCopyWithImpl;
@useResult
$Res call({
 String documentId, String name, LatLng position, SpringStatus status, String? servedLanguageTag, DateTime? statusUpdatedAt
});




}
/// @nodoc
class _$SpringMarkerEntityCopyWithImpl<$Res>
    implements $SpringMarkerEntityCopyWith<$Res> {
  _$SpringMarkerEntityCopyWithImpl(this._self, this._then);

  final SpringMarkerEntity _self;
  final $Res Function(SpringMarkerEntity) _then;

/// Create a copy of SpringMarkerEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = null,Object? name = null,Object? position = null,Object? status = null,Object? servedLanguageTag = freezed,Object? statusUpdatedAt = freezed,}) {
  return _then(SpringMarkerEntity(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SpringStatus,servedLanguageTag: freezed == servedLanguageTag ? _self.servedLanguageTag : servedLanguageTag // ignore: cast_nullable_to_non_nullable
as String?,statusUpdatedAt: freezed == statusUpdatedAt ? _self.statusUpdatedAt : statusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpringMarkerEntity].
extension SpringMarkerEntityPatterns on SpringMarkerEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpringMarkerEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpringMarkerEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpringMarkerEntity value)  $default,){
final _that = this;
switch (_that) {
case _SpringMarkerEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpringMarkerEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SpringMarkerEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentId,  String name,  LatLng position,  SpringStatus status,  String? servedLanguageTag,  DateTime? statusUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpringMarkerEntity() when $default != null:
return $default(_that.documentId,_that.name,_that.position,_that.status,_that.servedLanguageTag,_that.statusUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentId,  String name,  LatLng position,  SpringStatus status,  String? servedLanguageTag,  DateTime? statusUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _SpringMarkerEntity():
return $default(_that.documentId,_that.name,_that.position,_that.status,_that.servedLanguageTag,_that.statusUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentId,  String name,  LatLng position,  SpringStatus status,  String? servedLanguageTag,  DateTime? statusUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SpringMarkerEntity() when $default != null:
return $default(_that.documentId,_that.name,_that.position,_that.status,_that.servedLanguageTag,_that.statusUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SpringMarkerEntity implements SpringMarkerEntity {
  const _SpringMarkerEntity({required this.documentId, required this.name, required this.position, required this.status, this.servedLanguageTag, this.statusUpdatedAt});
  

@override final  String documentId;
@override final  String name;
@override final  LatLng position;
@override final  SpringStatus status;
/// Locale of the complete row selected by backend fallback. Retained as
/// response provenance even though the current marker UI does not show it.
@override final  String? servedLanguageTag;
@override final  DateTime? statusUpdatedAt;

/// Create a copy of SpringMarkerEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpringMarkerEntityCopyWith<_SpringMarkerEntity> get copyWith => __$SpringMarkerEntityCopyWithImpl<_SpringMarkerEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpringMarkerEntity&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.status, status) || other.status == status)&&(identical(other.servedLanguageTag, servedLanguageTag) || other.servedLanguageTag == servedLanguageTag)&&(identical(other.statusUpdatedAt, statusUpdatedAt) || other.statusUpdatedAt == statusUpdatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,documentId,name,position,status,servedLanguageTag,statusUpdatedAt);
}

@override
String toString() {
    return 'SpringMarkerEntity(documentId: $documentId, name: $name, position: $position, status: $status, servedLanguageTag: $servedLanguageTag, statusUpdatedAt: $statusUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$SpringMarkerEntityCopyWith<$Res> implements $SpringMarkerEntityCopyWith<$Res> {
  factory _$SpringMarkerEntityCopyWith(_SpringMarkerEntity value, $Res Function(_SpringMarkerEntity) _then) = __$SpringMarkerEntityCopyWithImpl;
@override @useResult
$Res call({
 String documentId, String name, LatLng position, SpringStatus status, String? servedLanguageTag, DateTime? statusUpdatedAt
});




}
/// @nodoc
class __$SpringMarkerEntityCopyWithImpl<$Res>
    implements _$SpringMarkerEntityCopyWith<$Res> {
  __$SpringMarkerEntityCopyWithImpl(this._self, this._then);

  final _SpringMarkerEntity _self;
  final $Res Function(_SpringMarkerEntity) _then;

/// Create a copy of SpringMarkerEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,Object? name = null,Object? position = null,Object? status = null,Object? servedLanguageTag = freezed,Object? statusUpdatedAt = freezed,}) {
  return _then(_SpringMarkerEntity(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SpringStatus,servedLanguageTag: freezed == servedLanguageTag ? _self.servedLanguageTag : servedLanguageTag // ignore: cast_nullable_to_non_nullable
as String?,statusUpdatedAt: freezed == statusUpdatedAt ? _self.statusUpdatedAt : statusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
