// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "UNCmorfi",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "UsersFeature", targets: ["UsersFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.34.0")
    ],
    targets: [
        .target(
            name: "UsersFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "UsersFeatureTests",
            dependencies: [
                "UsersFeature"
            ]
        ),
    ]
)
