//
//  CircleLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A circular progress loader with a colored arc that sweeps and expands on a white background.
///
/// The animation runs in four timed phases per cycle:
/// 1. Spring: snaps the arc back to a start angle with a spring bounce
/// 2. Sweep: rotates the arc ~2 full turns (720° + 120°) via `getRotationAngle()`
/// 3. Expand: grows `circleEnd` from 0.325 to 0.925 (arc covers ¾ of the ring)
/// 4. Collapse: resets the rotation and snaps `circleEnd` back to 0.325
///
/// The outer track ring (`circleTrackGradient`) is always fully visible; the
/// colored arc (`circleRoundGradient`) trims on top of it with rounded caps.
struct CircleLoader: View {

    // MARK: - Variables

    /// Gradient used for the static background track ring.
    let circleTrackGradient = LinearGradient(gradient: .init(colors: [Color.circleTrackStart, Color.circleTrackEnd]), startPoint: .leading, endPoint: .bottomLeading)
    /// Gradient used for the animated foreground arc.
    let circleRoundGradient = LinearGradient(gradient: .init(colors: [Color.circleRoundStart, Color.circleRoundEnd]), startPoint: .topLeading, endPoint: .trailing)

    /// Number of full rotations during the sweep phase. Multiplied by 360° in `getRotationAngle()`.
    let trackerRotation: Double = 2
    /// Base duration for one animation phase. The full cycle repeats every `trackerRotation × animationDuration + animationDuration`.
    let animationDuration: Double = 0.75

    /// Fixed trim start of the arc (stays constant throughout the animation).
    @State var circleStart: CGFloat = 0.17
    /// Trim end of the arc — expands to 0.925 during the sweep, then snaps back to 0.325.
    @State var circleEnd: CGFloat = 0.325

    /// Current rotation angle of the foreground arc.
    @State var rotationDegree: Angle = .degrees(0)

    // MARK: - Views

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 20))
                    .fill(circleTrackGradient)
                Circle()
                    .trim(from: circleStart, to: circleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .fill(circleRoundGradient)
                    .rotationEffect(rotationDegree)
            }
            .frame(width: 200, height: 200)
            .onAppear {
                animateLoader()
                Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration + animationDuration, repeats: true) { _ in
                    animateLoader()
                }
            }
        }
    }

    // MARK: - Functions

    /// Returns the total rotation for the sweep phase: `trackerRotation` full turns plus an extra 120°.
    func getRotationAngle() -> Angle {
        return .degrees(360 * trackerRotation) + .degrees(120)
    }

    /// Runs one animation cycle across four staggered timer phases:
    ///
    /// - **t = 0**: Spring-snaps `rotationDegree` to –57.5° (slightly before 12 o'clock).
    /// - **t = animationDuration**: Eases the arc through `getRotationAngle()` (720° + 120°).
    /// - **t = animationDuration × 1.25**: Expands `circleEnd` to 0.925 at half the sweep duration.
    /// - **t = trackerRotation × animationDuration**: Snaps `rotationDegree` to 47.5° and
    ///   collapses `circleEnd` back to 0.325 — ready for the next cycle.
    func animateLoader() {
        withAnimation(.spring(response: animationDuration * 2)) {
            rotationDegree = .degrees(-57.5)
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(.easeInOut(duration: trackerRotation * animationDuration)) {
                rotationDegree += getRotationAngle()
            }
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            withAnimation(.easeOut(duration: (trackerRotation * animationDuration) / 2.25)) {
                circleEnd = 0.925
            }
        }

        Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration, repeats: false) { _ in
            rotationDegree = .degrees(47.5)
            withAnimation(.easeOut(duration: animationDuration)) {
                circleEnd = 0.325
            }
        }
    }
}

#Preview {
    CircleLoader()
}
