// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "UNCmorfiKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "UNCmorfiKit",
            targets: ["UNCmorfiKit"]),
    ],
    targets: [
        .target(
            name: "UNCmorfiKit",
            dependencies: []),
        .testTarget(
            name: "UNCmorfiKitTests",
            dependencies: ["UNCmorfiKit"]),
    ]
)
