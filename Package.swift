// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "SwiftUIMediaDetails",
    platforms: [.iOS(.v26), .tvOS(.v26), .macOS(.v26)],
    products: [.library(name: "SwiftUIMediaDetails", targets: ["SwiftUIMediaDetails"])],
    dependencies: [
        .package(path: "../swiftui-medialists"),
    ],
    targets: [
        .target(
            name: "SwiftUIMediaDetails",
            dependencies: [.product(name: "SwiftUIMediaLists", package: "swiftui-medialists")],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "SwiftUIMediaDetailsTests",
            dependencies: ["SwiftUIMediaDetails"],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
    ]
)
