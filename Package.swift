// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XWebKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "XWebKit",
            targets: ["XWebKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.5.0"),
        .package(url: "https://github.com/semicolondsm/SemicolonDesign_iOS", from: "1.13.2")
    ],
    targets: [
        .target(
            name: "XWebKit",
            dependencies: [
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "SemicolonDesign", package: "SemicolonDesign_iOS")
            ],
            path: "XWebKit"
        )
    ]
)
