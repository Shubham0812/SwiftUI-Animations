//
//  DownloadingIcon.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 09/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An animated download indicator showing a downward arrow looping
/// inside a circular frame — used to signal an active download in progress.
///
/// The arrow enters from the top of the circle, slides down, exits at the bottom,
/// then instantly resets to the top and repeats — creating the illusion of
/// continuous downward motion (like an conveyor belt or waterfall effect).
///
/// Set `needsAnimation = false` to render the indicator as a static icon,
/// useful for previews or states where motion isn't appropriate.
struct DownloadingIndicatorView: View {
    
    // MARK: - Variables
    
    /// Current vertical offset of the arrow symbol.
    /// Animates from `-size` (above the circle) to `+size` (below the circle),
    /// then snaps back to `-size` to loop seamlessly.
    @State var downloadSymbolYOffset: CGFloat = 0
    
    /// Duration of one downward sweep. Also used as the timer interval
    /// so each new sweep begins exactly when the previous one finishes.
    let animationDuration: TimeInterval = 0.5
    
    /// Diameter of the circle frame — also used as the full travel distance
    /// for the arrow, so it enters and exits just at the circle's edges.
    let size: CGFloat = 38
    
    /// When `false`, the view renders statically with no animation.
    /// Useful for previews or embedding in a non-animated context.
    var needsAnimation: Bool = true
    
    // MARK: - Views
    var body: some View {
        ZStack {
            // ── Circle border ─────────────────────────────────────────────────
            // Thin stroked ring that frames the arrow indicator.
            // The subtle drop shadow gives it slight lift off the background.
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 4))
                .frame(width: size, height: size)
                .shadow(color: Color.label.opacity(0.25), radius: 4, y: 2)
            
            // ── Arrow icon ────────────────────────────────────────────────────
            // Masked to the circle so it appears to enter from the top edge
            // and disappear through the bottom edge as it travels.
            // Without the mask, the arrow would be visible outside the circle
            // during the off-screen portions of its travel.
            Image(systemName: "arrow.down")
                .font(.system(size: 20, weight: .heavy))
                .offset(y: downloadSymbolYOffset)
                .mask(
                    Circle()
                        .frame(width: size, height: size)
                )
        }
        .onAppear {
            guard needsAnimation else { return }
            
            // Kick off the first sweep immediately on appear,
            // so there's no visible delay before the animation starts.
            withAnimation(Animation.easeIn(duration: animationDuration)) {
                downloadSymbolYOffset = size  // Slide down to the bottom edge
            }
            
            // Repeat at exactly `animationDuration` intervals so each sweep
            // starts the moment the previous one completes — no gap or overlap.
            Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                animate()
            }
        }
    }
    
    // MARK: - functions
    
    /// Performs one full downward sweep of the arrow:
    /// 1. Instantly snaps the arrow back to the top (above the circle, no animation)
    /// 2. Animates it back down to the bottom with `easeIn` — mimicking gravity
    ///
    /// The instant reset is invisible because the arrow is outside the masked
    /// circle at both `-size` and `+size`, so the jump produces no visible flicker.
    func animate() {
        downloadSymbolYOffset = -size  // Instant snap to top (hidden above the circle)
        withAnimation(Animation.easeIn(duration: animationDuration)) {
            downloadSymbolYOffset = size   // Animate down through and out of the circle
        }
    }
}

#Preview {
    DownloadingIndicatorView()
}
