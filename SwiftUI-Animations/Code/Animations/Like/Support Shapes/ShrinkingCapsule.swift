//
//  ShrinkingCapsule.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A single colored capsule particle that shrinks and fades as part of the like burst effect.
///
/// Each capsule starts tall (65 pt) and collapses to 30 pt when `isAnimating` becomes `true`,
/// then fades to opacity 0 after `animationDuration`. This simulates a firework spark
/// shooting outward and vanishing.
///
/// Used in both `CapusuleGroupView` and `LowerCapsuleView` at different rotation angles
/// and offsets to produce the full 360° particle ring.
struct ShrinkingCapsule: View {

    // MARK: - Variables

    /// Duration of both the height collapse and the fade-out animation.
    let animationDuration: Double = 0.4
    /// Angle the capsule is rotated to point outward from the heart center.
    let rotationAngle: Angle
    /// (x, y) position of this capsule within the burst group.
    let offset: CGSize

    /// Triggers the height collapse from 65 → 30 pt when `true`.
    @Binding var isAnimating: Bool
    /// Set to `true` after `animationDuration` to fade the capsule to opacity 0.
    @State var hideCapsule: Bool = false

    var body: some View {
        ZStack {
            Capsule(style: .continuous)
                .fill(Color.likeColor)
                .frame(width: 15, height: isAnimating ? 30 : 65, alignment: .bottomLeading)
                .animation(.easeIn(duration: animationDuration), value: isAnimating)
                .rotationEffect(rotationAngle)
        }.offset(offset)
        .opacity(hideCapsule ? 0 : 0.8)
        .animation(.easeIn(duration: animationDuration), value: hideCapsule)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if isAnimating {
                    Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
                        hideCapsule.toggle()
                    }
                    timer.invalidate()
                }
            }
        }
    }
}

#Preview {
    ShrinkingCapsule(rotationAngle: .degrees(35), offset: CGSize(width: 10, height: 10), isAnimating: .constant(false))
}
