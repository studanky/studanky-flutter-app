class SpringBounds {
  const SpringBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  static const SpringBounds global = SpringBounds(
    north: 90,
    south: -90,
    east: 180,
    west: -180,
  );

  final double north;
  final double south;
  final double east;
  final double west;

  bool contains(double latitude, double longitude) {
    final withinLatitude = latitude >= south && latitude <= north;
    final withinLongitude = longitude >= west && longitude <= east;
    return withinLatitude && withinLongitude;
  }

  bool containsPosition({required double latitude, required double longitude}) {
    return contains(latitude, longitude);
  }

  bool containsBounds(SpringBounds other) {
    return other.north <= north &&
        other.south >= south &&
        other.east <= east &&
        other.west >= west;
  }
}
