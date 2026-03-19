//
//  DotsLoaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Three white dots that slide left and right in a staggered "typing indicator" pattern.
///
/// All three dots share the same `leftOffset` so they always move to the same target,
/// but each has a different `easeInOut` delay (0, 0.2, 0.4 s) that fans them apart
/// into a wave-like chasing motion.
///
/// The offsets swap every `animationDuration × 1.5` via `swap(&leftOffset, &rightOffset)`,
/// so the direction reverses each cycle without any conditional branching.
struct DotsLoaderView: View {

    // MARK: - Variables

    /// Current x-offset applied to all three dots. Swaps with `rightOffset` each cycle.
    @State var leftOffset: CGFloat = -75
    /// Counter-offset — holds the "other" end position while `leftOffset` is active.
    @State var rightOffset: CGFloat = 75

    /// Duration for one half-cycle (dots sliding from left to right, or vice versa).
    let animationDuration: TimeInterval = 1

    // MARK: - Views

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(.easeInOut(duration: animationDuration), value: leftOffset)
            Circle()
                .fill(.white)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(.easeInOut(duration: animationDuration).delay(0.2), value: leftOffset)
            Circle()
                .fill(.white)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(.easeInOut(duration: animationDuration).delay(0.4), value: leftOffset)
        }
        .onAppear {
            swap(&leftOffset, &rightOffset)
            Timer.scheduledTimer(withTimeInterval: animationDuration * 1.5, repeats: true) { _ in
                swap(&self.leftOffset, &self.rightOffset)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        DotsLoaderView()
    }
}
