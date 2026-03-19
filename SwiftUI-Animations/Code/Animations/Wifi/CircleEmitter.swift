//
//  Test.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 12/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A particle burst effect composed of 50 small white dots scattered across the screen.
///
/// When `isAnimating` is `true`, each dot scales from 0 to 1 with a staggered
/// `easeInOut` delay (`0.01 s × index`), creating a rippling confetti-like reveal.
/// When `false`, dots collapse back to zero scale with no animation (`.none`).
///
/// Used in `WifiView` to celebrate a simulated successful connection.
struct CircleEmitter: View {
    /// Controls whether the dots are visible. `true` = burst in; `false` = collapse out.
    @Binding var isAnimating: Bool

    var body: some View {
        ForEach(0 ..< 50) { ix in
            Circle()
                .fill(Color.white.opacity(0.75))
                .frame(width: 6, height: 6)
                .offset(x: CGFloat.random(in: -250 ..< 250), y: CGFloat.random(in: -200 ..< 250))
                .scaleEffect(isAnimating ? 1 : 0)
                .animation(isAnimating ? .easeInOut(duration: 0.125).delay(0.01 * Double(ix)) : .none, value: isAnimating)
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        CircleEmitter(isAnimating: .constant(true))
    }
}
