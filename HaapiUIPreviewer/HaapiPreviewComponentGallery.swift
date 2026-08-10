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

import UIKit

// MARK: - Gallery View Controller

/// A generic scrollable view controller that presents a labeled list of UI component instances.
///
/// Each item is rendered as a monospaced label (the variant name) followed by the component view.
/// Used by `HaapiPreviewFactory` to build per-component gallery previews showing all style variants
/// side by side in the Xcode canvas.
@available(iOS 14.0, *)
@MainActor
final class HaapiComponentGalleryViewController: UIViewController {

    struct Item {
        let label: String
        let view: UIView
    }

    // Number of items — exposed for testing structural assertions.
    var itemCount: Int { items.count }

    private let items: [Item]

    init(items: [Item]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(items:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    // MARK: - Private

    private func setupLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        for (index, item) in items.enumerated() {
            if index > 0 {
                stack.addArrangedSubview(makeSeparator())
            }
            stack.addArrangedSubview(makeLabel(item.label))
            item.view.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(item.view)
        }
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text.uppercased()
        label.font = UIFont.monospacedSystemFont(ofSize: 10, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }

    private func makeSeparator() -> UIView {
        let sep = UIView()
        sep.backgroundColor = .separator
        sep.translatesAutoresizingMaskIntoConstraints = false
        sep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return sep
    }
}

// MARK: - Gallery Sample Content

/// Sample text used to populate component instances in the gallery view.
/// Values are illustrative — they match what a typical HAAPI login flow would display.
@available(iOS 14.0, *)
internal enum HaapiPreviewGalleryDefaults {
    
    // MARK: ActionableButton
    static let buttonPrimaryTitle = "Sign In"
    static let buttonSecondaryTitle = "Cancel"
    static let buttonTextTitle = "Forgot password?"
    static let buttonLinkTitle = "Learn more"
    
    // MARK: MessageView
    static let messageError = "Invalid username or password."
    static let messageWarn = "Your session will expire soon."
    static let messageInfo = "A verification code was sent to your email."
    static let messageRecipient = "xxxxxx@example.com"
    static let messageContent = "Please complete the steps below to sign in."
    static let messageHeading = "Sign in to continue"
    static let messageUsername = "john.doe@example.com"
    static let messageUserCodes: [String] = ["A1B2-C3D4", "E5F6-G7H8", "J9K0-L1M2"]
    
    // MARK: InputTextField
    static let inputLabel = "Username"
    static let inputPlaceholder = "Enter your username"
    static let inputError = "Input error message"
    
    // MARK: CheckboxView
    static let checkboxLabel = "Remember me on this device"
    
    // MARK: LinkView
    static let linkText = "Forgot your password?"
    
    // MARK: NotificationBannerView
    static let bannerTitle = "Resend code in 30 seconds"
    static let bannerSuccessTitle = "Authentication successful"
    static let bannerActionTitle = "OK"
    
    // MARK: ExpandableView
    static let expandableTitle = "More sign-in options"
    static let expandableContent = "You can also sign in using your work email address or a registered passkey."
    
    // MARK: HeaderView — title comes from the style's titleText; no external sample needed.
    // MARK: LoadingIndicatorView — no text content.
    
    /// Fixed height for LoadingIndicatorView instances in the gallery.
    /// The component's intrinsicContentSize is zero before layout; an explicit constraint is required.
    static let loadingIndicatorSize: CGFloat = 40
}

#endif
