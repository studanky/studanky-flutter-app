// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "geolocator_apple",
    platforms: [
        .iOS("11.0"),
        .macOS("10.11")
    ],
    products: [
        .library(name: "geolocator-apple", targets: ["geolocator_apple"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "geolocator_apple",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ],
            publicHeadersPath: "include/geolocator_apple",
            cSettings: [
                .headerSearchPath("include/geolocator_apple"),
                // This application only uses foreground location. Compile the
                // unused Always authorization path out of the iOS binary so
                // App Store Connect does not require a misleading purpose key.
                .define(
                    "BYPASS_PERMISSION_LOCATION_ALWAYS",
                    to: "1",
                    .when(platforms: [.iOS])
                )
            ]
        )
    ]
)
