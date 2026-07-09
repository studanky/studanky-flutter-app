import 'package:flutter_test/flutter_test.dart';
import 'package:studanky_flutter_app/core/navigation/deep_links.dart';

void main() {
  group('DeepLinks.springShareUrl', () {
    test('builds the public https share link for a spring', () {
      expect(
        DeepLinks.springShareUrl('abc123'),
        'https://studankyapp.cz/s/abc123',
      );
    });

    test('percent-encodes path-unsafe characters in the id', () {
      // A raw space must never land in the shared URL.
      expect(
        DeepLinks.springShareUrl('a b'),
        'https://studankyapp.cz/s/a%20b',
      );
    });

    test('the share URL ends with the in-app share path', () {
      expect(
        DeepLinks.springShareUrl('abc123'),
        endsWith(DeepLinks.springSharePath('abc123')),
      );
    });
  });
}
