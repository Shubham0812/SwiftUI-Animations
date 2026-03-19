//
//  PillLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A pill-shaped loader that spins, splits open, fills with a wave animation, then resets.
///
/// **Animation sequence (one full cycle):**
/// 1. The pill rotates 1.5 × 360° = 540° with an interactive spring.
/// 2. Near the end of the rotation, the top half slides away (`hideCapsule = true`),
///    revealing the pill interior.
/// 3. A wave-fill (`WaveFill`) rises up from the bottom half while `fillCapsule = true`.
///    A repeating timer increments `time` to animate the wave curve.
/// 4. After 2.5× the rotation window, everything snaps back to the initial state.
///
/// `FillShapes` decorators float above and below the pill to add particle depth.
struct PillLoader: View {

    // MARK: - Variables

    /// Number of full rotations per cycle. Total rotation = `trackerRotation × 360°`.
    let trackerRotation: Double = 1.5
    /// Base duration driving both the rotation spring and the fill animation.
    let animationDuration: Double = 3
    /// Cool blue-to-purple gradient background for the full screen.
    let backgroundColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottom)

    /// Drives the initial rotation spring. Toggled at cycle start and mid-cycle reset.
    @State var isAnimating: Bool = false
    /// When `true`, the top half of the pill slides away, revealing the fill interior.
    @State var hideCapsule: Bool = false
    /// When `true`, the `WaveFill` rises up to fill the lower half of the pill.
    @State var fillCapsule: Bool = false

    /// Wave curve phase offset, incremented every 10 ms while `hideCapsule` is true.
    /// Passed to `WaveFill` to produce a continuously undulating liquid surface.
    @State private var time: CGFloat = 0.5

    // MARK: - Views
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            ZStack {
                PillsDropView(isAnimating: $hideCapsule)
                    .opacity(hideCapsule ? 1 : 0)
                // Outer container
                Capsule(style: .circular)
                    .stroke(style: StrokeStyle(lineWidth: 10))
                    .foregroundStyle(.white)
                    .shadow(color: Color.white.opacity(0.1), radius: 1)

                FillShapes(xOffset: -45, yOffset: -100, capsuleSpacing: 40)

                // Line
                Color.white
                    .frame(height: 6, alignment: .center)

                // Initial Half Capsule
                Capsule(style: .circular)
                    .trim(from: 0, to: 0.5)
                    .foregroundStyle(Color.pillColor)
                    .padding(5.5)
                    .padding(.top, 6)
                    .opacity(hideCapsule ? 0 : 1)
                FillShapes(xOffset: 45, yOffset: 100, capsuleSpacing: -40)

                // Filling Capsule
                ZStack {
                    WaveFill(curve: time * 0.25, curveHeight: 10, curveLength: 1.5)
                        .fill(Color.pillColor.opacity(0.985))
                        .offset(y: fillCapsule ? 0 : 180)
                    WaveFill(curve: time * 5, curveHeight: 12, curveLength: 1.5)
                        .fill(Color.pillColor.opacity(0.9))
                        .offset(y: fillCapsule ? 0 : 180)
                    FillShapes(xOffset: 45, yOffset: 100, capsuleSpacing: -40)
                }
                .rotationEffect(.degrees(180))
                .opacity(hideCapsule ? 1 : 0)
                .mask(
                    Capsule(style: .circular)
                        .trim(from: 0.5, to: 1)
                        .foregroundStyle(Color.red)
                        .padding(5.5)
                        .padding(.bottom, 8)
                )
            }
            .frame(width: 140, height: 360)
            .rotationEffect(isAnimating ? getRotationAngle() : .degrees(0))
        }.onAppear {
            animateLoader()
            Timer.scheduledTimer(withTimeInterval: (animationDuration * trackerRotation) * 3.75, repeats: true) { _ in
                animateLoader()
            }
        }
    }

    // MARK: - Functions

    /// Returns the total rotation for one cycle: `trackerRotation × 360°` = 540°.
    func getRotationAngle() -> Angle {
        return .degrees(360 * trackerRotation)
    }

    /// Runs one complete loader cycle with four overlapping timer phases:
    ///
    /// - **t = 0**: Rotates the pill 540° using an interactive spring.
    /// - **t = (rotation − 0.25 s)**: Splits the pill open (`hideCapsule`) and starts the wave fill.
    ///   A 10 ms repeating timer increments `time` to animate the wave while the pill is open.
    /// - **t = rotation × 2.5**: Resets all state back to initial for the next cycle.
    func animateLoader() {
        withAnimation(.interactiveSpring(response: animationDuration * trackerRotation, dampingFraction: 1, blendDuration: 1)) {
            isAnimating.toggle()
        }
        Timer.scheduledTimer(withTimeInterval: (animationDuration * trackerRotation) - 0.25, repeats: false) { _ in
            withAnimation(.easeOut(duration: animationDuration / 2)) {
                hideCapsule.toggle()
            }
            withAnimation(.easeIn(duration: animationDuration * 1.85).delay(0.05)) {
                fillCapsule.toggle()
            }
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { curveTimer in
                if hideCapsule {
                    time += 0.01
                } else {
                    curveTimer.invalidate()
                }
            }
        }
        Timer.scheduledTimer(withTimeInterval: (animationDuration * trackerRotation) * 2.5, repeats: false) { _ in
            hideCapsule.toggle()
            isAnimating.toggle()
            fillCapsule.toggle()
            time = 0.5
        }
    }
}

#Preview {
    PillLoader()
}
