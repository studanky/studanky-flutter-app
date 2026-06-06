/// Geographic bounding box for a spring map query, decoupled from any map
/// library type. Serialised to the API as `bbox=west,south,east,north`.
class SpringBounds {
  const SpringBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  final double north;
  final double south;
  final double east;
  final double west;

  bool containsPosition({required double latitude, required double longitude}) {
    final withinLatitude = latitude >= south && latitude <= north;
    final withinLongitude = longitude >= west && longitude <= east;
    return withinLatitude && withinLongitude;
  }
}
