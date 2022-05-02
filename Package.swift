// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-multibase",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Multibase",
            targets: ["Multibase"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/swift-libp2p/swift-bases.git", .upToNextMajor(from: "0.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Multibase",
            dependencies: [
                .product(name:  "Base2", package: "swift-bases"),
                .product(name:  "Base8", package: "swift-bases"),
                .product(name:  "BaseX", package: "swift-bases"),
                .product(name: "Base32", package: "swift-bases"),
                .product(name: "Base64", package: "swift-bases")
            ]),
        .testTarget(
            name: "MultibaseTests",
            dependencies: ["Multibase"]),
    ]
)
