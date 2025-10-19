import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studanky_flutter_app/features/core/constants/map_constants.dart';

import 'package:studanky_flutter_app/features/map/models/map_marker.dart';

// Will be adjusted with design system
Marker buildMarker(MapMarker marker) {
  return Marker(
    point: marker.position,
    width: 150,
    height: 64,
    alignment: Alignment.topCenter,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(MapConstants.mapSpringPoint),
        ),
      ],
    ),
  );
}
