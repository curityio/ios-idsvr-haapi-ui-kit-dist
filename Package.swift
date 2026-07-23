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
        .library(
            name: "IdsvrHaapiUIKitPreviewer",
            targets: ["IdsvrHaapiUIKitPreviewer"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "IdsvrHaapiUIKit",
            path: "IdsvrHaapiUIKit.xcframework"
        ),
        .target(
            name: "IdsvrHaapiUIKitPreviewer",
            dependencies: ["IdsvrHaapiUIKit"],
            path: "HaapiUIPreviewer"
        ),
    ],
    swiftLanguageModes: [.v6]
)
