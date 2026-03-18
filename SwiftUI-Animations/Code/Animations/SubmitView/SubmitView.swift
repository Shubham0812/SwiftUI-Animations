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

    // MARK:- variables

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
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                RoundedRectangle(cornerRadius: self.isAnimating ? 46 : 20, style: .circular)
                    .fill(Color.submitColor)
                    .frame(width: self.isAnimating ? 92 : 300, height: 92)
                    .scaleEffect(submitScale, anchor: .center)
                    .onTapGesture {
                        if (!self.isAnimating) {
                            HapticManager().makeSelectionFeedback()
                            toggleIsAnimating()
                            animateButton()
                            resetSubmit()
                            Timer.scheduledTimer(withTimeInterval:  trackerRotation * 0.95, repeats: false) { _ in
                                self.taskDone.toggle()
                            }
                        }
                    }
                if (self.isAnimating) {
                    RotatingCircle(trackerRotation: trackerRotation, timerInterval:  trackerRotation * 0.91)
                }
                Tick(scaleFactor: 0.4)
                    .trim(from: 0, to: self.taskDone ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .foregroundColor(Color.white)
                    .frame(width: 16)
                    .offset(x: -4, y: 4)
                    .animation(.easeOut(duration: 0.35))
                Text("Submit")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.white)
                    .opacity(self.isAnimating ? 0 : 1)
                    .animation(Animation.easeOut(duration: animationDuration))
                    .scaleEffect(self.isAnimating ? 0.7 : 1)
                    .animation(Animation.easeOut(duration: animationDuration))
            }
        }
    }
    
    // MARK:- functions

    /// Triggers three "heartbeat" pulses at 0s, 1s, and 2s while the spinner is active.
    func animateButton() {
        expandButton()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            expandButton()
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            expandButton()
        }    }
    
    /// Performs one scale-up (1.35×) then scale-down (1×) pulse over 1 second total.
    func expandButton() {
        withAnimation(Animation.linear(duration: 0.5)) {
            self.submitScale = 1.35
        }
        withAnimation(Animation.linear(duration: 0.5).delay(0.5)) {
            self.submitScale = 1
        }
    }
    
    /// Schedules a reset that restores the button to its initial "Submit" state
    /// after the spinner and checkmark have finished.
    func resetSubmit() {
        Timer.scheduledTimer(withTimeInterval: trackerRotation * 0.95 + animationDuration * 3.5, repeats: false) { _ in
            toggleIsAnimating()
            self.taskDone.toggle()
        }
    }
    
    /// Toggles `isAnimating` with a spring animation that morphs the button shape.
    func toggleIsAnimating() {
        withAnimation(Animation.spring(response: animationDuration * 1.25, dampingFraction: 0.9, blendDuration: 1)){
            self.isAnimating.toggle()
        }
    }
}

struct SubmitView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitView()
    }
}
