// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Changelogger",
                      platforms: [
                          .macOS(.v10_13)
                      ],
                      products: [
                          .executable(name: "Changelogger", targets: ["Changelogger"])
                      ],
                      dependencies: [
                          .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
                          .package(url: "https://github.com/JohnSundell/Files", from: "4.2.0")
                      ],
                      targets: [
                          .executableTarget(name: "Changelogger",
                                            dependencies: [
                                                .targetItem(name: "ChangeloggerCore", condition: nil)
                                            ]),
                          .target(name: "ChangeloggerCore", dependencies: [
                              .product(name: "ArgumentParser", package: "swift-argument-parser"),
                              .product(name: "Files", package: "Files")
                          ])
                      ])
