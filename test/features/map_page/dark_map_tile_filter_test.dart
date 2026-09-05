import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/features/map_page/presentation/widgets/dark_map_tile_filter.dart';

void main() {
  testWidgets('applies one urban night filter and preserves its child', (
    tester,
  ) async {
    final childKey = GlobalKey();

    await tester.pumpWidget(
      DarkMapTileFilter(child: SizedBox(key: childKey, width: 10, height: 10)),
    );

    expect(find.byType(ColorFiltered), findsOneWidget);
    expect(find.byKey(childKey), findsOneWidget);

    final filtered = tester.widget<ColorFiltered>(find.byType(ColorFiltered));
    expect(filtered.colorFilter, DarkMapTileFilter.colorFilter);
    expect(filtered.child?.key, childKey);
  });

  test('maps representative outdoor colours to the urban palette', () {
    const samples = [
      (Color(0xFFFFFFFF), Color(0xFF000424)),
      (Color(0xFF000000), Color(0xFFEDFFFF)),
      (Color(0xFFE8ECEA), Color(0xFF0F1839)), // General land.
      (Color(0xFFE9D8CF), Color(0xFF262748)), // Steel-violet building.
      (Color(0xFF965A3C), Color(0xFFA299C0)), // Violet-grey detail.
      (Color(0xFFBFE5C7), Color(0xFF0D2D4E)), // Cyan-slate forest.
      (Color(0xFFA4D5DC), Color(0xFF1D3B5E)), // Steel-blue water.
      (Color(0xFF4B5563), Color(0xFF9DAED5)), // Secondary label.
    ];

    for (final (input, expected) in samples) {
      _expectColorNear(_transform(input), expected, tolerance: 1);
    }
  });

  test('retains cool colour separation without warm or green cast', () {
    final building = _transform(const Color(0x49E9D8CF));
    final brown = _transform(const Color(0x49965A3C));
    final forest = _transform(const Color(0x49BFE5C7));
    final water = _transform(const Color(0x49A4D5DC));
    final vividGreen = _transform(const Color(0x4900FF00));
    final warmRoad = _transform(const Color(0x49E6BE50));

    for (final color in [
      building,
      brown,
      forest,
      water,
      vividGreen,
      warmRoad,
    ]) {
      expect(_blue(color), greaterThan(_green(color)));
      expect(_chroma(color), greaterThanOrEqualTo(30));
      expect(_alpha(color), 0x49);
    }
    expect(_green(forest), greaterThan(_red(forest)));
    expect(_green(water), greaterThan(_red(water)));
  });

  test('representative secondary labels retain AA contrast', () {
    final label = _transform(const Color(0xFF4B5563));
    const sourceSurfaces = [
      Color(0xFFE8ECEA), // General land.
      Color(0xFFE9D8CF), // Building.
      Color(0xFFBFE5C7), // Forest.
      Color(0xFFA4D5DC), // Water.
    ];

    for (final sourceSurface in sourceSurfaces) {
      final surface = _transform(sourceSurface);
      expect(
        _contrastRatio(label, surface),
        greaterThanOrEqualTo(5),
        reason: '${_hex(label)} on ${_hex(surface)} should remain readable',
      );
    }
  });
}

Color _transform(Color input) {
  final argb = input.toARGB32();
  final channels = <double>[
    ((argb >> 16) & 0xFF).toDouble(),
    ((argb >> 8) & 0xFF).toDouble(),
    (argb & 0xFF).toDouble(),
    ((argb >> 24) & 0xFF).toDouble(),
  ];
  const matrix = DarkMapTileFilter.colorMatrix;

  int transformRow(int start) {
    final value =
        matrix[start] * channels[0] +
        matrix[start + 1] * channels[1] +
        matrix[start + 2] * channels[2] +
        matrix[start + 3] * channels[3] +
        matrix[start + 4];
    return value.round().clamp(0, 255).toInt();
  }

  return Color.fromARGB(
    transformRow(15),
    transformRow(0),
    transformRow(5),
    transformRow(10),
  );
}

void _expectColorNear(Color actual, Color expected, {required int tolerance}) {
  for (final shift in [24, 16, 8, 0]) {
    final actualChannel = (actual.toARGB32() >> shift) & 0xFF;
    final expectedChannel = (expected.toARGB32() >> shift) & 0xFF;
    expect(
      (actualChannel - expectedChannel).abs(),
      lessThanOrEqualTo(tolerance),
      reason: '${_hex(actual)} differs from ${_hex(expected)}',
    );
  }
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = _relativeLuminance(first);
  final secondLuminance = _relativeLuminance(second);
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

double _relativeLuminance(Color color) {
  double linearize(int channel) {
    final value = channel / 255;
    return value <= 0.04045
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * linearize(_red(color)) +
      0.7152 * linearize(_green(color)) +
      0.0722 * linearize(_blue(color));
}

int _alpha(Color color) => (color.toARGB32() >> 24) & 0xFF;

int _red(Color color) => (color.toARGB32() >> 16) & 0xFF;

int _green(Color color) => (color.toARGB32() >> 8) & 0xFF;

int _blue(Color color) => color.toARGB32() & 0xFF;

int _chroma(Color color) {
  final channels = [_red(color), _green(color), _blue(color)];
  return channels.reduce(math.max) - channels.reduce(math.min);
}

String _hex(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
