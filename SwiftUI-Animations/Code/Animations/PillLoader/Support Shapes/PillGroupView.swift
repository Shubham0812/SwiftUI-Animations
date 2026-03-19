//
//  PillDrop.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A cluster of 10 `Pill` dots arranged in a tight group that explode upward when activated.
///
/// Each dot has a unique initial position (clustered at the bottom of the pill container)
/// and a target position above the pill. Staggered delays of 0.05 s per dot make them
/// scatter in a cascading burst rather than jumping all at once.
///
/// Three `PillGroupView` instances with different `initialOffSet` values compose the
/// full `PillsDropView` particle system seen when the pill opens.
struct PillGroupView: View {

    // MARK: - Variables

    /// When `true`, all 10 dots spring to their respective `animationOffset` positions.
    @Binding var isAnimating: Bool

    /// Base (x, y) position added to each dot's hardcoded cluster offset.
    /// Different values per group shift the entire cluster up, down, or sideways.
    let initialOffSet: CGSize
    /// Base delay applied to all dots in this group; each dot adds an additional 0.05 s stagger.
    let animationOffset: Double

    // MARK: - Views
    var body: some View {
        ZStack {
            Pill(initialOffset: CGSize(width: initialOffSet.width + 45, height: initialOffSet.height + 125), animationOffset: CGSize(width: initialOffSet.width + -20, height: -150), animationDelay: animationOffset, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + -45, height: initialOffSet.height + 118), animationOffset: CGSize(width: initialOffSet.width + -20, height: -145), animationDelay: animationOffset + 0.05, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + 10, height: initialOffSet.height + 124), animationOffset: CGSize(width: initialOffSet.width + -20, height: -150), animationDelay: animationOffset + 0.1, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + -10, height: initialOffSet.height + 125), animationOffset: CGSize(width: initialOffSet.width, height: -145), animationDelay: animationOffset + 0.15, isAnimating: $isAnimating)

            Pill(initialOffset: CGSize(width: initialOffSet.width + -30, height: initialOffSet.height + 145), animationOffset: CGSize(width: initialOffSet.width + 10, height: -157.5), animationDelay: animationOffset + 0.2, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + -40, height: initialOffSet.height + 135), animationOffset: CGSize(width: initialOffSet.width + -20, height: -145), animationDelay: animationOffset + 0.25, isAnimating: $isAnimating)

            Pill(initialOffset: CGSize(width: initialOffSet.width + 40, height: initialOffSet.height + 140), animationOffset: CGSize(width: initialOffSet.width + -10, height: -120), animationDelay: animationOffset + 0.3, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + 25, height: initialOffSet.height + 155), animationOffset: CGSize(width: initialOffSet.width + -30, height: -125), animationDelay: animationOffset + 0.35, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width, height: initialOffSet.height + 160), animationOffset: CGSize(width: initialOffSet.width + 20, height: -155), animationDelay: animationOffset + 0.4, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + -20, height: initialOffSet.height + 155), animationOffset: CGSize(width: initialOffSet.width, height: -125), animationDelay: animationOffset + 0.45, isAnimating: $isAnimating)
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        ZStack {
            PillGroupView(isAnimating: .constant(false), initialOffSet: CGSize(width: 0, height: 0), animationOffset: 0.1)
            Capsule(style: .circular)
                .stroke(style: StrokeStyle(lineWidth: 10))
                .foregroundStyle(.white)
            Color.white
                .frame(height: 6, alignment: .center)
        }
        .frame(width: 140, height: 360)
    }
}
