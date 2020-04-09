// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhoneNumber",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "PhoneNumber",
            type: .dynamic,
            targets: ["PhoneNumber"]
        ),
    ],
    targets: [
        .target(
            name: "PhoneNumber",
            path: "Sources"
        ),
        .testTarget(
            name: "PhoneNumberTests",
            dependencies: ["PhoneNumber"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
