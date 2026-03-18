//
//  LikeView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A full-screen like button with a multi-layered celebration animation.
///
/// **On first tap (like):**
/// 1. The circle instantly shrinks (spring) then bounces back, giving a "pulse" feel.
/// 2. The heart icon scales up and a pink color mask sweeps across it (`easeIn`).
/// 3. A `CapusuleGroupView` burst of capsule particles appears above the heart.
/// 4. A `FloatingLike` "+1" bubble floats upward and fades out.
///
/// **On second tap (unlike):** all state resets instantly — circle reverts, burst disappears.
struct LikeView: View {

    // MARK:- variables

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
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.likeBackground
                .edgesIgnoringSafeArea(.all)
            ZStack {
                if (floatLike) {
                    CapusuleGroupView(isAnimating: $floatLike)
                        .offset(y: -130)
                        .scaleEffect(self.showFlare ? 1.25 : 0.8)
                        .opacity(self.floatLike ? 1 : 0)
                        .animation(Animation.spring().delay(animationDuration / 2))
                }
                Circle()
                    .foregroundColor(self.isAnimating ? Color.likeColor : Color.likeOverlay)
                    .animation(Animation.easeOut(duration: animationDuration * 2).delay(animationDuration))
                HeartImageView()
                    .foregroundColor(.white)
                    .offset(y: 12)
                    .scaleEffect(self.isAnimating ? 1.25 : 1)
                    .overlay(
                        Color.likeColor
                            .mask(
                                HeartImageView()
                            )
                            .offset(y: 12)
                            .scaleEffect(self.isAnimating ? 1.35 : 0)
                            .animation(Animation.easeIn(duration: animationDuration))
                            .opacity(self.isAnimating ? 0 : 1)
                            .animation(Animation.easeIn(duration: animationDuration).delay(animationDuration))
                    )
            }.frame(width: 250, height: 250)
            .scaleEffect(self.shrinkIcon ? 0.35 : 1)
            .animation(Animation.spring(response: animationDuration, dampingFraction: 1, blendDuration: 1))
            if (floatLike) {
                FloatingLike(isAnimating: $floatLike)
                    .offset(y: -40)
            }
        }.onTapGesture {
            if (!floatLike) {
                self.floatLike.toggle()
                self.isAnimating.toggle()
                self.shrinkIcon.toggle()
                Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
                    self.shrinkIcon.toggle()
                    self.showFlare.toggle()
                }
            } else {
                self.isAnimating = false
                self.shrinkIcon = false
                self.showFlare = false
                self.floatLike = false
            }
        }
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeView()
    }
}
