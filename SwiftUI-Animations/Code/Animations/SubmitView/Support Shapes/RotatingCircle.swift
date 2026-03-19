//
//  RotatingCircle.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 07/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A white circle that orbits around a central point and then shrinks away,
/// used as the spinning progress indicator inside `SubmitView`.
///
/// On appear the circle scales up, moves outward, and begins rotating for
/// `trackerRotation` full turns over `timerInterval` seconds. When rotation
/// ends, it shrinks, drifts upward, and fades out.
struct RotatingCircle: View {

    // MARK: - Variables

    /// Unused flag — declared but never toggled in the current implementation.
    @State var isAnimating: Bool = false
    /// Current rotation angle, animated from 0° to `360 × trackerRotation`.
    @State var rotationAngle: Angle = .degrees(0)
    /// Scale of the orbiting circle (0.5 → 1 on appear, 0.25 on exit).
    @State var circleScale: CGFloat = 0.5
    /// Horizontal offset from center — starts at 30, expands to 130 for the orbit radius.
    @State var xOffset: CGFloat = 30
    /// Vertical offset — stays 0 during rotation, shifts to -40 on exit for upward drift.
    @State var yOffSet: CGFloat = 0
    /// Opacity — fades to 0 after the rotation completes.
    @State var opacity: Double = 1

    /// Number of full 360° rotations to perform.
    let trackerRotation: Double
    /// Total duration of the rotation phase; also used to schedule the exit animation.
    let timerInterval: TimeInterval

    // MARK: - Views
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 40)
            .offset(x: xOffset, y: yOffSet)
            .rotationEffect(rotationAngle)
            .scaleEffect(circleScale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.2)) {
                    circleScale = 1
                    xOffset = 130
                }
                withAnimation(.linear(duration: timerInterval)) {
                    rotationAngle = getRotationAngle()
                }
                Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        circleScale = 0.25
                        xOffset = 60
                        yOffSet = -40
                    }
                }
                Timer.scheduledTimer(withTimeInterval: timerInterval + 0.05, repeats: false) { _ in
                    withAnimation(.default) {
                        opacity = 0
                    }
                }
            }
    }

    // MARK: - Functions

    /// Returns the total rotation angle: `360° × trackerRotation`.
    func getRotationAngle() -> Angle {
        return .degrees(360 * trackerRotation)
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        RotatingCircle(trackerRotation: 2.4, timerInterval: 2.4 * 0.91)
    }
}
