//
//  SubmitView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 07/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A submit button that morphs into a spinning progress indicator and
/// reveals a checkmark on completion.
///
/// **Animation sequence on tap:**
/// 1. Button text fades and the rounded rectangle shrinks to a circle (spring)
/// 2. A `RotatingCircle` orbits the button with a pulsing scale effect
/// 3. Once the rotation completes, a `Tick` shape draws on with `.trim()`
/// 4. After a delay, the button resets to its initial "Submit" state
struct SubmitView: View {

    // MARK: - Variables

    /// Base duration for the button's shape transition (shrink/expand).
    let animationDuration: TimeInterval = 0.45
    /// Number of full rotations the orbiting circle performs.
    let trackerRotation: Double = 2.585

    /// Whether the button is currently in its "processing" state (circle shape + spinner).
    @State var isAnimating: Bool = false
    /// Flipped to `true` when the spinner finishes, triggering the checkmark draw-on.
    @State var taskDone: Bool = false

    /// Scale factor for the pulsing "heartbeat" effect while the spinner is active.
    @State var submitScale: CGFloat = 1

    // MARK: - Views
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: isAnimating ? 46 : 20, style: .circular)
                    .fill(Color.submitColor)
                    .frame(width: isAnimating ? 92 : 300, height: 92)
                    .scaleEffect(submitScale, anchor: .center)
                    .onTapGesture {
                        if !isAnimating {
                            HapticManager().makeSelectionFeedback()
                            toggleIsAnimating()
                            animateButton()
                            resetSubmit()
                            Timer.scheduledTimer(withTimeInterval: trackerRotation * 0.95, repeats: false) { _ in
                                taskDone.toggle()
                            }
                        }
                    }
                if isAnimating {
                    RotatingCircle(trackerRotation: trackerRotation, timerInterval: trackerRotation * 0.91)
                }
                Tick(scaleFactor: 0.4)
                    .trim(from: 0, to: taskDone ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .foregroundStyle(Color.label)
                    .frame(width: 16)
                    .offset(x: -4, y: 4)
                    .animation(.easeOut(duration: 0.35), value: taskDone)
                Text("Submit")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.white)
                    .opacity(isAnimating ? 0 : 1)
                    .animation(.easeOut(duration: animationDuration), value: isAnimating)
                    .scaleEffect(isAnimating ? 0.7 : 1)
                    .animation(.easeOut(duration: animationDuration), value: isAnimating)
            }
            .offset(y: -50)
        }
    }

    // MARK: - Functions

    /// Triggers three "heartbeat" pulses at 0s, 1s, and 2s while the spinner is active.
    func animateButton() {
        expandButton()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            expandButton()
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            expandButton()
        }
    }

    /// Performs one scale-up (1.35×) then scale-down (1×) pulse over 1 second total.
    func expandButton() {
        withAnimation(.linear(duration: 0.5)) {
            submitScale = 1.35
        }
        withAnimation(.linear(duration: 0.5).delay(0.5)) {
            submitScale = 1
        }
    }

    /// Schedules a reset that restores the button to its initial "Submit" state
    /// after the spinner and checkmark have finished.
    func resetSubmit() {
        Timer.scheduledTimer(withTimeInterval: trackerRotation * 0.95 + animationDuration * 3.5, repeats: false) { _ in
            toggleIsAnimating()
            taskDone.toggle()
        }
    }

    /// Toggles `isAnimating` with a spring animation that morphs the button shape.
    func toggleIsAnimating() {
        withAnimation(.spring(response: animationDuration * 1.25, dampingFraction: 0.9, blendDuration: 1)) {
            isAnimating.toggle()
        }
    }
}

#Preview {
    SubmitView()
}
