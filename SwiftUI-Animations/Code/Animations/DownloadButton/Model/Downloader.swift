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
enum DownloadState: CaseIterable {
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
    /// - `notInitiated`: adapts to the system label color (light/dark aware)
    /// - `downloading`:  WhatsApp-green tint to signal active progress
    /// - `downloaded`:   Custom `chatBackground` color for the success state
    func getBackground() -> Color {
        switch self {
        case .notInitiated:
            return .label
        case .downloading:
            return Color(hex: "128C7E")  // WhatsApp-style green
        case .downloaded:
            return Color.chatBackground
        }
    }
    
    /// Returns the vertical offset applied to the button's label text.
    /// The `.downloading` state shifts the text up by 8pt to make room
    /// for the animated progress indicator that appears below it.
    func offsetForText() -> CGFloat {
        switch self {
        case .notInitiated:
            return 0
        case .downloading:
            return 8   // Nudges label upward to accommodate the progress indicator
        case .downloaded:
            return 0
        }
    }
}

/// Shared dimensional constants for the download button.
/// Centralised here so any layout change only needs to be made in one place.
struct ButtonDimension {
    static let width: CGFloat = 320
    static let height: CGFloat = 76
    static let animationDuration: TimeInterval = 0.35  // Used for all state transition animations
    static let cornerRadius: CGFloat = 12
}

/// Observable wrapper around `DownloadState` that drives the download button's UI.
///
/// Held as an `@ObservedObject` or `@StateObject` in the parent view — any
/// write to `currentState` automatically triggers a re-render of subscribed views.
class Downloader: ObservableObject {
    
    /// The single source of truth for the button's current visual and functional state.
    @Published var currentState: DownloadState = DownloadState.notInitiated
    
    // MARK:- inits
    
    /// Creates a `Downloader` with an optional starting state.
    /// Defaults to `.notInitiated` so the button begins in its idle/ready state.
    /// Pass a different state (e.g. `.downloaded`) to restore a persisted download status.
    init(state: DownloadState = .notInitiated) {
        self.currentState = state
    }
}
