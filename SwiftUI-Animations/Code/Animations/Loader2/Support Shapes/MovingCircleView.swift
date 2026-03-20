//
//  MovingCircleView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Describes the starting direction of a `MovingCircleView`'s oscillation.
///
/// - `left`:  The circle begins its first move to the left, then bounces right.
/// - `right`: The circle begins its first move to the right, then bounces left.
/// - `undefined`: No directional bias — defaults to the `.right` path in practice
///   (falls into the `else` branch in `onAppear`). Treat as an uninitialised state.
enum CircleState {
    case left
    case right
    case undefined
}

/// A small white circle that oscillates back and forth continuously,
/// useful as a component inside loading indicators or animated backgrounds.
///
/// Two instances offset by half a cycle (`animationDuration`) and started with
/// opposite `CircleState` values will appear to chase each other —
/// this is how a multi-dot "typing indicator" style loader can be built from this view.
///
/// **Motion pattern:**
/// ```
/// .left  →  moves to -moveOffset, then +moveOffset, then repeats
/// .right →  moves to +moveOffset, then -moveOffset, then repeats
/// ```
struct MovingCircleView: View {

    // MARK: - Variables

    /// Determines which direction the circle moves first on appear.
    /// Pairing two instances with `.left` and `.right` creates a mirrored oscillation.
    var state: CircleState = .undefined

    /// The maximum horizontal distance the circle travels from its center in either direction.
    /// A value of `0` produces no movement — set this to a positive number to enable oscillation.
    var moveOffset: CGFloat = 0

    /// Duration of one half-swing (center → edge).
    /// A full back-and-forth cycle takes `animationDuration * 2`.
    /// The repeat timer fires every `animationDuration` to kick off each new half-swing.
    var animationDuration: TimeInterval = 0.3

    /// Current horizontal offset of the circle, animated between `-moveOffset` and `+moveOffset`.
    @State var xOffset: CGFloat = 0

    // MARK: - Views
    var body: some View {
        Circle()
            .fill(Color.label)
            .frame(width: 18, height: 18)
            .offset(x: xOffset)
            .shadow(color: Color.white, radius: 5) // Soft glow that travels with the circle
            .onAppear {
                // Start the appropriate oscillation direction and repeat every half-cycle.
                // `.left` and `.right` use mirrored logic — `.undefined` falls through to `.right`.
                if state == .left {
                    Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                        initiateWithLeft()
                    }
                } else {
                    Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                        initiateWithRight()
                    }
                }
            }
    }

    // MARK: - Functions

    /// Performs one full left-biased oscillation: moves left first, then swings right.
    ///
    /// ```
    /// t = 0              Animate to -moveOffset (easeInOut over half duration)
    /// t = duration / 2   Animate to +moveOffset (easeInOut over 0.5s)
    /// ```
    /// > Note: The second half uses a hardcoded `0.5s` duration rather than
    /// > `animationDuration / 2`. This makes the rightward return slightly slower
    /// > than the leftward move. Mirror `initiateWithRight` if you want a
    /// > perfectly symmetrical swing.
    func initiateWithLeft() {
        // First half: swing to the left
        withAnimation(.easeInOut(duration: animationDuration / 2)) {
            xOffset = -moveOffset
        }
        // Second half: swing back to the right (hardcoded 0.5s — see note above)
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                xOffset = moveOffset
            }
        }
    }

    /// Performs one full right-biased oscillation: moves right first, then swings left.
    ///
    /// ```
    /// t = 0              Animate to +moveOffset (easeInOut over half duration)
    /// t = duration / 2   Animate to -moveOffset (easeInOut over half duration)
    /// ```
    /// Both halves use `animationDuration / 2`, making this a perfectly symmetrical swing
    /// (unlike `initiateWithLeft` which has a hardcoded `0.5s` on the return stroke).
    func initiateWithRight() {
        // First half: swing to the right
        withAnimation(.easeInOut(duration: animationDuration / 2)) {
            xOffset = moveOffset
        }
        // Second half: swing back to the left
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animationDuration / 2)) {
                xOffset = -moveOffset
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        MovingCircleView(moveOffset: 40, animationDuration: 1)
    }
}
