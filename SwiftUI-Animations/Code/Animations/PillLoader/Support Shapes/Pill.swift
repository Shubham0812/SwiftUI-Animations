//
//  Circle.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A single colored dot that springs between two positions — used as a particle
/// in the `PillGroupView` pill-drop effect.
///
/// When `isAnimating` is `true`, the dot snaps from `initialOffset` to `animationOffset`
/// with a spring animation. Each instance in a group has a different `animationDelay`
/// so the dots cascade out one after another rather than all at once.
///
/// This version uses `.spring().speed(1.35)` for a snappy response.
struct Pill: View {

    // MARK:- variables

    /// Fixed dot width (40 pt).
    let width: CGFloat = 40
    /// Fixed dot height (40 pt).
    let height: CGFloat = 40

    /// Starting (x, y) position of the dot (resting state, `isAnimating == false`).
    let initialOffset: CGSize
    /// Target (x, y) position of the dot when `isAnimating == true`.
    let animationOffset: CGSize

    /// Base animation duration (unused directly — spring response drives timing).
    let animationDuration: TimeInterval = 0.075
    /// Stagger delay before this dot's spring fires. Cascade effect in `PillGroupView`.
    let animationDelay: TimeInterval

    /// Shared with the parent group; `true` triggers the spring jump to `animationOffset`.
    @Binding var isAnimating: Bool
    
    // MARK:- views
    var body: some View {
        Circle()
            .foregroundColor(Color.pillColor)
            .frame(width: width, height: height)
            .offset(self.isAnimating ? animationOffset : initialOffset)
            .animation(Animation.spring()
                .speed(1.35)
                .delay(self.animationDelay))
        }
    }
    
    struct Circle_Previews: PreviewProvider {
        static var previews: some View {
            Pill(initialOffset: CGSize(width: 0, height: 0), animationOffset: CGSize(width: 40, height: 40), animationDelay: 0.1, isAnimating: .constant(true))
        }
}
