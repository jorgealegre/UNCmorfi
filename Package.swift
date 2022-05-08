// swift-tools-version:5.5
import PackageDescription

// MARK: - Shared

var package = Package(
    name: "UNCmorfi",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(name: "SharedModels", targets: ["SharedModels"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SharedModels")
    ]
)

// MARK: - Server

package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.2"),
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
])
package.products.append(contentsOf: [
])
package.targets.append(contentsOf: [
    .executableTarget(
        name: "ServerRunner",
        dependencies: [
            .target(name: "Server")
        ]
    ),
    .target(
        name: "Server",
        dependencies: [
            .product(name: "Vapor", package: "vapor"),
            "SwiftSoup",
            "SharedModels"
        ],
        swiftSettings: [
            // Enable better optimizations when building in Release configuration. Despite the use of
            // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
            // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
            .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
        ]
    ),
    .testTarget(
        name: "ServerTests",
        dependencies: [
            .target(name: "Server"),
            .product(name: "XCTVapor", package: "vapor"),
        ]
    )
])

// MARK: - Client

package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.34.0"),
])
package.products.append(contentsOf: [
    .library(name: "UsersFeature", targets: ["UsersFeature"]),
])
package.targets.append(contentsOf: [
    .target(
        name: "UsersFeature",
        dependencies: [
            "SharedModels",
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
    ),
    .testTarget(
        name: "UsersFeatureTests",
        dependencies: [
            "UsersFeature"
        ]
    ),
])
