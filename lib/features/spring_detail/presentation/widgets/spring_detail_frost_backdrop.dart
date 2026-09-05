import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/widgets/backdrop_blur_scope.dart';

/// Non-interactive frost that follows the detail sheet's extent and entrance.
class SpringDetailFrostBackdrop extends StatelessWidget {
  const SpringDetailFrostBackdrop({
    super.key,
    required this.animation,
    required this.extent,
  });

  final Animation<double> animation;
  final ValueListenable<double> extent;

  static const double _frostStartExtent = 0.65;
  static const double _frostFullExtent = 0.95;

  @override
  Widget build(BuildContext context) {
    final blurEnabled = BackdropBlurScope.enabledOf(context);

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: Listenable.merge([animation, extent]),
        builder: (context, _) {
          final frostProgress =
              ((extent.value - _frostStartExtent) /
                      (_frostFullExtent - _frostStartExtent))
                  .clamp(0.0, 1.0);
          final sigma = kBackdropBlurSigma * animation.value * frostProgress;
          if (sigma == 0) return const SizedBox.expand();
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            enabled: blurEnabled,
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}
