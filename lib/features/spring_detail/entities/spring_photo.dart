import 'package:freezed_annotation/freezed_annotation.dart';

part 'spring_photo.freezed.dart';

/// A spring photo with its absolute URLs (api-reference.md §3.2).
@freezed
abstract class SpringPhoto with _$SpringPhoto {
  const factory SpringPhoto({
    required String url,
    String? thumbnailUrl,
    int? width,
    int? height,
  }) = _SpringPhoto;

  const SpringPhoto._();

  /// Intrinsic aspect ratio when known, for a stable image box before load.
  double? get aspectRatio =>
      (width != null && height != null && height! > 0)
      ? width! / height!
      : null;
}
