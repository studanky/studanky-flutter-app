# Local patch: foreground-only location on iOS

This directory vendors the production sources of `geolocator_apple` 2.3.14
from pub.dev (archive SHA-256
`853803d6bb1713c094e935b4a5ae5f19c0308acf81da13fa9ff84fb4c70c0b73`).
Upstream examples and tests are intentionally omitted; `LICENSE`, attribution,
and package metadata are retained.

The only source change is in `darwin/geolocator_apple/Package.swift`: the iOS
Swift Package target defines `BYPASS_PERMISSION_LOCATION_ALWAYS=1`. Studánky
uses location only while its map is active and must not link the unused
`requestAlwaysAuthorization` code path.

The upstream package documents this flag only for CocoaPods. Flutter uses
Swift Package Manager by default, and the SwiftPM gap remains open in
[Baseflow/flutter-geolocator#1763](https://github.com/Baseflow/flutter-geolocator/issues/1763)
with an unmerged proposal in
[Baseflow/flutter-geolocator#1788](https://github.com/Baseflow/flutter-geolocator/pull/1788).
Keeping the small patch in the application repository makes CI and release
builds reproducible without relying on a mutable Git branch or disabling
SwiftPM.

After changing this package, verify a release build directly:

```sh
flutter clean
flutter build ios --release --no-codesign
strings -a build/ios/iphoneos/Runner.app/Runner \
  | grep requestAlwaysAuthorization
```

The final command must produce no output. `requestWhenInUseAuthorization` is
expected to remain.

Remove this override and use the upstream package again after
[Baseflow/flutter-geolocator#1763](https://github.com/Baseflow/flutter-geolocator/issues/1763)
is fixed in a stable release and its release build no longer contains
`requestAlwaysAuthorization`. Then delete the `dependency_overrides` entry and
this directory, run `flutter pub get`, and repeat the release-binary check.
