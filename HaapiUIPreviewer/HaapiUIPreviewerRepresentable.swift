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

/// A generic `UIViewControllerRepresentable` wrapper that bridges UIKit view controllers into SwiftUI
/// for use in Xcode previews. If the builder closure throws, an error placeholder is displayed instead.
/// - Experiment: This is an experimental API. It may be changed or removed in the future.
@available(iOS 14.0, *)
public struct HaapiUIPreviewerRepresentable: UIViewControllerRepresentable {
    private let viewControllerBuilder: @MainActor () throws -> UIViewController

    public init(_ builder: @escaping @MainActor () throws -> UIViewController) {
        self.viewControllerBuilder = builder
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        do {
            return try viewControllerBuilder()
        } catch {
            return Self.makeErrorViewController(error: error)
        }
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private static func makeErrorViewController(error: Error) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "Preview Error:\n\(error.localizedDescription)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false

        viewController.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])

        return viewController
    }
}

#endif
