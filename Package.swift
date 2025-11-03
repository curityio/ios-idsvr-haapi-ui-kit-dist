// swift-tools-version: 6.2

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
    swiftLanguageModes: [.v6]
)
