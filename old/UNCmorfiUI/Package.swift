// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "UNCmorfiUI",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "UNCmorfiUI", targets: ["UNCmorfiUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/thii/FontAwesome.swift", from: "1.8.3"),
    ],
    targets: [
        .target(name: "UNCmorfiUI", dependencies: ["FontAwesome"]),
        .testTarget(name: "UNCmorfiUITests", dependencies: ["UNCmorfiUI"]),
    ]
)
