import 'dart:typed_data';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:logging/logging.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class SpringMapOption {
  const SpringMapOption._({
    required this.name,
    required this.iconBytes,
    required this._supportedMap,
  });

  final String name;
  final Uint8List iconBytes;
  final SupportedMap _supportedMap;
}

abstract interface class SpringMapService {
  Future<List<SpringMapOption>> installedMaps({
    required LatLng position,
    required String title,
  });

  Future<bool> open(SpringMapOption option);

  Future<bool> openWebFallback(LatLng position);
}

class MapLauncherSpringMapService implements SpringMapService {
  final Logger _logger = Logger('SpringMapService');

  static const List<MapApp> _markerMaps = [
    MapApp.mapyCz,
    MapApp.osmand,
    MapApp.osmandplus,
    MapApp.mapswithme,
    MapApp.apple,
    MapApp.google,
    MapApp.here,
    MapApp.yandexMaps,
    MapApp.yandexNavi,
    MapApp.copilot,
  ];

  static const List<MapApp> _preferredOrder = [
    MapApp.mapyCz,
    MapApp.osmand,
    MapApp.osmandplus,
    MapApp.mapswithme,
    MapApp.apple,
    MapApp.google,
  ];

  @visibleForTesting
  static List<SupportedMap> orderForDisplay(List<SupportedMap> installed) {
    final byId = {for (final map in installed) map.map.id: map};
    final preferredIds = _preferredOrder.map((map) => map.id).toSet();
    return [
      for (final map in _preferredOrder) ?byId[map.id],
      for (final map in installed)
        if (!preferredIds.contains(map.map.id)) map,
    ];
  }

  static String mapyUrl(LatLng position) =>
      'https://mapy.cz/zakladni?y=${position.latitude}&x=${position.longitude}&z=17';

  @override
  Future<List<SpringMapOption>> installedMaps({
    required LatLng position,
    required String title,
  }) async {
    try {
      final request = MapLauncher.marker(
        Location.coords(position.latitude, position.longitude, title: title),
        zoom: 17,
      );
      final supported = await request.getSupportedMaps(_markerMaps);
      return [
        for (final map in orderForDisplay(
          supported.where((map) => map.isInstalled).toList(),
        ))
          SpringMapOption._(
            name: map.name,
            iconBytes: map.iconBytes,
            supportedMap: map,
          ),
      ];
    } catch (error, stackTrace) {
      _logger.warning('Failed to query installed maps', error, stackTrace);
      return const [];
    }
  }

  @override
  Future<bool> open(SpringMapOption option) async {
    try {
      await option._supportedMap.show();
      return true;
    } catch (error, stackTrace) {
      _logger.warning('Failed to open ${option.name}', error, stackTrace);
      return false;
    }
  }

  @override
  Future<bool> openWebFallback(LatLng position) async {
    final uri = Uri.parse(mapyUrl(position));
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error, stackTrace) {
      _logger.warning('Failed to launch $uri', error, stackTrace);
      return false;
    }
  }
}

final springMapServiceProvider = Provider<SpringMapService>(
  (_) => MapLauncherSpringMapService(),
);
