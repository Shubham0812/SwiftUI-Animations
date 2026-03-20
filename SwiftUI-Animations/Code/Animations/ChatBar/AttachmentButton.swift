//
//  AttachmentButton.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 08/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A circular icon button used inside `ChatBarView` for the `+` toggle and attachment options.
///
/// When `needsRotation` is `true`, the button icon rotates 137° — used on the `+` button
/// to visually transform it into an ✕ (cancel) icon when the attachment panel is open.
///
/// A circular highlight overlay (`buttonPressAnimation`) is reserved for future tap feedback
/// but is currently not wired to a gesture (see TODO comment in the source).
struct AttachmentButton: View {

    /// When `true`, the icon rotates 137°. Bound from the parent to the `+` button only.
    @Binding var needsRotation: Bool
    /// Reserved for a press-ring feedback animation — not currently triggered by any gesture.
    @State var buttonPressAnimation: Bool = false

    /// SF Symbol name for the button icon (e.g. `"plus"`, `"camera"`, `"video.fill"`).
    var iconName: String
    /// Point size of the SF Symbol. Defaults to 20; the `+` button uses 24.
    var iconSize: CGFloat = 20
    /// Closure executed when the button is tapped.
    var action: () -> Void

    var body: some View {
        Button {
            HapticManager().makeImpactFeedback(mode: .light)
            action()
        } label: {
            Image(systemName: iconName)
                .font(.system(size: iconSize, weight: .medium, design: .rounded))
                .foregroundStyle(.white)
                .padding()
                .frame(width: 52, height: 52)
                .background(Color.buttonBackground.opacity(0.5))
                .cornerRadius(32)
                .rotationEffect(needsRotation ? .degrees(137) : .degrees(0))
                .animation(.easeIn(duration: 0.25).speed(1.5), value: needsRotation)
                .overlay(
                    Circle()
                        .opacity(buttonPressAnimation ? 0.1 : 0)
                        .scaleEffect(buttonPressAnimation ? 0.95 : 0.5)
                        .animation(buttonPressAnimation ? .easeIn(duration: 0.25) : .easeIn(duration: 0), value: buttonPressAnimation)
                )
        }
        // TODO: - Find a way to wire the tap gesture to the Button closure
    }
}

#Preview {
    AttachmentButton(needsRotation: .constant(true), iconName: "plus", action: {})
}
