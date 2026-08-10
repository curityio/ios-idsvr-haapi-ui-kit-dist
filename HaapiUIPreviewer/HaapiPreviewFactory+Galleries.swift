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

// MARK: - Component Galleries

@available(iOS 14.0, *)
extension HaapiPreviewFactory {

    /// Creates a gallery showing all `ActionableButton` style variants (Primary, Secondary, Text, Link).
    static func createActionableButtonGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)
        let items: [HaapiComponentGalleryViewController.Item] = [
            .init(label: "Primary",
                  view: HaapiPreviewConnector.makeActionableButton(
                    themeHandle: handle, variant: .primary,
                    title: HaapiPreviewGalleryDefaults.buttonPrimaryTitle)),
            .init(label: "Secondary",
                  view: HaapiPreviewConnector.makeActionableButton(
                    themeHandle: handle, variant: .secondary,
                    title: HaapiPreviewGalleryDefaults.buttonSecondaryTitle)),
            .init(label: "Text",
                  view: HaapiPreviewConnector.makeActionableButton(
                    themeHandle: handle, variant: .text,
                    title: HaapiPreviewGalleryDefaults.buttonTextTitle)),
            .init(label: "Link",
                  view: HaapiPreviewConnector.makeActionableButton(
                    themeHandle: handle, variant: .link,
                    title: HaapiPreviewGalleryDefaults.buttonLinkTitle))
        ]
        return HaapiComponentGalleryViewController(items: items)
    }

    /// Creates a gallery showing all `MessageView` style variants
    /// (Error, Warn, Info, RecipientOfCommunication, Content, Heading, Username, UserCode).
    static func createMessageViewGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)
        let textVariants: [(String, HaapiPreviewConnector.MessageVariant, String)] = [
            ("Error", .error, HaapiPreviewGalleryDefaults.messageError),
            ("Warn", .warn, HaapiPreviewGalleryDefaults.messageWarn),
            ("Info", .info, HaapiPreviewGalleryDefaults.messageInfo),
            ("RecipientOfCommunication", .recipientOfCommunication, HaapiPreviewGalleryDefaults.messageRecipient),
            ("Content", .content, HaapiPreviewGalleryDefaults.messageContent),
            ("Heading", .heading, HaapiPreviewGalleryDefaults.messageHeading),
            ("Username", .username, HaapiPreviewGalleryDefaults.messageUsername)
        ]
        var items: [HaapiComponentGalleryViewController.Item] = textVariants.map { label, variant, text in
            .init(label: label,
                  view: HaapiPreviewConnector.makeMessageView(themeHandle: handle, variant: variant, text: text))
        }
        items.append(.init(label: "UserCode",
                           view: HaapiPreviewConnector.makeUserCodeMessageView(
                            themeHandle: handle,
                            codes: HaapiPreviewGalleryDefaults.messageUserCodes)))
        return HaapiComponentGalleryViewController(items: items)
    }

    /// Creates a gallery showing the three `InputTextField` UIKit implementations for error and non-error states
    /// (Curity, Filled, Outlined), each rendered with its own variant-specific style from the theme.
    static func createInputTextFieldGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)

        let variants: [(name: String, variant: HaapiPreviewConnector.InputTextFieldVariant)] = [
            ("Curity", .curity),
            ("Filled", .filled),
            ("Outlined", .outlined)
        ]

        let items: [HaapiComponentGalleryViewController.Item] = try variants.flatMap { entry in
            let normal = try HaapiPreviewConnector.makeInputTextField(
                themeHandle: handle, variant: entry.variant,
                label: HaapiPreviewGalleryDefaults.inputLabel,
                placeholder: HaapiPreviewGalleryDefaults.inputPlaceholder,
                errorText: nil)
            let error = try HaapiPreviewConnector.makeInputTextField(
                themeHandle: handle, variant: entry.variant,
                label: HaapiPreviewGalleryDefaults.inputLabel,
                placeholder: HaapiPreviewGalleryDefaults.inputPlaceholder,
                errorText: HaapiPreviewGalleryDefaults.inputError)
            return [
                HaapiComponentGalleryViewController.Item(
                    label: "\(entry.name) (InputTextField.\(entry.name))", view: normal),
                HaapiComponentGalleryViewController.Item(
                    label: "\(entry.name) (InputTextField.\(entry.name)) - Error State", view: error)
            ]
        }
        return HaapiComponentGalleryViewController(items: items)
    }

    /// Creates a gallery showing `HeaderView` with the active theme style.
    /// The title is sourced from the style's `titleText`; if not set in the theme, the header renders
    /// without a title (showing background, border, and spacing attributes).
    static func createHeaderViewGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)
        let header = HaapiPreviewConnector.makeHeaderView(themeHandle: handle)
        return HaapiComponentGalleryViewController(items: [.init(label: "Default", view: header)])
    }

    /// Creates a gallery showing `CheckboxView` in unchecked and checked states.
    static func createCheckboxViewGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)

        let items: [HaapiComponentGalleryViewController.Item] = [
            .init(label: "Unchecked",
                  view: HaapiPreviewConnector.makeCheckboxView(
                    themeHandle: handle, title: HaapiPreviewGalleryDefaults.checkboxLabel, isChecked: false)),
            .init(label: "Checked",
                  view: HaapiPreviewConnector.makeCheckboxView(
                    themeHandle: handle, title: HaapiPreviewGalleryDefaults.checkboxLabel, isChecked: true))
        ]
        return HaapiComponentGalleryViewController(items: items)
    }

    /// Creates a gallery showing `LoadingIndicatorView` with the active theme style.
    static func createLoadingIndicatorGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)
        let indicator = HaapiPreviewConnector.makeLoadingIndicator(themeHandle: handle)
        // intrinsicContentSize is zero before layout — explicit size constraints required.
        let size = HaapiPreviewGalleryDefaults.loadingIndicatorSize
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: size).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: size).isActive = true
        // Wrap in a container so the stack view's .fill alignment doesn't stretch the indicator.
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            indicator.topAnchor.constraint(equalTo: container.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return HaapiComponentGalleryViewController(items: [.init(label: "Default", view: container)])
    }

    /// Creates a gallery showing `LinkView` with the active theme style.
    static func createLinkViewGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)
        let link = HaapiPreviewConnector.makeLinkView(
            themeHandle: handle, text: HaapiPreviewGalleryDefaults.linkText)
        return HaapiComponentGalleryViewController(items: [.init(label: "Default", view: link)])
    }

    /// Creates a gallery showing `NotificationBannerView` in Default and Success style variants.
    /// The banner is normally animated into view via `show()` and starts invisible (`alpha = 0`);
    /// the factory makes it visible immediately so it renders statically in the preview canvas.
    static func createNotificationBannerGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)

        let defaultBanner = try HaapiPreviewConnector.makeNotificationBanner(
            themeHandle: handle, variant: .standard,
            title: HaapiPreviewGalleryDefaults.bannerTitle,
            actionTitle: HaapiPreviewGalleryDefaults.bannerActionTitle)
        let successBanner = try HaapiPreviewConnector.makeNotificationBanner(
            themeHandle: handle, variant: .success,
            title: HaapiPreviewGalleryDefaults.bannerSuccessTitle,
            actionTitle: nil)

        return HaapiComponentGalleryViewController(items: [
            .init(label: "Default", view: defaultBanner),
            .init(label: "Success", view: successBanner)
        ])
    }

    /// Creates a gallery showing `ExpandableView` in its default (collapsed) state.
    /// The component responds to user tap for expand/collapse — tap it in the preview canvas
    /// to see both states.
    static func createExpandableViewGallery(theme: String, bundle: Bundle) throws -> UIViewController {
        let handle = try loadThemeHandle(theme: theme, bundle: bundle)
        let view = try HaapiPreviewConnector.makeExpandableView(
            themeHandle: handle,
            title: HaapiPreviewGalleryDefaults.expandableTitle,
            content: HaapiPreviewGalleryDefaults.expandableContent)
        return HaapiComponentGalleryViewController(items: [.init(label: "Default (tap to expand)", view: view)])
    }
}

#endif
