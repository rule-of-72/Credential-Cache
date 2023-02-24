// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Credential Cache",
    platforms: [.iOS(.v15), .macCatalyst(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Credential Cache",
            targets: ["CredentialCache"]
        ),
        .library(
            name: "Credential Cache UI",
            targets: ["CredentialCacheUI"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/rule-of-72/R72-UI-Helpers", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CredentialCache",
            dependencies: [],
            path: "Sources/Credential Cache"
        ),
        .target(
            name: "CredentialCacheUI",
            dependencies: [
                .target(name: "CredentialCache"),
                .product(name: "R72-UI-Helpers", package: "R72-UI-Helpers")
            ],
            path: "Sources/Credential Cache UI"
        ),
        .testTarget(
            name: "Credential Cache tests",
            dependencies: ["CredentialCache"]
        ),
    ]
)
