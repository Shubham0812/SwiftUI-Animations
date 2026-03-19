//
//  ChatBarView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 08/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An animated chat input bar with an expandable attachment menu.
///
/// Tapping the `+` button rotates it 137° and reveals three attachment buttons
/// (camera, video, contact) via a rotation-in animation. Simultaneously, the
/// text field rotates out of view (–120°) and the entire bar wiggles slightly
/// (±3°) via an interpolating spring for a tactile feel.
///
/// After 0.5 s, the attachment panel auto-collapses and the text field rotates
/// back into view, returning the bar to its normal input state.
struct ChatBarView: View {

    // MARK: - Variables

    /// `true` for 0.5 s after the `+` button is tapped — shows the attachment panel.
    @State var addAttachment: Bool = false
    /// `true` while the attachment panel is open — rotates the `+` button and hides the text field.
    @State var rotateBar: Bool = false
    /// The user's typed message, bound from the parent view.
    @Binding var message: String

    /// Fixed height of the chat bar pill — also used to derive the corner radius (`height / 2`).
    var chatBarHeight: CGFloat = 86

    // MARK: - Views

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ZStack {
                Color.chatBackground
                HStack {
                    AttachmentButton(needsRotation: $rotateBar, iconName: "plus", iconSize: 24, action: {
                        rotateBar.toggle()
                        addAttachment.toggle()
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                            addAttachment.toggle()
                        }
                    })
                    Spacer()
                    ZStack {
                        HStack(alignment: .center, spacing: 20) {
                            AttachmentButton(needsRotation: .constant(false), iconName: "camera", action: {})
                            AttachmentButton(needsRotation: .constant(false), iconName: "video.fill", action: {})
                            AttachmentButton(needsRotation: .constant(false), iconName: "rectangle.stack.person.crop", action: {})
                        }
                        .rotationEffect(!rotateBar ? .degrees(90) : .degrees(0), anchor: .zero)
                        .offset(y: !rotateBar ? 72 : 0)
                        .animation(.spring(), value: rotateBar)

                        TextField("Message", text: $message)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .disableAutocorrection(true)
                            .foregroundStyle(.white)
                            .tint(.white)
                            .frame(height: 50)
                            .padding(.leading, 36)
                            .background(
                                Color.buttonBackground.opacity(0.5)
                                    .cornerRadius(24)
                                    .padding(.leading)
                            )
                            .rotationEffect(rotateBar ? .degrees(-120) : .degrees(0), anchor: .zero)
                            .animation(.spring(), value: rotateBar)
                    }
                }
                .padding()
                .padding([.leading, .trailing], 8)
            }
            .frame(height: chatBarHeight)
            .cornerRadius(chatBarHeight / 2)
            .padding()
            .padding([.leading, .trailing], 24)
            .shadow(radius: 10)
            .rotationEffect(getBarRotationDegree(), anchor: .leading)
            .animation(
                .interpolatingSpring(mass: 2, stiffness: 14, damping: 10, initialVelocity: 5)
                    .delay(0.1),
                value: addAttachment
            )
        }
    }

    /// Returns the bar's wiggle rotation angle based on the current animation state.
    ///
    /// - Both `rotateBar` and `addAttachment` true → –3° (tilts left as panel opens)
    /// - Only `addAttachment` true → +3° (rebounds right briefly)
    /// - Neither → 0° (normal horizontal position)
    func getBarRotationDegree() -> Angle {
        if rotateBar && addAttachment {
            return .degrees(-3)
        } else if addAttachment {
            return .degrees(3)
        } else {
            return .degrees(0)
        }
    }
}

#Preview {
    ChatBarView(message: .constant(""))
}
