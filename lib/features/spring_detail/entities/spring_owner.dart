import 'package:freezed_annotation/freezed_annotation.dart';

part 'spring_owner.freezed.dart';

/// The B2B owner of a spring (e.g. ČHMÚ), shown as a small provenance tag.
@freezed
abstract class SpringOwner with _$SpringOwner {
  const factory SpringOwner({required String name, String? type}) =
      _SpringOwner;
}
