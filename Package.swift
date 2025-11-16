// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "kv-store",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "kv-store",
            targets: ["kv-store"]
        ),
        .executable(
            name: "kv-store-cli",
            targets: ["kv-store-cli"]
        ),
    ],
    targets: [
        .target(
            name: "kv-store"
        ),
        .executableTarget(
            name: "kv-store-cli",
            dependencies: ["kv-store"]
        ),
        .testTarget(
            name: "kv-storeTests",
            dependencies: ["kv-store"]
        ),
    ]
)
