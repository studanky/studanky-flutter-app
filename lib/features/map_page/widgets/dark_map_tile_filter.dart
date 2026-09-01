import 'package:flutter/material.dart';

/// Gives light raster map tiles a colourful, cool urban appearance in dark
/// mode without affecting markers, location overlays, or attribution.
///
/// The source Mapy.com Outdoor tiles have no native dark variant. This matrix
/// inverts their lightness and remaps warm and green chroma to steel blue, cyan,
/// and violet. The transform also expands chroma and tonal contrast so map
/// surfaces remain distinct instead of looking grey. It cannot restyle
/// individual map features like a vector map style. Applying it once to the
/// complete tile container avoids one filter layer per individual tile.
class DarkMapTileFilter extends StatelessWidget {
  const DarkMapTileFilter({required this.child, super.key});

  /// High-contrast urban night transform with vivid, cool colour separation.
  static const colorMatrix = <double>[
    0.1975883,
    -1.2113586,
    0.0788787,
    0,
    236.847432,
    -0.3007724,
    -0.565868,
    -0.1254511,
    0,
    256.867432,
    -0.3098929,
    -0.5965501,
    -0.1285485,
    0,
    299.767432,
    0,
    0,
    0,
    1,
    0,
  ];

  static const colorFilter = ColorFilter.matrix(colorMatrix);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(colorFilter: colorFilter, child: child);
  }
}
