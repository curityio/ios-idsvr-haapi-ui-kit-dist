//
// Copyright (C) 2026 Curity AB. All rights reserved.
//
// The contents of this file are the property of Curity AB.
// You may not copy or use this file, in either source code
// or executable form, except in compliance with terms
// set by Curity AB.
//
// For further information, please contact Curity AB.
//

#if DEBUG

import SwiftUI
@_spi(HaapiPreview) import IdsvrHaapiUIKit

/// Describes which WebAuthn visual layout to preview.
///
/// Each case maps to a different default JSON fixture that exercises a distinct screen layout
/// of `WebAuthnViewController`.
/// - Experiment: This is an experimental API. It may be changed or removed in the future.
@available(iOS 14.0, *)
public enum HaapiUIPreviewerWebAuthnVariant {
    /// Options screen showing platform and cross-platform credential buttons (registration flow).
    case registration
    /// Options screen showing platform and cross-platform credential buttons (authentication flow).
    case authentication
    /// Additional device registration prompt: info message, Yes, No not now, and Don't ask again buttons.
    case additionalRegistration
    /// Platform-only registration with simulated timeout: shows the retry info message
    /// and a single platform credential button, as the user would see after a credential ceremony times out.
    case platformOnly

    /// The default JSON fixture for this variant.
    internal var defaultJSON: String {
        switch self {
        case .registration:
            return HaapiPreviewDefaults.webAuthnRegistrationJSON
        case .authentication:
            return HaapiPreviewDefaults.webAuthnAuthenticationJSON
        case .additionalRegistration:
            return HaapiPreviewDefaults.webAuthnAdditionalRegistrationJSON
        case .platformOnly:
            return HaapiPreviewDefaults.webAuthnPlatformOnlyJSON
        }
    }
}

/// A utility providing factory methods to create themed HAAPI view controllers for use in Xcode SwiftUI previews.
///
/// Each method returns a SwiftUI `View` wrapping the corresponding UIKit view controller, making it easy
/// to preview HAAPI UI screens in the Xcode canvas without running the full application.
///
/// All non-gallery methods accept an optional `json` parameter. When `nil` (the default), a bundled default
/// JSON fixture is used. Pass a custom JSON string to preview a specific HAAPI representation.
/// Set `embeddedInFlow` to `true` to wrap the view controller in a container that replicates the
/// `HaapiFlowViewController` layout (scroll view, padding, header, background).
///
/// **Example usage:**
/// ```swift
/// #Preview("Login Form") {
///     try! HaapiUIPreviewer.formViewController(theme: "MyCustomTheme")
/// }
/// ```
/// - Experiment: This is an experimental API. It may be changed or removed in the future.
@available(iOS 14.0, *)
@MainActor
public enum HaapiUIPreviewer {
    // MARK: - Form

    /// Creates a `FormViewController` preview from a HAAPI authentication-step JSON.
    /// - Parameters:
    ///   - json: HAAPI JSON representation. Pass `nil` to use the bundled default login-form fixture.
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - embeddedInFlow: When `true`, wraps the VC inside a container that replicates the
    ///     `HaapiFlowViewController` layout (scroll view, padding, header, background). Defaults to `false`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    /// - Returns: A SwiftUI view wrapping the `FormViewController`.
    public static func formViewController(
        json: String? = nil,
        theme: String = "Theme",
        bundle: Bundle = .main,
        embeddedInFlow: Bool = false,
        showDiagnostics: Bool = false
    ) throws -> some View {
        let resolvedJSON = json ?? HaapiPreviewDefaults.formJSON
        return makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createViewController(
                json: resolvedJSON, theme: theme, bundle: bundle, embeddedInFlow: embeddedInFlow)
        }
    }

    // MARK: - Selector

    /// Creates a `SelectorViewController` preview from a HAAPI authentication-step JSON.
    /// - Parameters:
    ///   - json: HAAPI JSON representation. Pass `nil` to use the bundled default selector fixture.
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - embeddedInFlow: When `true`, wraps the VC inside a container that replicates the
    ///     `HaapiFlowViewController` layout (scroll view, padding, header, background). Defaults to `false`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    /// - Returns: A SwiftUI view wrapping the `SelectorViewController`.
    public static func selectorViewController(
        json: String? = nil,
        theme: String = "Theme",
        bundle: Bundle = .main,
        embeddedInFlow: Bool = false,
        showDiagnostics: Bool = false
    ) throws -> some View {
        let resolvedJSON = json ?? HaapiPreviewDefaults.selectorJSON
        return makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createViewController(
                json: resolvedJSON, theme: theme, bundle: bundle, embeddedInFlow: embeddedInFlow)
        }
    }

    // MARK: - Problem

    /// Creates a `ProblemViewController` preview from a HAAPI problem JSON.
    /// - Parameters:
    ///   - json: HAAPI problem JSON representation. Pass `nil` to use the bundled default problem fixture.
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - embeddedInFlow: When `true`, wraps the VC inside a container that replicates the
    ///     `HaapiFlowViewController` layout (scroll view, padding, header, background). Defaults to `false`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    /// - Returns: A SwiftUI view wrapping the `ProblemViewController`.
    public static func problemViewController(
        json: String? = nil,
        theme: String = "Theme",
        bundle: Bundle = .main,
        embeddedInFlow: Bool = false,
        showDiagnostics: Bool = false
    ) throws -> some View {
        let resolvedJSON = json ?? HaapiPreviewDefaults.problemJSON
        return makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createProblemViewController(
                json: resolvedJSON, theme: theme, bundle: bundle, embeddedInFlow: embeddedInFlow)
        }
    }

    // MARK: - Polling

    /// Creates a `PollingViewController` preview from a HAAPI polling-step JSON.
    /// - Parameters:
    ///   - json: HAAPI JSON representation. Pass `nil` to use the bundled default polling fixture.
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - embeddedInFlow: When `true`, wraps the VC inside a container that replicates the
    ///     `HaapiFlowViewController` layout (scroll view, padding, header, background). Defaults to `false`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    /// - Returns: A SwiftUI view wrapping the `PollingViewController`.
    public static func pollingViewController(
        json: String? = nil,
        theme: String = "Theme",
        bundle: Bundle = .main,
        embeddedInFlow: Bool = false,
        showDiagnostics: Bool = false
    ) throws -> some View {
        let resolvedJSON = json ?? HaapiPreviewDefaults.pollingJSON
        return makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createViewController(
                json: resolvedJSON, theme: theme, bundle: bundle, embeddedInFlow: embeddedInFlow)
        }
    }

    // MARK: - BankId

    /// Creates a `BankIdViewController` preview from a HAAPI polling-step JSON with BankID metadata.
    /// - Parameters:
    ///   - json: HAAPI JSON representation. Pass `nil` to use the bundled default BankID fixture.
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - embeddedInFlow: When `true`, wraps the VC inside a container that replicates the
    ///     `HaapiFlowViewController` layout (scroll view, padding, header, background). Defaults to `false`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    /// - Returns: A SwiftUI view wrapping the `BankIdViewController`.
    public static func bankIdViewController(
        json: String? = nil,
        theme: String = "Theme",
        bundle: Bundle = .main,
        embeddedInFlow: Bool = false,
        showDiagnostics: Bool = false
    ) throws -> some View {
        let resolvedJSON = json ?? HaapiPreviewDefaults.bankIdJSON
        return makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createViewController(
                json: resolvedJSON, theme: theme, bundle: bundle, embeddedInFlow: embeddedInFlow)
        }
    }

    // MARK: - Generic

    /// Creates a `GenericViewController` preview from a HAAPI authentication-step JSON.
    /// - Parameters:
    ///   - json: HAAPI JSON representation. Pass `nil` to use the bundled default generic fixture.
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - embeddedInFlow: When `true`, wraps the VC inside a container that replicates the
    ///     `HaapiFlowViewController` layout (scroll view, padding, header, background). Defaults to `false`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    /// - Returns: A SwiftUI view wrapping the `GenericViewController`.
    public static func genericViewController(
        json: String? = nil,
        theme: String = "Theme",
        bundle: Bundle = .main,
        embeddedInFlow: Bool = false,
        showDiagnostics: Bool = false
    ) throws -> some View {
        let resolvedJSON = json ?? HaapiPreviewDefaults.genericJSON
        return makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createViewController(
                json: resolvedJSON, theme: theme, bundle: bundle, embeddedInFlow: embeddedInFlow)
        }
    }

    // MARK: - WebAuthn

    /// Creates a `WebAuthnViewController` preview from a HAAPI WebAuthn JSON.
    ///
    /// Use the `variant` parameter to choose which visual layout to preview.
    /// When `json` is provided, the `variant` parameter is ignored and the custom JSON is used instead.
    ///
    /// - Parameters:
    ///   - variant: The WebAuthn visual layout to preview. Defaults to `.registration`.
    ///   - json: HAAPI JSON representation. Pass `nil` to use the default fixture for the chosen `variant`.
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - embeddedInFlow: When `true`, wraps the VC inside a container that replicates the
    ///     `HaapiFlowViewController` layout (scroll view, padding, header, background). Defaults to `false`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    /// - Returns: A SwiftUI view wrapping the `WebAuthnViewController`.
    public static func webAuthnViewController(
        variant: HaapiUIPreviewerWebAuthnVariant = .registration,
        json: String? = nil,
        theme: String = "Theme",
        bundle: Bundle = .main,
        embeddedInFlow: Bool = false,
        showDiagnostics: Bool = false
    ) throws -> some View {
        let resolvedJSON = json ?? variant.defaultJSON
        return makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createViewController(
                json: resolvedJSON, theme: theme, bundle: bundle, embeddedInFlow: embeddedInFlow)
        }
    }

    // MARK: - Component Galleries

    /// Creates a gallery showing all `ActionableButton` style variants (Primary, Secondary, Text, Link).
    ///
    /// Use this preview to verify button colors, border radii, typography, and minimum heights
    /// across all four button variants defined in your `Theme.plist`.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func actionableButtonGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createActionableButtonGallery(theme: theme, bundle: bundle)
        }
    }

    /// Creates a gallery showing all `MessageView` style variants
    /// (Error, Warn, Info, RecipientOfCommunication, Content, Heading, Username, UserCode).
    ///
    /// Use this preview to verify message colors, icons, borders, and text appearance
    /// across all eight message variants defined in your `Theme.plist`.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func messageViewGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createMessageViewGallery(theme: theme, bundle: bundle)
        }
    }

    /// Creates a gallery showing the three `InputTextField` UIKit implementations
    /// (Curity, Filled, Outlined) rendered with the active theme's input text field style.
    ///
    /// Use this preview to compare how your custom `InputTextField` style looks across all three
    /// built-in text field variants before choosing which one your app will use.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func inputTextFieldGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createInputTextFieldGallery(theme: theme, bundle: bundle)
        }
    }

    /// Creates a gallery showing `HeaderView` with the active theme style.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func headerViewGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createHeaderViewGallery(theme: theme, bundle: bundle)
        }
    }

    /// Creates a gallery showing `CheckboxView` in unchecked and checked states.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func checkboxViewGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createCheckboxViewGallery(theme: theme, bundle: bundle)
        }
    }

    /// Creates a gallery showing `LoadingIndicatorView` with the active theme style.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func loadingIndicatorGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createLoadingIndicatorGallery(theme: theme, bundle: bundle)
        }
    }

    /// Creates a gallery showing `LinkView` with the active theme style.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func linkViewGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createLinkViewGallery(theme: theme, bundle: bundle)
        }
    }

    /// Creates a gallery showing `NotificationBannerView` with the active theme style.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func notificationBannerGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createNotificationBannerGallery(theme: theme, bundle: bundle)
        }
    }

    /// Creates a gallery showing `ExpandableView` in its default collapsed state.
    /// Tap the component in the preview canvas to toggle expand/collapse.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    ///   - showDiagnostics: When `true`, overlays theme resolution diagnostics on the preview. Defaults to `false`.
    public static func expandableViewGallery(
        theme: String = "Theme",
        bundle: Bundle = .main,
        showDiagnostics: Bool = false
    ) throws -> some View {
        makePreview(theme: theme, bundle: bundle, showDiagnostics: showDiagnostics) {
            try HaapiPreviewFactory.createExpandableViewGallery(theme: theme, bundle: bundle)
        }
    }

    // MARK: - Style Provider

    /// Returns a style provider for developers who have custom VC subclasses
    /// and need access to resolved styles for preview.
    /// - Parameters:
    ///   - theme: The plist resource name for theme configuration. Defaults to `"Theme"`.
    ///   - bundle: The bundle containing the theme plist. Defaults to `.main`.
    /// - Returns: A `HaapiUIPreviewerStyleProvider` with resolved styles from the theme.
    public static func loadStyles(
        theme: String = "Theme",
        bundle: Bundle = .main
    ) throws -> HaapiUIPreviewerStyleProvider {
        let themeHandle = try HaapiPreviewFactory.loadThemeHandle(theme: theme, bundle: bundle)
        return HaapiUIPreviewerStyleProvider(themeHandle: themeHandle)
    }
    
    // MARK: - Private Helper

    /// Wraps a VC factory closure in the standard diagnostics + representable boilerplate.
    private static func makePreview(
        theme: String,
        bundle: Bundle,
        showDiagnostics: Bool,
        factory: @escaping @Sendable @MainActor () throws -> UIViewController
    ) -> some View {
        let diagnostics = showDiagnostics
            ? HaapiPreviewFactory.collectDiagnostics(theme: theme, bundle: bundle) : nil
        if showDiagnostics { HaapiPreviewLogCollector.install() }
        return HaapiPreviewDiagnosticWrapper(diagnostics: diagnostics) {
            HaapiUIPreviewerRepresentable(factory)
        }
    }
}

/// Provides access to resolved theme styles for use in custom view controller previews.
///
/// Use this when you have a custom `HaapiUIViewController` subclass and need to pass themed styles
/// to its constructor in a preview context.
///
/// **Example usage:**
/// ```swift
/// #Preview("Custom Login VC") {
///     let styles = try! HaapiUIPreviewer.loadStyles(theme: "MyTheme")
///     HaapiUIPreviewerRepresentable {
///         let vc = MyCustomLoginViewController(
///             myModel,
///             style: try styles.formStyle,
///             commonStyle: styles.commonStyle
///         )
///         vc.uiStylableThemeDelegate = styles.themeDelegate
///         return vc
///     }
/// }
/// ```
/// - Experiment: This is an experimental API. It may be changed or removed in the future.
@available(iOS 14.0, *)
@MainActor
public struct HaapiUIPreviewerStyleProvider {
    internal let themeHandle: HaapiPreviewThemeHandle

    /// The common style shared across all view controllers.
    public var commonStyle: HaapiUIViewControllerStyle {
        themeHandle.commonStyle
    }

    /// The style for `FormViewController`.
    public var formStyle: FormViewControllerStyle {
        get throws {
            try themeHandle.style(stylableType: FormViewController.self)
        }
    }

    /// The style for `SelectorViewController`.
    public var selectorStyle: SelectorViewControllerStyle {
        get throws {
            try themeHandle.style(stylableType: SelectorViewController.self)
        }
    }

    /// The style for `PollingViewController`.
    public var pollingStyle: PollingViewControllerStyle {
        get throws {
            try themeHandle.style(stylableType: PollingViewController.self)
        }
    }

    /// The style for `ProblemViewController`.
    public var problemStyle: ProblemViewControllerStyle {
        get throws {
            try themeHandle.style(stylableType: ProblemViewController.self)
        }
    }

    /// The style for `BankIdViewController`.
    public var bankIdStyle: BankIdViewControllerStyle {
        get throws {
            try themeHandle.style(stylableType: BankIdViewController.self)
        }
    }

    /// The style for `HaapiFlowViewController`.
    public var flowStyle: HaapiFlowViewControllerStyle {
        get throws {
            try themeHandle.style(stylableType: HaapiFlowViewController.self)
        }
    }

    /// The style for `GenericViewController`.
    public var genericStyle: GenericViewControllerStyle {
        get throws {
            try themeHandle.style(stylableType: GenericViewController.self)
        }
    }

    /// The style for `WebAuthnViewController`.
    public var webAuthnStyle: WebAuthnViewControllerStyle {
        get throws {
            try themeHandle.style(stylableType: WebAuthnViewController.self)
        }
    }

    /// The theme delegate to assign to view controllers for dynamic theming.
    public var themeDelegate: UIStylableThemeDelegate {
        themeHandle.themeDelegate
    }
}

#endif
