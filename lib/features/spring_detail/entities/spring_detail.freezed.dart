// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spring_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpringDetail {

 String get documentId; String get name; LatLng get position; SpringStatus get status; String? get description;/// Locale of the complete detail selected by backend fallback. Keeping it
/// prevents future caches/diagnostics from assuming the requested locale
/// was served, as required by the API migration contract.
 String? get servedLanguageTag; DateTime? get statusUpdatedAt; int? get lastFlowScale; double? get lastFlowRateLps; SpringPhoto? get photo; SpringOwner? get owner;
/// Create a copy of SpringDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpringDetailCopyWith<SpringDetail> get copyWith => _$SpringDetailCopyWithImpl<SpringDetail>(this as SpringDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpringDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpringDetail&&(identical(other.documentId, _this.documentId) || other.documentId == _this.documentId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.servedLanguageTag, _this.servedLanguageTag) || other.servedLanguageTag == _this.servedLanguageTag)&&(identical(other.statusUpdatedAt, _this.statusUpdatedAt) || other.statusUpdatedAt == _this.statusUpdatedAt)&&(identical(other.lastFlowScale, _this.lastFlowScale) || other.lastFlowScale == _this.lastFlowScale)&&(identical(other.lastFlowRateLps, _this.lastFlowRateLps) || other.lastFlowRateLps == _this.lastFlowRateLps)&&(identical(other.photo, _this.photo) || other.photo == _this.photo)&&(identical(other.owner, _this.owner) || other.owner == _this.owner));
}


@override
int get hashCode {
  final _this = this as SpringDetail;
  return Object.hash(runtimeType,_this.documentId,_this.name,_this.position,_this.status,_this.description,_this.servedLanguageTag,_this.statusUpdatedAt,_this.lastFlowScale,_this.lastFlowRateLps,_this.photo,_this.owner);
}

@override
String toString() {
  final _this = this as SpringDetail;
  return 'SpringDetail(documentId: ${_this.documentId}, name: ${_this.name}, position: ${_this.position}, status: ${_this.status}, description: ${_this.description}, servedLanguageTag: ${_this.servedLanguageTag}, statusUpdatedAt: ${_this.statusUpdatedAt}, lastFlowScale: ${_this.lastFlowScale}, lastFlowRateLps: ${_this.lastFlowRateLps}, photo: ${_this.photo}, owner: ${_this.owner})';
}


}

/// @nodoc
abstract mixin class $SpringDetailCopyWith<$Res>  {
  factory $SpringDetailCopyWith(SpringDetail value, $Res Function(SpringDetail) _then) = _$SpringDetailCopyWithImpl;
@useResult
$Res call({
 String documentId, String name, LatLng position, SpringStatus status, String? description, String? servedLanguageTag, DateTime? statusUpdatedAt, int? lastFlowScale, double? lastFlowRateLps, SpringPhoto? photo, SpringOwner? owner
});


$SpringPhotoCopyWith<$Res>? get photo;$SpringOwnerCopyWith<$Res>? get owner;

}
/// @nodoc
class _$SpringDetailCopyWithImpl<$Res>
    implements $SpringDetailCopyWith<$Res> {
  _$SpringDetailCopyWithImpl(this._self, this._then);

  final SpringDetail _self;
  final $Res Function(SpringDetail) _then;

/// Create a copy of SpringDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = null,Object? name = null,Object? position = null,Object? status = null,Object? description = freezed,Object? servedLanguageTag = freezed,Object? statusUpdatedAt = freezed,Object? lastFlowScale = freezed,Object? lastFlowRateLps = freezed,Object? photo = freezed,Object? owner = freezed,}) {
  return _then(SpringDetail(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SpringStatus,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,servedLanguageTag: freezed == servedLanguageTag ? _self.servedLanguageTag : servedLanguageTag // ignore: cast_nullable_to_non_nullable
as String?,statusUpdatedAt: freezed == statusUpdatedAt ? _self.statusUpdatedAt : statusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastFlowScale: freezed == lastFlowScale ? _self.lastFlowScale : lastFlowScale // ignore: cast_nullable_to_non_nullable
as int?,lastFlowRateLps: freezed == lastFlowRateLps ? _self.lastFlowRateLps : lastFlowRateLps // ignore: cast_nullable_to_non_nullable
as double?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as SpringPhoto?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as SpringOwner?,
  ));
}
/// Create a copy of SpringDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpringPhotoCopyWith<$Res>? get photo {
    if (_self.photo == null) {
    return null;
  }

  return $SpringPhotoCopyWith<$Res>(_self.photo!, (value) {
    return _then(_self.copyWith(photo: value));
  });
}/// Create a copy of SpringDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpringOwnerCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $SpringOwnerCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [SpringDetail].
extension SpringDetailPatterns on SpringDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpringDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpringDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpringDetail value)  $default,){
final _that = this;
switch (_that) {
case _SpringDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpringDetail value)?  $default,){
final _that = this;
switch (_that) {
case _SpringDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentId,  String name,  LatLng position,  SpringStatus status,  String? description,  String? servedLanguageTag,  DateTime? statusUpdatedAt,  int? lastFlowScale,  double? lastFlowRateLps,  SpringPhoto? photo,  SpringOwner? owner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpringDetail() when $default != null:
return $default(_that.documentId,_that.name,_that.position,_that.status,_that.description,_that.servedLanguageTag,_that.statusUpdatedAt,_that.lastFlowScale,_that.lastFlowRateLps,_that.photo,_that.owner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentId,  String name,  LatLng position,  SpringStatus status,  String? description,  String? servedLanguageTag,  DateTime? statusUpdatedAt,  int? lastFlowScale,  double? lastFlowRateLps,  SpringPhoto? photo,  SpringOwner? owner)  $default,) {final _that = this;
switch (_that) {
case _SpringDetail():
return $default(_that.documentId,_that.name,_that.position,_that.status,_that.description,_that.servedLanguageTag,_that.statusUpdatedAt,_that.lastFlowScale,_that.lastFlowRateLps,_that.photo,_that.owner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentId,  String name,  LatLng position,  SpringStatus status,  String? description,  String? servedLanguageTag,  DateTime? statusUpdatedAt,  int? lastFlowScale,  double? lastFlowRateLps,  SpringPhoto? photo,  SpringOwner? owner)?  $default,) {final _that = this;
switch (_that) {
case _SpringDetail() when $default != null:
return $default(_that.documentId,_that.name,_that.position,_that.status,_that.description,_that.servedLanguageTag,_that.statusUpdatedAt,_that.lastFlowScale,_that.lastFlowRateLps,_that.photo,_that.owner);case _:
  return null;

}
}

}

/// @nodoc


class _SpringDetail implements SpringDetail {
  const _SpringDetail({required this.documentId, required this.name, required this.position, required this.status, this.description, this.servedLanguageTag, this.statusUpdatedAt, this.lastFlowScale, this.lastFlowRateLps, this.photo, this.owner});
  

@override final  String documentId;
@override final  String name;
@override final  LatLng position;
@override final  SpringStatus status;
@override final  String? description;
/// Locale of the complete detail selected by backend fallback. Keeping it
/// prevents future caches/diagnostics from assuming the requested locale
/// was served, as required by the API migration contract.
@override final  String? servedLanguageTag;
@override final  DateTime? statusUpdatedAt;
@override final  int? lastFlowScale;
@override final  double? lastFlowRateLps;
@override final  SpringPhoto? photo;
@override final  SpringOwner? owner;

/// Create a copy of SpringDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpringDetailCopyWith<_SpringDetail> get copyWith => __$SpringDetailCopyWithImpl<_SpringDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpringDetail&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.servedLanguageTag, servedLanguageTag) || other.servedLanguageTag == servedLanguageTag)&&(identical(other.statusUpdatedAt, statusUpdatedAt) || other.statusUpdatedAt == statusUpdatedAt)&&(identical(other.lastFlowScale, lastFlowScale) || other.lastFlowScale == lastFlowScale)&&(identical(other.lastFlowRateLps, lastFlowRateLps) || other.lastFlowRateLps == lastFlowRateLps)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.owner, owner) || other.owner == owner));
}


@override
int get hashCode {
    return Object.hash(runtimeType,documentId,name,position,status,description,servedLanguageTag,statusUpdatedAt,lastFlowScale,lastFlowRateLps,photo,owner);
}

@override
String toString() {
    return 'SpringDetail(documentId: $documentId, name: $name, position: $position, status: $status, description: $description, servedLanguageTag: $servedLanguageTag, statusUpdatedAt: $statusUpdatedAt, lastFlowScale: $lastFlowScale, lastFlowRateLps: $lastFlowRateLps, photo: $photo, owner: $owner)';
}


}

/// @nodoc
abstract mixin class _$SpringDetailCopyWith<$Res> implements $SpringDetailCopyWith<$Res> {
  factory _$SpringDetailCopyWith(_SpringDetail value, $Res Function(_SpringDetail) _then) = __$SpringDetailCopyWithImpl;
@override @useResult
$Res call({
 String documentId, String name, LatLng position, SpringStatus status, String? description, String? servedLanguageTag, DateTime? statusUpdatedAt, int? lastFlowScale, double? lastFlowRateLps, SpringPhoto? photo, SpringOwner? owner
});


@override $SpringPhotoCopyWith<$Res>? get photo;@override $SpringOwnerCopyWith<$Res>? get owner;

}
/// @nodoc
class __$SpringDetailCopyWithImpl<$Res>
    implements _$SpringDetailCopyWith<$Res> {
  __$SpringDetailCopyWithImpl(this._self, this._then);

  final _SpringDetail _self;
  final $Res Function(_SpringDetail) _then;

/// Create a copy of SpringDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,Object? name = null,Object? position = null,Object? status = null,Object? description = freezed,Object? servedLanguageTag = freezed,Object? statusUpdatedAt = freezed,Object? lastFlowScale = freezed,Object? lastFlowRateLps = freezed,Object? photo = freezed,Object? owner = freezed,}) {
  return _then(_SpringDetail(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as LatLng,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SpringStatus,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,servedLanguageTag: freezed == servedLanguageTag ? _self.servedLanguageTag : servedLanguageTag // ignore: cast_nullable_to_non_nullable
as String?,statusUpdatedAt: freezed == statusUpdatedAt ? _self.statusUpdatedAt : statusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastFlowScale: freezed == lastFlowScale ? _self.lastFlowScale : lastFlowScale // ignore: cast_nullable_to_non_nullable
as int?,lastFlowRateLps: freezed == lastFlowRateLps ? _self.lastFlowRateLps : lastFlowRateLps // ignore: cast_nullable_to_non_nullable
as double?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as SpringPhoto?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as SpringOwner?,
  ));
}

/// Create a copy of SpringDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpringPhotoCopyWith<$Res>? get photo {
    if (_self.photo == null) {
    return null;
  }

  return $SpringPhotoCopyWith<$Res>(_self.photo!, (value) {
    return _then(_self.copyWith(photo: value));
  });
}/// Create a copy of SpringDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpringOwnerCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $SpringOwnerCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}

// dart format on
