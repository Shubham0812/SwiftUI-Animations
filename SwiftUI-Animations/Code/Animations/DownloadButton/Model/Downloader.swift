//
//  Downloader.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 08/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Represents the three stages of a download lifecycle.
/// Drives the button's label text, background color, and text offset
/// across all three visual states.
enum DownloadState: CaseIterable, Equatable {
    case notInitiated  // Idle — button is ready to be tapped
    case downloading   // In progress — animated progress indicator is running
    case downloaded    // Complete — success state shown to the user

    /// Returns the button label for each state.
    func getStateName() -> String {
        switch self {
        case .notInitiated:
            return "Download"
        case .downloading:
            return "Downloading"
        case .downloaded:
            return "Finished"
        }
    }

    /// Returns the button's background color for each state.
    func getBackground() -> Color {
        switch self {
        case .notInitiated:
            return .label
        case .downloading:
            return Color(hex: "128C7E")
        case .downloaded:
            return Color.chatBackground
        }
    }

    /// Returns the horizontal offset applied to the button's label text.
    /// The `.downloading` state shifts the text up by 8pt to make room for the progress indicator.
    func offsetForText() -> CGFloat {
        switch self {
        case .downloading:
            return 8
        default:
            return 0
        }
    }
}

/// Shared dimensional constants for the download button.
struct ButtonDimension {
    static let width: CGFloat = 320
    static let height: CGFloat = 76
    static let animationDuration: TimeInterval = 0.35
    static let cornerRadius: CGFloat = 12
}

/// Observable wrapper around `DownloadState` that drives the download button's UI.
@Observable
class Downloader {

    /// The single source of truth for the button's current visual and functional state.
    var currentState: DownloadState = .notInitiated

    /// Creates a `Downloader` with an optional starting state.
    init(state: DownloadState = .notInitiated) {
        currentState = state
    }
}
