// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Report {

 String get documentId; bool get isFlowing; DateTime get reportedAt; int? get flowScale; double? get flowRateLps; bool? get hasOdor; WaterClarity? get waterClarity; String? get note;
/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCopyWith<Report> get copyWith => _$ReportCopyWithImpl<Report>(this as Report, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Report&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.isFlowing, isFlowing) || other.isFlowing == isFlowing)&&(identical(other.reportedAt, reportedAt) || other.reportedAt == reportedAt)&&(identical(other.flowScale, flowScale) || other.flowScale == flowScale)&&(identical(other.flowRateLps, flowRateLps) || other.flowRateLps == flowRateLps)&&(identical(other.hasOdor, hasOdor) || other.hasOdor == hasOdor)&&(identical(other.waterClarity, waterClarity) || other.waterClarity == waterClarity)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,documentId,isFlowing,reportedAt,flowScale,flowRateLps,hasOdor,waterClarity,note);

@override
String toString() {
  return 'Report(documentId: $documentId, isFlowing: $isFlowing, reportedAt: $reportedAt, flowScale: $flowScale, flowRateLps: $flowRateLps, hasOdor: $hasOdor, waterClarity: $waterClarity, note: $note)';
}


}

/// @nodoc
abstract mixin class $ReportCopyWith<$Res>  {
  factory $ReportCopyWith(Report value, $Res Function(Report) _then) = _$ReportCopyWithImpl;
@useResult
$Res call({
 String documentId, bool isFlowing, DateTime reportedAt, int? flowScale, double? flowRateLps, bool? hasOdor, WaterClarity? waterClarity, String? note
});




}
/// @nodoc
class _$ReportCopyWithImpl<$Res>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._self, this._then);

  final Report _self;
  final $Res Function(Report) _then;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? documentId = null,Object? isFlowing = null,Object? reportedAt = null,Object? flowScale = freezed,Object? flowRateLps = freezed,Object? hasOdor = freezed,Object? waterClarity = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,isFlowing: null == isFlowing ? _self.isFlowing : isFlowing // ignore: cast_nullable_to_non_nullable
as bool,reportedAt: null == reportedAt ? _self.reportedAt : reportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,flowScale: freezed == flowScale ? _self.flowScale : flowScale // ignore: cast_nullable_to_non_nullable
as int?,flowRateLps: freezed == flowRateLps ? _self.flowRateLps : flowRateLps // ignore: cast_nullable_to_non_nullable
as double?,hasOdor: freezed == hasOdor ? _self.hasOdor : hasOdor // ignore: cast_nullable_to_non_nullable
as bool?,waterClarity: freezed == waterClarity ? _self.waterClarity : waterClarity // ignore: cast_nullable_to_non_nullable
as WaterClarity?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Report].
extension ReportPatterns on Report {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Report value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Report() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Report value)  $default,){
final _that = this;
switch (_that) {
case _Report():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Report value)?  $default,){
final _that = this;
switch (_that) {
case _Report() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String documentId,  bool isFlowing,  DateTime reportedAt,  int? flowScale,  double? flowRateLps,  bool? hasOdor,  WaterClarity? waterClarity,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Report() when $default != null:
return $default(_that.documentId,_that.isFlowing,_that.reportedAt,_that.flowScale,_that.flowRateLps,_that.hasOdor,_that.waterClarity,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String documentId,  bool isFlowing,  DateTime reportedAt,  int? flowScale,  double? flowRateLps,  bool? hasOdor,  WaterClarity? waterClarity,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Report():
return $default(_that.documentId,_that.isFlowing,_that.reportedAt,_that.flowScale,_that.flowRateLps,_that.hasOdor,_that.waterClarity,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String documentId,  bool isFlowing,  DateTime reportedAt,  int? flowScale,  double? flowRateLps,  bool? hasOdor,  WaterClarity? waterClarity,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Report() when $default != null:
return $default(_that.documentId,_that.isFlowing,_that.reportedAt,_that.flowScale,_that.flowRateLps,_that.hasOdor,_that.waterClarity,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _Report extends Report {
  const _Report({required this.documentId, required this.isFlowing, required this.reportedAt, this.flowScale, this.flowRateLps, this.hasOdor, this.waterClarity, this.note}): super._();
  

@override final  String documentId;
@override final  bool isFlowing;
@override final  DateTime reportedAt;
@override final  int? flowScale;
@override final  double? flowRateLps;
@override final  bool? hasOdor;
@override final  WaterClarity? waterClarity;
@override final  String? note;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportCopyWith<_Report> get copyWith => __$ReportCopyWithImpl<_Report>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Report&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.isFlowing, isFlowing) || other.isFlowing == isFlowing)&&(identical(other.reportedAt, reportedAt) || other.reportedAt == reportedAt)&&(identical(other.flowScale, flowScale) || other.flowScale == flowScale)&&(identical(other.flowRateLps, flowRateLps) || other.flowRateLps == flowRateLps)&&(identical(other.hasOdor, hasOdor) || other.hasOdor == hasOdor)&&(identical(other.waterClarity, waterClarity) || other.waterClarity == waterClarity)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,documentId,isFlowing,reportedAt,flowScale,flowRateLps,hasOdor,waterClarity,note);

@override
String toString() {
  return 'Report(documentId: $documentId, isFlowing: $isFlowing, reportedAt: $reportedAt, flowScale: $flowScale, flowRateLps: $flowRateLps, hasOdor: $hasOdor, waterClarity: $waterClarity, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ReportCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$ReportCopyWith(_Report value, $Res Function(_Report) _then) = __$ReportCopyWithImpl;
@override @useResult
$Res call({
 String documentId, bool isFlowing, DateTime reportedAt, int? flowScale, double? flowRateLps, bool? hasOdor, WaterClarity? waterClarity, String? note
});




}
/// @nodoc
class __$ReportCopyWithImpl<$Res>
    implements _$ReportCopyWith<$Res> {
  __$ReportCopyWithImpl(this._self, this._then);

  final _Report _self;
  final $Res Function(_Report) _then;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? documentId = null,Object? isFlowing = null,Object? reportedAt = null,Object? flowScale = freezed,Object? flowRateLps = freezed,Object? hasOdor = freezed,Object? waterClarity = freezed,Object? note = freezed,}) {
  return _then(_Report(
documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,isFlowing: null == isFlowing ? _self.isFlowing : isFlowing // ignore: cast_nullable_to_non_nullable
as bool,reportedAt: null == reportedAt ? _self.reportedAt : reportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,flowScale: freezed == flowScale ? _self.flowScale : flowScale // ignore: cast_nullable_to_non_nullable
as int?,flowRateLps: freezed == flowRateLps ? _self.flowRateLps : flowRateLps // ignore: cast_nullable_to_non_nullable
as double?,hasOdor: freezed == hasOdor ? _self.hasOdor : hasOdor // ignore: cast_nullable_to_non_nullable
as bool?,waterClarity: freezed == waterClarity ? _self.waterClarity : waterClarity // ignore: cast_nullable_to_non_nullable
as WaterClarity?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
