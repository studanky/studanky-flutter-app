# Local patches

This directory vendors `geolocator_apple` 2.3.14 from pub.dev.

The only source change is in `darwin/geolocator_apple/Package.swift`: the iOS
Swift Package target defines `BYPASS_PERMISSION_LOCATION_ALWAYS=1`. Studánky
uses location only while its map is active and must not link the unused
`requestAlwaysAuthorization` code path.

Remove this override and use the upstream package again after
[Baseflow/flutter-geolocator#1763](https://github.com/Baseflow/flutter-geolocator/issues/1763)
is fixed in a stable release and its release build no longer contains
`requestAlwaysAuthorization`.
