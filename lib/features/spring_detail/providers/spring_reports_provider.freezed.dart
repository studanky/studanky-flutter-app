// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spring_reports_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpringReportsState {

/// Reports loaded so far, newest first.
 List<Report> get reports;/// Status of the **first** page load — drives the section's main
/// loading/error/empty rendering.
 AsyncValue<void> get initialStatus;/// A subsequent page is being fetched (footer spinner).
 bool get isLoadingMore;/// Whether another page is available after what is loaded.
 bool get hasMore;/// 1-based page to request next.
 int get nextPage;/// Total number of records reported by the server.
 int get total;/// Error of the most recent [SpringReports.loadMore] (footer retry), kept
/// separate so a failed page never wipes already-loaded reports.
 Object? get loadMoreError;
/// Create a copy of SpringReportsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpringReportsStateCopyWith<SpringReportsState> get copyWith => _$SpringReportsStateCopyWithImpl<SpringReportsState>(this as SpringReportsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpringReportsState&&const DeepCollectionEquality().equals(other.reports, reports)&&(identical(other.initialStatus, initialStatus) || other.initialStatus == initialStatus)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(reports),initialStatus,isLoadingMore,hasMore,nextPage,total,const DeepCollectionEquality().hash(loadMoreError));

@override
String toString() {
  return 'SpringReportsState(reports: $reports, initialStatus: $initialStatus, isLoadingMore: $isLoadingMore, hasMore: $hasMore, nextPage: $nextPage, total: $total, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class $SpringReportsStateCopyWith<$Res>  {
  factory $SpringReportsStateCopyWith(SpringReportsState value, $Res Function(SpringReportsState) _then) = _$SpringReportsStateCopyWithImpl;
@useResult
$Res call({
 List<Report> reports, AsyncValue<void> initialStatus, bool isLoadingMore, bool hasMore, int nextPage, int total, Object? loadMoreError
});




}
/// @nodoc
class _$SpringReportsStateCopyWithImpl<$Res>
    implements $SpringReportsStateCopyWith<$Res> {
  _$SpringReportsStateCopyWithImpl(this._self, this._then);

  final SpringReportsState _self;
  final $Res Function(SpringReportsState) _then;

/// Create a copy of SpringReportsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reports = null,Object? initialStatus = null,Object? isLoadingMore = null,Object? hasMore = null,Object? nextPage = null,Object? total = null,Object? loadMoreError = freezed,}) {
  return _then(_self.copyWith(
reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as List<Report>,initialStatus: null == initialStatus ? _self.initialStatus : initialStatus // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}

}


/// Adds pattern-matching-related methods to [SpringReportsState].
extension SpringReportsStatePatterns on SpringReportsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpringReportsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpringReportsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpringReportsState value)  $default,){
final _that = this;
switch (_that) {
case _SpringReportsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpringReportsState value)?  $default,){
final _that = this;
switch (_that) {
case _SpringReportsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Report> reports,  AsyncValue<void> initialStatus,  bool isLoadingMore,  bool hasMore,  int nextPage,  int total,  Object? loadMoreError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpringReportsState() when $default != null:
return $default(_that.reports,_that.initialStatus,_that.isLoadingMore,_that.hasMore,_that.nextPage,_that.total,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Report> reports,  AsyncValue<void> initialStatus,  bool isLoadingMore,  bool hasMore,  int nextPage,  int total,  Object? loadMoreError)  $default,) {final _that = this;
switch (_that) {
case _SpringReportsState():
return $default(_that.reports,_that.initialStatus,_that.isLoadingMore,_that.hasMore,_that.nextPage,_that.total,_that.loadMoreError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Report> reports,  AsyncValue<void> initialStatus,  bool isLoadingMore,  bool hasMore,  int nextPage,  int total,  Object? loadMoreError)?  $default,) {final _that = this;
switch (_that) {
case _SpringReportsState() when $default != null:
return $default(_that.reports,_that.initialStatus,_that.isLoadingMore,_that.hasMore,_that.nextPage,_that.total,_that.loadMoreError);case _:
  return null;

}
}

}

/// @nodoc


class _SpringReportsState extends SpringReportsState {
  const _SpringReportsState({final  List<Report> reports = const <Report>[], this.initialStatus = const AsyncValue<void>.loading(), this.isLoadingMore = false, this.hasMore = false, this.nextPage = 1, this.total = 0, this.loadMoreError}): _reports = reports,super._();
  

/// Reports loaded so far, newest first.
 final  List<Report> _reports;
/// Reports loaded so far, newest first.
@override@JsonKey() List<Report> get reports {
  if (_reports is EqualUnmodifiableListView) return _reports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reports);
}

/// Status of the **first** page load — drives the section's main
/// loading/error/empty rendering.
@override@JsonKey() final  AsyncValue<void> initialStatus;
/// A subsequent page is being fetched (footer spinner).
@override@JsonKey() final  bool isLoadingMore;
/// Whether another page is available after what is loaded.
@override@JsonKey() final  bool hasMore;
/// 1-based page to request next.
@override@JsonKey() final  int nextPage;
/// Total number of records reported by the server.
@override@JsonKey() final  int total;
/// Error of the most recent [SpringReports.loadMore] (footer retry), kept
/// separate so a failed page never wipes already-loaded reports.
@override final  Object? loadMoreError;

/// Create a copy of SpringReportsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpringReportsStateCopyWith<_SpringReportsState> get copyWith => __$SpringReportsStateCopyWithImpl<_SpringReportsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpringReportsState&&const DeepCollectionEquality().equals(other._reports, _reports)&&(identical(other.initialStatus, initialStatus) || other.initialStatus == initialStatus)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.loadMoreError, loadMoreError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_reports),initialStatus,isLoadingMore,hasMore,nextPage,total,const DeepCollectionEquality().hash(loadMoreError));

@override
String toString() {
  return 'SpringReportsState(reports: $reports, initialStatus: $initialStatus, isLoadingMore: $isLoadingMore, hasMore: $hasMore, nextPage: $nextPage, total: $total, loadMoreError: $loadMoreError)';
}


}

/// @nodoc
abstract mixin class _$SpringReportsStateCopyWith<$Res> implements $SpringReportsStateCopyWith<$Res> {
  factory _$SpringReportsStateCopyWith(_SpringReportsState value, $Res Function(_SpringReportsState) _then) = __$SpringReportsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Report> reports, AsyncValue<void> initialStatus, bool isLoadingMore, bool hasMore, int nextPage, int total, Object? loadMoreError
});




}
/// @nodoc
class __$SpringReportsStateCopyWithImpl<$Res>
    implements _$SpringReportsStateCopyWith<$Res> {
  __$SpringReportsStateCopyWithImpl(this._self, this._then);

  final _SpringReportsState _self;
  final $Res Function(_SpringReportsState) _then;

/// Create a copy of SpringReportsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reports = null,Object? initialStatus = null,Object? isLoadingMore = null,Object? hasMore = null,Object? nextPage = null,Object? total = null,Object? loadMoreError = freezed,}) {
  return _then(_SpringReportsState(
reports: null == reports ? _self._reports : reports // ignore: cast_nullable_to_non_nullable
as List<Report>,initialStatus: null == initialStatus ? _self.initialStatus : initialStatus // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,loadMoreError: freezed == loadMoreError ? _self.loadMoreError : loadMoreError ,
  ));
}


}

// dart format on
