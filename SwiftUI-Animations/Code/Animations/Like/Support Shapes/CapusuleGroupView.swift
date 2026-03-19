//
//  UpperCapsuleView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A radial burst of 11 shrinking capsules arranged in a fan, simulating a like confetti explosion.
///
/// Five upper `ShrinkingCapsule` instances spread at 0°, ±33°, and ±65° in a top fan.
/// Six lower `ShrinkingCapsule` instances in `LowerCapsuleView` extend the burst downward.
/// Together they form the colorful particle ring that appears above the heart on like.
struct CapusuleGroupView: View {

    // MARK: - Variables

    /// When `true`, all capsules shrink and fade — triggers the burst animation in each child.
    @Binding var isAnimating: Bool

    // MARK: - Views
    var body: some View {
        ZStack {
            ShrinkingCapsule(rotationAngle: .zero, offset: CGSize(width: 0, height: -15), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-33), offset: CGSize(width: -80, height: 7.5), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(33), offset: CGSize(width: 80, height: 7.5), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-65), offset: CGSize(width: -135, height: 70), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(65), offset: CGSize(width: 135, height: 70), isAnimating: $isAnimating)
            LowerCapsuleView(isAnimating: $isAnimating)
        }
        .onTapGesture {
            isAnimating.toggle()
        }
    }
}

#Preview {
    CapusuleGroupView(isAnimating: .constant(false))
}
