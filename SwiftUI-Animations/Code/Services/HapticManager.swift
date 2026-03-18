//
//  HapticManager.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 13/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

/// A lightweight wrapper around UIKit's haptic feedback generators.
///
/// Provides a simple API for triggering notification, selection, and impact haptics
/// from SwiftUI animation views. Create an instance and call the appropriate method
/// to play tactile feedback that enhances the animation experience.
struct HapticManager {

    /// The category of notification feedback to play.
    enum NotificationFeedbackType {
        /// Indicates a successful action.
        case success
        /// Indicates an informational event (mapped to the system warning haptic).
        case info
        /// Indicates a failed action.
        case failure
    }

    /// The intensity of impact feedback to play.
    enum ImpactFeedbackType {
        /// A subtle, light tap.
        case light
        /// A moderate tap.
        case medium
        /// A strong, pronounced tap.
        case heavy
    }

    // MARK:- functions

    /// Triggers a notification-style haptic (success, error, or warning).
    /// - Parameter mode: The type of notification feedback to generate.
    func makeNotifiationFeedback(mode: NotificationFeedbackType) {
        let generator = UINotificationFeedbackGenerator()

        if (mode == .success) {
            generator.notificationOccurred(.success)
        } else if (mode == .failure) {
            generator.notificationOccurred(.error)
        } else {
            generator.notificationOccurred(.warning)
        }
    }

    /// Triggers a light selection-change haptic, suitable for picker or toggle interactions.
    func makeSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    /// Triggers an impact haptic with the specified intensity.
    /// - Parameter mode: The weight of the impact feedback (light, medium, or heavy).
    func makeImpactFeedback(mode: ImpactFeedbackType) {
        var generator: UIImpactFeedbackGenerator
        if (mode == .light) {
            generator = UIImpactFeedbackGenerator(style: .light)
        } else if (mode == .medium) {
            generator = UIImpactFeedbackGenerator(style: .medium)
        } else {
            generator = UIImpactFeedbackGenerator(style: .heavy)
        }
        generator.prepare()
        generator.impactOccurred()
    }
}
