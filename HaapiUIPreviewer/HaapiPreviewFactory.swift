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

import Foundation
import UIKit
@_spi(HaapiPreview) import IdsvrHaapiUIKit

@available(iOS 14.0, *)
@MainActor
internal enum HaapiPreviewFactory {

    // MARK: - Cached Pipeline Components

    /// Cached DataMapper instance. The DataMapper is stateless and `Sendable` — it only depends on
    /// fixed configuration values, so a single shared instance avoids rebuilding it on every preview refresh.
    private static let sharedDataMapper: any DataMapper = DataMapperBuilder(
        redirectTo: "preview://callback",
        autoPollingDuration: 3.0,
        authSelectionPresentation: .list
    ).build()

    /// Caches decoded `UIModel` results keyed by JSON hash. Representation and problem JSON use
    /// separate caches because the same JSON string goes through different decode pipelines —
    /// sharing a single cache would let a problem-path entry satisfy a representation-path lookup
    /// (or vice versa), bypassing the decode and silently returning the wrong model.
    /// The caches are intentionally unbounded — preview processes are short-lived and the number of
    /// distinct JSON strings is small (one per `#Preview` block).
    private static var representationCache: [Int: UIModel] = [:]
    private static var problemCache: [Int: UIModel] = [:]

    /// The number of entries currently held in the UIModel caches (representation + problem combined).
    /// Exposed for testing cache hit/miss behavior.
    static var uiModelCacheCount: Int { representationCache.count + problemCache.count }

    /// Removes all cached UIModel entries. Call this between tests to ensure isolation.
    static func clearUIModelCache() {
        representationCache.removeAll()
        problemCache.removeAll()
    }

    /// Decodes a HAAPI representation JSON string to a `UIModel`, returning a cached result when available.
    private static func resolveRepresentationUIModel(json: String) throws -> UIModel {
        let hash = json.hashValue
        if let cached = representationCache[hash] {
            return cached
        }
        let data = Data(json.utf8)
        let genericStep = try JSONDecoder().decode(GenericRepresentationStep.self, from: data)
        let representation = try HaapiPreviewConnector.specializedRepresentation(from: genericStep)
        let haapiResult = HaapiResult.representation(representation)
        let uiModel = try sharedDataMapper.mapHaapiResultToUIModel(haapiResult: haapiResult)
        representationCache[hash] = uiModel
        return uiModel
    }

    /// Decodes a HAAPI problem JSON string to a `UIModel`, returning a cached result when available.
    private static func resolveProblemUIModel(json: String) throws -> UIModel {
        let hash = json.hashValue
        if let cached = problemCache[hash] {
            return cached
        }
        let data = Data(json.utf8)
        let decoder = JSONDecoder()

        let problem: any ProblemRepresentation
        if let invalidInput = try? decoder.decode(InvalidInputProblem.self, from: data) {
            problem = invalidInput
        } else if let authProblem = try? decoder.decode(AuthorizationProblem.self, from: data) {
            problem = authProblem
        } else {
            problem = try decoder.decode(Problem.self, from: data)
        }

        let haapiResult = HaapiResult.problem(problem)
        let uiModel = try sharedDataMapper.mapHaapiResultToUIModel(haapiResult: haapiResult)
        problemCache[hash] = uiModel
        return uiModel
    }

    // MARK: - View Controller Creation

    /// Creates a view controller from a HAAPI representation JSON string (authentication-step, polling-step, etc.).
    /// - Parameters:
    ///   - json: The HAAPI JSON string to decode.
    ///   - theme: The plist resource name for theme configuration.
    ///   - bundle: The bundle containing the theme plist.
    ///   - embeddedInFlow: When `true`, wraps the resulting VC inside a lightweight flow container
    ///     that replicates the `HaapiFlowViewController` layout (scroll view, padding, header, background).
    static func createViewController(
        json: String,
        theme: String,
        bundle: Bundle,
        embeddedInFlow: Bool = false
    ) throws -> UIViewController {
        let themeHandle = try loadThemeHandle(theme: theme, bundle: bundle)
        let uiModel = try resolveRepresentationUIModel(json: json)

        let childVC = try resolveViewController(for: uiModel, themeHandle: themeHandle)

        if embeddedInFlow {
            return try wrapInFlowContainer(childViewController: childVC, themeHandle: themeHandle)
        }
        return childVC
    }

    /// Creates a view controller from a HAAPI problem JSON string.
    /// Problem JSON has a different structure (e.g. `"type": "https://curity.se/problems/..."`)
    /// and requires a separate decode path.
    /// - Parameters:
    ///   - json: The HAAPI problem JSON string to decode.
    ///   - theme: The plist resource name for theme configuration.
    ///   - bundle: The bundle containing the theme plist.
    ///   - embeddedInFlow: When `true`, wraps the resulting VC inside a lightweight flow container
    ///     that replicates the `HaapiFlowViewController` layout (scroll view, padding, header, background).
    static func createProblemViewController(
        json: String,
        theme: String,
        bundle: Bundle,
        embeddedInFlow: Bool = false
    ) throws -> UIViewController {
        let themeHandle = try loadThemeHandle(theme: theme, bundle: bundle)
        let uiModel = try resolveProblemUIModel(json: json)

        let childVC = try resolveViewController(for: uiModel, themeHandle: themeHandle)

        if embeddedInFlow {
            return try wrapInFlowContainer(childViewController: childVC, themeHandle: themeHandle)
        }
        return childVC
    }

    /// Loads styles from the theme without creating a view controller.
    static func loadThemeHandle(theme: String, bundle: Bundle) throws -> HaapiPreviewThemeHandle {
        let resolvedBundle = try Self.resolveBundle(for: theme, preferred: bundle)
        return try HaapiPreviewConnector.makeThemeHandle(theme: theme, bundle: resolvedBundle)
    }

    /// In Xcode preview context, `Bundle.main` points to the preview host process — not the app bundle.
    /// This method checks if the preferred bundle contains the theme plist. If not, it searches all loaded
    /// bundles to find the one that does. If no match is found, and error is thrown.
    private static func resolveBundle(for theme: String, preferred: Bundle) throws -> Bundle {
        if preferred.url(forResource: theme, withExtension: "plist") != nil {
            return preferred
        }
        // Bundle.allBundles excludes framework bundles; Bundle.allFrameworks covers .framework bundles
        // (e.g. IdsvrHaapiUIKit.framework/Theme.plist). Search both so the fallback works in all contexts.
        for candidate in Bundle.allBundles + Bundle.allFrameworks
            where candidate.url(forResource: theme, withExtension: "plist") != nil {
            return candidate
        }
        throw HaapiUIKitError.illegalState("\(theme).plist not found in preferred or any other bundle")
    }

    // MARK: - Diagnostics

    /// Collects diagnostic information about theme resolution without creating a view controller.
    /// Used by the diagnostic overlay to display bundle/theme resolution details in the preview canvas.
    static func collectDiagnostics(theme: String, bundle: Bundle) -> HaapiPreviewDiagnosticInfo {
        let themeInPreferred = bundle.url(forResource: theme, withExtension: "plist")
        do {
            let resolvedBundle = try resolveBundle(for: theme, preferred: bundle)
            let plistURL = resolvedBundle.url(forResource: theme, withExtension: "plist")

            var error: String?
            if themeInPreferred == nil {
                error = "Not found in preferred bundle; resolved via Bundle.allBundles + Bundle.allFrameworks search"
            }

            return HaapiPreviewDiagnosticInfo(
                themeName: theme,
                preferredBundlePath: bundle.bundlePath,
                preferredBundleIdentifier: bundle.bundleIdentifier,
                resolvedBundlePath: resolvedBundle.bundlePath,
                resolvedBundleIdentifier: resolvedBundle.bundleIdentifier,
                themeFoundInPreferredBundle: themeInPreferred != nil,
                plistURL: plistURL,
                error: error
            )
        } catch {
            return HaapiPreviewDiagnosticInfo(
                themeName: theme,
                preferredBundlePath: bundle.bundlePath,
                preferredBundleIdentifier: bundle.bundleIdentifier,
                resolvedBundlePath: "N/A",
                resolvedBundleIdentifier: nil,
                themeFoundInPreferredBundle: themeInPreferred != nil,
                plistURL: nil,
                error: "'\(theme).plist' not found in preferred bundle or any loaded bundle"
            )
        }
    }

    // MARK: - Flow Container

    /// Wraps a child view controller inside a lightweight flow container that
    /// replicates the visual layout of `HaapiFlowViewController` (scroll view, padding, header, background).
    static func wrapInFlowContainer(
        childViewController: UIViewController,
        themeHandle: HaapiPreviewThemeHandle
    ) throws -> UIViewController {
        try HaapiPreviewConnector.makeFlowContainer(
            wrapping: childViewController,
            themeHandle: themeHandle
        )
    }

    // MARK: - Private

    private static func resolveViewController(
        for uiModel: UIModel,
        themeHandle: HaapiPreviewThemeHandle
    ) throws -> UIViewController {
        let commonStyle = themeHandle.commonStyle
        let viewController: UIViewController

        switch uiModel {
        case let formModel as FormModel:
            let style: FormViewControllerStyle = try themeHandle.style(
                stylableType: FormViewController.self
            )
            let ctrl = FormViewController(formModel, style: style, commonStyle: commonStyle)
            ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
            viewController = ctrl

        case let selectorModel as SelectorModel:
            let style: SelectorViewControllerStyle = try themeHandle.style(
                stylableType: SelectorViewController.self
            )
            let ctrl = SelectorViewController(selectorModel, style: style, commonStyle: commonStyle)
            ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
            viewController = ctrl
            
        case let pollingOperationModel as (any PollingOperationModel):
            if let bankIdModel = pollingOperationModel.interactionModel as? BankIdModel {
                let style: BankIdViewControllerStyle = try themeHandle.style(
                    stylableType: BankIdViewController.self
                )
                let ctrl = BankIdViewController(bankIdModel, style: style, commonStyle: commonStyle)
                ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
                viewController = ctrl
            } else if let pollingModel = pollingOperationModel.interactionModel {
                let style: PollingViewControllerStyle = try themeHandle.style(
                    stylableType: PollingViewController.self
                )
                let ctrl = PollingViewController(pollingModel, style: style, commonStyle: commonStyle)
                ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
                viewController = ctrl
            } else {
                throw HaapiUIKitError.illegalState(
                    "PollingOperationModel interactionModel is nil, cannot resolve ViewController"
                )
            }

        case let bankIdModel as BankIdModel:
            let style: BankIdViewControllerStyle = try themeHandle.style(
                stylableType: BankIdViewController.self
            )
            let ctrl = BankIdViewController(bankIdModel, style: style, commonStyle: commonStyle)
            ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
            viewController = ctrl

        case let pollingModel as PollingModel:
            let style: PollingViewControllerStyle = try themeHandle.style(
                stylableType: PollingViewController.self
            )
            let ctrl = PollingViewController(pollingModel, style: style, commonStyle: commonStyle)
            ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
            viewController = ctrl

        case let problemModel as ProblemModel:
            let style: ProblemViewControllerStyle = try themeHandle.style(
                stylableType: ProblemViewController.self
            )
            let ctrl = ProblemViewController(problemModel, style: style, commonStyle: commonStyle)
            ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
            viewController = ctrl

        case let genericModel as GenericModel:
            let style: GenericViewControllerStyle = try themeHandle.style(
                stylableType: GenericViewController.self
            )
            let ctrl = GenericViewController(genericModel, style: style, commonStyle: commonStyle)
            ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
            HaapiPreviewConnector.bindFlowResolver(on: ctrl, themeHandle: themeHandle)
            viewController = ctrl

        case let webAuthnModel as (any WebAuthnOperationModel):
            let style: WebAuthnViewControllerStyle = try themeHandle.style(
                stylableType: WebAuthnViewController.self
            )
            let ctrl = WebAuthnViewController(webAuthnModel, style: style, commonStyle: commonStyle)
            ctrl.uiStylableThemeDelegate = themeHandle.themeDelegate
            // Replace the real engine with a preview-safe wrapper that prevents credential
            // ceremonies (ASAuthorizationController) from being invoked in the preview context.
            HaapiPreviewConnector.installPreviewSafeWebAuthnEngine(on: ctrl)
            viewController = ctrl

        default:
            throw HaapiUIKitError.illegalState(
                "Cannot resolve a preview ViewController for UIModel: \(type(of: uiModel))"
            )
        }

        return viewController
    }
}

#endif
