//
//  LowerCapsuleView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The lower six capsule bursts of the like particle animation.
///
/// Six `ShrinkingCapsule` instances placed at ±16°, ±48°, and ±82° form a downward fan
/// that completes the circular burst begun by `CapusuleGroupView`'s upper five capsules.
/// The entire group is offset 260 pt downward to position the lower fan below the heart.
struct LowerCapsuleView: View {

    // MARK: - Variables

    /// When `true`, triggers all six capsules to shrink and fade in sequence.
    @Binding var isAnimating: Bool

    // MARK: - Views
    var body: some View {
        ZStack {
            ShrinkingCapsule(rotationAngle: .degrees(16), offset: CGSize(width: -42.5, height: 10), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-16), offset: CGSize(width: 42.5, height: 10), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(48), offset: CGSize(width: -107, height: -30), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-48), offset: CGSize(width: 107, height: -30), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(82), offset: CGSize(width: -142, height: -95), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-82), offset: CGSize(width: 142, height: -95), isAnimating: $isAnimating)
        }
        .offset(y: 260)
    }
}

#Preview {
    LowerCapsuleView(isAnimating: .constant(false))
}
