import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studanky_flutter_app/core/app_constants.dart';
import 'package:studanky_flutter_app/features/map_shared/entities/map_marker_entity.dart';

// TODO: redesign marker widget
Marker buildMarker(MapMarkerEntity marker) {
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
          child: SvgPicture.asset(AppConstants.iconSpring),
        ),
      ],
    ),
  );
}
