//
//  LoaderIIView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A vertical stack of seven oscillating dots that creates a rippling wave loader.
///
/// Each dot is a `MovingCircleView` that bounces left and right continuously.
/// Alternating `.left` / `.right` starting directions and slightly varied durations
/// mean no two adjacent dots are ever perfectly in sync — producing an organic,
/// flowing wave pattern rather than a mechanical back-and-forth.
///
/// **Dot configuration:**
/// ```
/// #1  .right  1.00s  ─┐
/// #2  .left   1.10s   │
/// #3  .right  1.05s   │  Durations are intentionally non-uniform so the
/// #4  .left   1.15s   │  phase relationships between dots drift over time,
/// #5  .right  1.10s   │  keeping the animation from ever looking perfectly
/// #6  .left   1.05s   │  periodic or repetitive.
/// #7  .right  1.00s  ─┘  (#1 and #7 match, giving the stack soft symmetry)
/// ```
struct LoaderIIView: View {
    
    // MARK: - Views
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                // Dots are mirrored top-to-bottom (#1↔#7, #2↔#6, #3↔#5)
                // so the stack has soft visual symmetry at the start,
                // which gradually drifts as the non-uniform durations accumulate.
                
                MovingCircleView(state: .right, moveOffset: 15, animationDuration: 1.00)  // Top
                MovingCircleView(state: .left,  moveOffset: 15, animationDuration: 1.10)
                MovingCircleView(state: .right, moveOffset: 15, animationDuration: 1.05)
                MovingCircleView(state: .left,  moveOffset: 15, animationDuration: 1.15)  // Center (longest cycle)
                MovingCircleView(state: .right, moveOffset: 15, animationDuration: 1.10)
                MovingCircleView(state: .left,  moveOffset: 15, animationDuration: 1.05)
                MovingCircleView(state: .right, moveOffset: 15, animationDuration: 1.00)  // Bottom
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        LoaderIIView()
    }
}
