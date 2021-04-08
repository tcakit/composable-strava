// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ComposableStrava",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ComposableStrava",
            targets: ["ComposableStrava"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.16.0"),
        .package(url: "https://github.com/joeblau/StravaSwift", .branch("master"))
    ],
    targets: [
        .target(
            name: "ComposableStrava",
        dependencies: [
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            .product(name: "StravaSwift", package: "StravaSwift")
        ]),
        .testTarget(
            name: "ComposableStravaTests",
            dependencies: ["ComposableStrava"]),
    ]
)
