// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spring_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpringPhoto {

 String get url; String? get thumbnailUrl; int? get width; int? get height;
/// Create a copy of SpringPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpringPhotoCopyWith<SpringPhoto> get copyWith => _$SpringPhotoCopyWithImpl<SpringPhoto>(this as SpringPhoto, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpringPhoto&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,url,thumbnailUrl,width,height);

@override
String toString() {
  return 'SpringPhoto(url: $url, thumbnailUrl: $thumbnailUrl, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $SpringPhotoCopyWith<$Res>  {
  factory $SpringPhotoCopyWith(SpringPhoto value, $Res Function(SpringPhoto) _then) = _$SpringPhotoCopyWithImpl;
@useResult
$Res call({
 String url, String? thumbnailUrl, int? width, int? height
});




}
/// @nodoc
class _$SpringPhotoCopyWithImpl<$Res>
    implements $SpringPhotoCopyWith<$Res> {
  _$SpringPhotoCopyWithImpl(this._self, this._then);

  final SpringPhoto _self;
  final $Res Function(SpringPhoto) _then;

/// Create a copy of SpringPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? thumbnailUrl = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpringPhoto].
extension SpringPhotoPatterns on SpringPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpringPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpringPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpringPhoto value)  $default,){
final _that = this;
switch (_that) {
case _SpringPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpringPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _SpringPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String? thumbnailUrl,  int? width,  int? height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpringPhoto() when $default != null:
return $default(_that.url,_that.thumbnailUrl,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String? thumbnailUrl,  int? width,  int? height)  $default,) {final _that = this;
switch (_that) {
case _SpringPhoto():
return $default(_that.url,_that.thumbnailUrl,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String? thumbnailUrl,  int? width,  int? height)?  $default,) {final _that = this;
switch (_that) {
case _SpringPhoto() when $default != null:
return $default(_that.url,_that.thumbnailUrl,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc


class _SpringPhoto extends SpringPhoto {
  const _SpringPhoto({required this.url, this.thumbnailUrl, this.width, this.height}): super._();
  

@override final  String url;
@override final  String? thumbnailUrl;
@override final  int? width;
@override final  int? height;

/// Create a copy of SpringPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpringPhotoCopyWith<_SpringPhoto> get copyWith => __$SpringPhotoCopyWithImpl<_SpringPhoto>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpringPhoto&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}


@override
int get hashCode => Object.hash(runtimeType,url,thumbnailUrl,width,height);

@override
String toString() {
  return 'SpringPhoto(url: $url, thumbnailUrl: $thumbnailUrl, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$SpringPhotoCopyWith<$Res> implements $SpringPhotoCopyWith<$Res> {
  factory _$SpringPhotoCopyWith(_SpringPhoto value, $Res Function(_SpringPhoto) _then) = __$SpringPhotoCopyWithImpl;
@override @useResult
$Res call({
 String url, String? thumbnailUrl, int? width, int? height
});




}
/// @nodoc
class __$SpringPhotoCopyWithImpl<$Res>
    implements _$SpringPhotoCopyWith<$Res> {
  __$SpringPhotoCopyWithImpl(this._self, this._then);

  final _SpringPhoto _self;
  final $Res Function(_SpringPhoto) _then;

/// Create a copy of SpringPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? thumbnailUrl = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_SpringPhoto(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
