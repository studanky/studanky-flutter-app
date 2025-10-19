import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map/widgets/marker.dart';

class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  final LatLng _zdar = const LatLng(49.5630, 15.9398);
  final double _defaultZoom = 14.5;

  final MapController _mapController = MapController();

  final List<Marker> _markers = [
    buildMarker(const LatLng(49.5638, 15.9398), label: 'Zelená hora'),
    buildMarker(const LatLng(49.5613, 15.9380), label: 'Town Square'),
  ];

  void _addMarker(LatLng latLng) {
    setState(() {
      _markers.add(
        buildMarker(
          latLng,
          label:
              '${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _zdar,
                initialZoom: _defaultZoom,
                interactionOptions: const InteractionOptions(
                  flags:
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.drag,
                ),
                onTap: (tapPosition, coord) => _addMarker(coord),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapy.com/v1/maptiles/basic/256/{z}/{x}/{y}?apikey=U4_1WylUX52au77JaAJbXlLAGOCvrfCC1L1bVMwGIqQ',
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
