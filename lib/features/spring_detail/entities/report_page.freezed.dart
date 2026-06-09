// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportPage {

 List<Report> get items; int get page; int get pageCount; int get total;
/// Create a copy of ReportPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPageCopyWith<ReportPage> get copyWith => _$ReportPageCopyWithImpl<ReportPage>(this as ReportPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,pageCount,total);

@override
String toString() {
  return 'ReportPage(items: $items, page: $page, pageCount: $pageCount, total: $total)';
}


}

/// @nodoc
abstract mixin class $ReportPageCopyWith<$Res>  {
  factory $ReportPageCopyWith(ReportPage value, $Res Function(ReportPage) _then) = _$ReportPageCopyWithImpl;
@useResult
$Res call({
 List<Report> items, int page, int pageCount, int total
});




}
/// @nodoc
class _$ReportPageCopyWithImpl<$Res>
    implements $ReportPageCopyWith<$Res> {
  _$ReportPageCopyWithImpl(this._self, this._then);

  final ReportPage _self;
  final $Res Function(ReportPage) _then;

/// Create a copy of ReportPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? pageCount = null,Object? total = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Report>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPage].
extension ReportPagePatterns on ReportPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPage value)  $default,){
final _that = this;
switch (_that) {
case _ReportPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPage value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Report> items,  int page,  int pageCount,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPage() when $default != null:
return $default(_that.items,_that.page,_that.pageCount,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Report> items,  int page,  int pageCount,  int total)  $default,) {final _that = this;
switch (_that) {
case _ReportPage():
return $default(_that.items,_that.page,_that.pageCount,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Report> items,  int page,  int pageCount,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ReportPage() when $default != null:
return $default(_that.items,_that.page,_that.pageCount,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _ReportPage extends ReportPage {
  const _ReportPage({required final  List<Report> items, required this.page, required this.pageCount, required this.total}): _items = items,super._();
  

 final  List<Report> _items;
@override List<Report> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int pageCount;
@override final  int total;

/// Create a copy of ReportPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPageCopyWith<_ReportPage> get copyWith => __$ReportPageCopyWithImpl<_ReportPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,pageCount,total);

@override
String toString() {
  return 'ReportPage(items: $items, page: $page, pageCount: $pageCount, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ReportPageCopyWith<$Res> implements $ReportPageCopyWith<$Res> {
  factory _$ReportPageCopyWith(_ReportPage value, $Res Function(_ReportPage) _then) = __$ReportPageCopyWithImpl;
@override @useResult
$Res call({
 List<Report> items, int page, int pageCount, int total
});




}
/// @nodoc
class __$ReportPageCopyWithImpl<$Res>
    implements _$ReportPageCopyWith<$Res> {
  __$ReportPageCopyWithImpl(this._self, this._then);

  final _ReportPage _self;
  final $Res Function(_ReportPage) _then;

/// Create a copy of ReportPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? pageCount = null,Object? total = null,}) {
  return _then(_ReportPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Report>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
