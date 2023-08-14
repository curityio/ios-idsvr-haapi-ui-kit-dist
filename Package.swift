// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "IdsvrHaapiUIKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "IdsvrHaapiUIKit",
            targets: ["IdsvrHaapiUIKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "IdsvrHaapiUIKit",
            path: "IdsvrHaapiUIKit.xcframework"
        )
    ],
    swiftLanguageVersions: [.v5]
)
