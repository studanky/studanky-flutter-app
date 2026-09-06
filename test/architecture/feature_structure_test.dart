import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('feature-local widgets live under presentation/widgets', () {
    final featuresDirectory = Directory('lib/features');
    expect(
      featuresDirectory.existsSync(),
      isTrue,
      reason: 'Architecture tests must run from the package root.',
    );

    final rootWidgetDirectories =
        featuresDirectory
            .listSync(followLinks: false)
            .whereType<Directory>()
            .map(
              (featureDirectory) => Directory(
                '${featureDirectory.path}${Platform.pathSeparator}widgets',
              ),
            )
            .where((directory) => directory.existsSync())
            .map((directory) => directory.path)
            .toList()
          ..sort();

    expect(
      rootWidgetDirectories,
      isEmpty,
      reason:
          'Move feature-local widgets to '
          'lib/features/<feature>/presentation/widgets/.',
    );
  });
}
