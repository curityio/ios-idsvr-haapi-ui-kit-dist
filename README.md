# IdsvrHaapiUIKit

[![Quality](https://img.shields.io/badge/quality-production-green)](https://curity.io/resources/code-examples/status/)
[![Availability](https://img.shields.io/badge/availability-binary-blue)](https://curity.io/resources/code-examples/status/)

This distribution provides the iOS Hypermedia Authentication API (HAAPI) UI KIT for the Curity Identity Server. This SDK allows iOS developers to integrate this API into their applications for smarter, simpler login using native UI widgets. It allows for any login method supported by the Curity Identity Server, and strictly follows the principle of REST. The SDK is meant to make the security aspects of consuming this API easier.

For information about the license of this software, refer to [legal.md](legal.md).

## Installation

### CocoaPods

To integrate IdsvrHaapiUIKit into your Xcode project, include it in your `Podfile`:

``` ruby
platform :ios, '14.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'IdsvrHaapiUIKit'
end
```

Then install it by running `pod install`. More documentation on using CocoaPods is found [here](https://cocoapods.org).

### Swift Package Manager

To integrate IdsvrHaapiUIKit using Swift Package Manager include the following dependency in your `Package.swift` file:

``` swift
.package(url: "https://github.com/curityio/ios-idsvr-haapi-ui-kit-dist")
```

## HaapiUI Previewer (experimental)

The HaapiUI Previewer renders themed HAAPI screens and component galleries in Xcode Previews, so you
can iterate on your `Theme.plist` without running a full authentication flow. It ships as Swift
source (the `HaapiUIPreviewer/` folder in this repository) that your own project compiles: your
**Debug** builds get the previewer, and your **Release** builds compile it to an empty module — no
previewer code ever ships in your app. Wrap all previewer usage in `#if DEBUG`.

### Swift Package Manager

Declare **both** products on your app target — the SDK and the previewer:

``` swift
.product(name: "IdsvrHaapiUIKit", package: "ios-idsvr-haapi-ui-kit-dist"),
.product(name: "IdsvrHaapiUIKitPreviewer", package: "ios-idsvr-haapi-ui-kit-dist"),
```

Declaring only `IdsvrHaapiUIKitPreviewer` also works (it depends on the SDK), but declaring both is
the recommended, explicit form.

### CocoaPods

``` ruby
pod 'IdsvrHaapiUIKit'
pod 'IdsvrHaapiUIKitPreviewer'
```

The previewer pod is pinned to the exact SDK version it shipped with. Do **not** scope the pods to
specific build configurations (`:configurations => ['Debug']`) — the previewer is already empty in
Release builds, and configuration scoping can break your Release link.

### Manual integration

Copy the `HaapiUIPreviewer/` folder from this repository into your app target, next to the manually
embedded `IdsvrHaapiUIKit.xcframework`. Always copy the folder from the same release tag as the
framework.

See the developer documentation for the full previewer API (screen previews, component galleries,
WebAuthn variants, flow-container embedding, custom JSON, and diagnostics).
