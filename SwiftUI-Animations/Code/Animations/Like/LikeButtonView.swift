//
//  LikeButton.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Duplicate entry point for `LikeView` — see `LikeView.swift` for full documentation.
///
/// Both files define the same `LikeView` struct. This file is kept as an alternate
/// preview/entry point. Refer to `LikeView.swift` for the complete animation description.
struct LikeButtonView: View {

    // MARK: - Variables

    /// Base duration for all timed animations in the like sequence.
    let animationDuration: Double = 0.25

    /// `true` while the like animation is active — drives heart scale and circle color.
    @State var isAnimating: Bool = false
    /// Briefly `true` during the initial spring pulse — causes the circle to shrink then snap back.
    @State var shrinkIcon: Bool = false
    /// `true` while the liked state is active — shows `CapusuleGroupView` and `FloatingLike`.
    @State var floatLike: Bool = false
    /// Toggled after `animationDuration` to scale the capsule burst from 0.8× to 1.25×.
    @State var showFlare: Bool = false

    // MARK: - Views
    var body: some View {
        ZStack {
            Color.likeBackground
                .ignoresSafeArea()
            ZStack {
                if floatLike {
                    CapusuleGroupView(isAnimating: $floatLike)
                        .offset(y: -130)
                        .scaleEffect(showFlare ? 1.25 : 0.8)
                        .opacity(floatLike ? 1 : 0)
                        .animation(.spring().delay(animationDuration / 2), value: showFlare)
                }
                Circle()
                    .foregroundStyle(isAnimating ? Color.likeColor : Color.likeOverlay)
                    .animation(.easeOut(duration: animationDuration * 2).delay(animationDuration), value: isAnimating)
                HeartImageView()
                    .foregroundStyle(.white)
                    .offset(y: 12)
                    .scaleEffect(isAnimating ? 1.25 : 1)
                    .overlay(
                        Color.likeColor
                            .mask(
                                HeartImageView()
                            )
                            .offset(y: 12)
                            .scaleEffect(isAnimating ? 1.35 : 0)
                            .animation(.easeIn(duration: animationDuration), value: isAnimating)
                            .opacity(isAnimating ? 0 : 1)
                            .animation(.easeIn(duration: animationDuration).delay(animationDuration), value: isAnimating)
                    )
            }.frame(width: 250, height: 250)
            .scaleEffect(shrinkIcon ? 0.35 : 1)
            .animation(.spring(response: animationDuration, dampingFraction: 1, blendDuration: 1), value: shrinkIcon)
            if floatLike {
                FloatingLike(isAnimating: $floatLike)
                    .offset(y: -40)
            }
        }.onTapGesture {
            if !floatLike {
                floatLike.toggle()
                isAnimating.toggle()
                shrinkIcon.toggle()
                Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
                    shrinkIcon.toggle()
                    showFlare.toggle()
                }
            } else {
                isAnimating = false
                shrinkIcon = false
                showFlare = false
                floatLike = false
            }
        }
    }
}

#Preview {
    LikeButtonView()
}
