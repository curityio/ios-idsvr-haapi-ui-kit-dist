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
import IdsvrHaapiUIKit

// MARK: - Log Collector

/// Captures `HaapiLogger` log messages for display in the diagnostic overlay.
///
/// Uses a singleton pattern to avoid registering multiple log sinks across preview refreshes.
/// Install via ``install()`` before the preview view controller is created.
@available(iOS 14.0, *)
internal final class HaapiPreviewLogCollector: ObservableObject, LogSink, @unchecked Sendable {

    struct LogEntry: Identifiable, Sendable {
        let id = UUID()
        let level: String
        let tag: String
        let message: String
    }

    static let shared = HaapiPreviewLogCollector()

    @Published private(set) var entries: [LogEntry] = []

    nonisolated(unsafe) private static var isInstalled = false

    private init() {}

    func writeLog(logType: LogType, followUpTag: any FollowUpTag, message: String, file: String, line: Int) {
        let entry = LogEntry(level: logType.rawValue, tag: followUpTag.tagName, message: message)
        if Thread.isMainThread {
            entries.append(entry)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.entries.append(entry)
            }
        }
    }

    /// Registers the shared collector as a `HaapiLogger` log sink (once per process),
    /// configures logging for all UIKit follow-up tags at debug level,
    /// and clears previously captured entries.
    @discardableResult
    static func install() -> HaapiPreviewLogCollector {
        shared.entries.removeAll()
        guard !isInstalled else { return shared }
        HaapiLogger.appendLogSink(shared)
        HaapiLogger.setLogType(.debug)
        HaapiLogger.followUpTags = UIKitFollowUpTag.allCases
        isInstalled = true
        return shared
    }
}

// MARK: - Diagnostic Overlay

/// Wraps preview content with an optional diagnostic panel showing theme resolution details
/// and captured `HaapiLogger` log entries.
/// The panel is only rendered when `diagnostics` is non-nil.
@available(iOS 14.0, *)
internal struct HaapiPreviewDiagnosticWrapper<Content: View>: View {
    let diagnostics: HaapiPreviewDiagnosticInfo?
    @ObservedObject private var logCollector = HaapiPreviewLogCollector.shared
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack(alignment: .bottom) {
            content()
            if let diagnostics = diagnostics {
                diagnosticPanel(diagnostics)
            }
        }
    }

    private func diagnosticPanel(_ info: HaapiPreviewDiagnosticInfo) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                Text("Preview Diagnostics")
                    .font(.system(.caption, design: .monospaced).bold())
                    .foregroundColor(.white)

                diagnosticRow("Theme", info.themeName)
                diagnosticRow(
                    "In preferred bundle",
                    info.themeFoundInPreferredBundle ? "YES" : "NO",
                    isWarning: !info.themeFoundInPreferredBundle
                )
                diagnosticRow(
                    "Preferred bundle",
                    info.preferredBundleIdentifier ?? shortenPath(info.preferredBundlePath)
                )
                diagnosticRow(
                    "Resolved bundle",
                    info.resolvedBundleIdentifier ?? shortenPath(info.resolvedBundlePath)
                )

                if let plistURL = info.plistURL {
                    diagnosticRow("Plist path", shortenPath(plistURL.path))
                }

                if let error = info.error {
                    Text(error)
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundColor(info.plistURL == nil ? .red : .yellow)
                }

                if !logCollector.entries.isEmpty {
                    Divider()
                        .background(Color.gray)

                    Text("HaapiLogger (\(logCollector.entries.count))")
                        .font(.system(.caption, design: .monospaced).bold())
                        .foregroundColor(.white)

                    ForEach(logCollector.entries) { entry in
                        logEntryRow(entry)
                    }
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxHeight: 300)
        .background(Color.black.opacity(0.8))
    }

    private func logEntryRow(_ entry: HaapiPreviewLogCollector.LogEntry) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text("[\(entry.level.uppercased())]")
                .font(.system(.caption2, design: .monospaced).bold())
                .foregroundColor(logLevelColor(entry.level))
            Text(entry.message)
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(.white)
                .lineLimit(5)
        }
    }

    private func logLevelColor(_ level: String) -> Color {
        switch level {
        case "error": return .red
        case "warning": return .yellow
        case "info": return .white
        default: return .gray
        }
    }

    private func diagnosticRow(_ label: String, _ value: String, isWarning: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(label):")
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(isWarning ? .yellow : .white)
                .lineLimit(2)
        }
    }

    /// Shortens a file path by keeping only the last 3 path components for readability.
    private func shortenPath(_ path: String) -> String {
        let components = path.split(separator: "/")
        if components.count > 3 {
            return ".../" + components.suffix(3).joined(separator: "/")
        }
        return path
    }
}

/// Diagnostic information about theme resolution, displayed in the preview canvas overlay.
@available(iOS 14.0, *)
internal struct HaapiPreviewDiagnosticInfo {
    let themeName: String
    let preferredBundlePath: String
    let preferredBundleIdentifier: String?
    let resolvedBundlePath: String
    let resolvedBundleIdentifier: String?
    let themeFoundInPreferredBundle: Bool
    let plistURL: URL?
    let error: String?
}

#endif
