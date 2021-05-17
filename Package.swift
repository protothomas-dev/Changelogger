// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Changelogger",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "Changelogger", targets: ["Changelogger"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0")
    ],
    targets: [
        .target(name: "Changelogger", dependencies: ["ChangeloggerCore"]),
        .target(name: "ChangeloggerCore", dependencies: ["ArgumentParser", "Files"])
    ]
)

