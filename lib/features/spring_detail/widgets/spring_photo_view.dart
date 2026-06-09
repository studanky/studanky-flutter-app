import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_photo.dart';

/// The spring hero photo. Renders nothing until a photo is actually available
/// (springs have no photos yet — they will be added later), so there is no
/// placeholder when the detail has none or the image fails to load.
class SpringPhotoView extends StatelessWidget {
  const SpringPhotoView({required this.photo, this.height = 200, super.key});

  /// Null while the detail is loading or when the spring has no photo.
  final SpringPhoto? photo;
  final double height;

  @override
  Widget build(BuildContext context) {
    final current = photo;
    if (current == null) return const SizedBox.shrink();

    final colors = Styles.appColors;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.network(
        current.url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return ColoredBox(
            color: colors.neutral200,
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.primaryMain,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        // No photo to show if it fails to load — collapse rather than show a
        // broken-image placeholder.
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
