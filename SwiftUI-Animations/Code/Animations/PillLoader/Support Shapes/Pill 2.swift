//
//  Circle.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An alternate version of the `Pill` dot particle, using a softer
/// `interpolatingSpring(stiffness: 0.5, damping: 1)` for a slower, floatier feel.
///
/// Functionally identical to `Pill.swift` but with different spring parameters.
/// Both files define the same `Pill` struct — this file takes precedence depending
/// on link order. The different spring tuning makes drops feel more liquid than snappy.
struct Pill: View {

    // MARK: - Variables

    /// Fixed dot width (40 pt).
    let width: CGFloat = 40
    /// Fixed dot height (40 pt).
    let height: CGFloat = 40

    /// Starting (x, y) position of the dot (resting state, `isAnimating == false`).
    let initialOffset: CGSize
    /// Target (x, y) position of the dot when `isAnimating == true`.
    let animationOffset: CGSize

    /// Base animation duration (unused directly — interpolating spring drives timing).
    let animationDuration: TimeInterval = 0.1
    /// Stagger delay before this dot's spring fires.
    let animationDelay: TimeInterval

    /// Shared with the parent group; `true` triggers the spring jump to `animationOffset`.
    @Binding var isAnimating: Bool

    // MARK: - Views
    var body: some View {
        Circle()
            .foregroundStyle(Color.pillColor)
            .frame(width: width, height: height)
            .offset(isAnimating ? animationOffset : initialOffset)
            .animation(.interpolatingSpring(stiffness: 0.5, damping: 1).delay(animationDelay), value: isAnimating)
    }
}

#Preview {
    Pill(initialOffset: CGSize(width: 0, height: 0), animationOffset: CGSize(width: 40, height: 40), animationDelay: 0.1, isAnimating: .constant(true))
}
