//
//  SpinningView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/03/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Keyframe rotation angles used during the spinner animation.
///
/// Angles are expressed in degrees > 360 deliberately — SwiftUI interpolates
/// through the full rotation rather than taking the shortest path, which is
/// what produces the continuous sweeping motion rather than a snap or reverse.
enum RotationDegrees {

    // ── Large arc keyframes ───────────────────────────────────────────────────
    case initialCicle      // End of Phase 1 rotation for the large arc
    case middleCircle      // Mid-cycle nudge position for the large arc

    // ── Small arc keyframes ───────────────────────────────────────────────────
    case initialSmallCircle   // End of Phase 1 rotation for the small arc
    case middleSmallCircle    // Mid-cycle nudge position for the small arc

    // ── Shared final keyframe ─────────────────────────────────────────────────
    case last  // Both arcs rotate to this angle in Phase 3, creating the handoff effect

    func getRotationDegrees() -> Angle {
        switch self {
        case .initialCicle:
            return .degrees(365)
        case .initialSmallCircle:
            return .degrees(679)
        case .middleCircle:
            return .degrees(375)
        case .middleSmallCircle:
            return .degrees(825)
        case .last:
            return .degrees(990)
        }
    }
}

/// An animated spinner consisting of two arcs — a large outer circle and a small inner circle —
/// that take turns expanding and collapsing in a looping sequence.
///
/// **Animation choreography (one cycle = `animationDuration * 1.98`):**
/// ```
/// t = 0              Large arc expands (0→1) + rotates to initialCircle
///                    Small arc collapses (1→0) + rotates to initialSmallCircle
///
/// t = duration×0.7   Both arcs nudge rotation (middleCircle / middleSmallCircle)
///
/// t = duration×1.0   Large arc collapses (1→0) + rotates to last
///                    Small arc expands (0→1)    + rotates to last
///
/// t = duration×1.98  reset() snaps both rotations back to their start angles (no animation),
///                    then animate() fires again for the next loop
/// ```
struct SpinningView: View {

    // MARK: - Variables

    // ── Large circle state ────────────────────────────────────────────────────
    @State var circleEnd: CGFloat = 0.001
    @State var rotationDegree: Angle = .degrees(-90)

    // ── Small circle state ────────────────────────────────────────────────────
    @State var smallerCircleEnd: CGFloat = 1
    @State var smallerRotationDegree: Angle = .degrees(-30)

    // ── Timing constants ──────────────────────────────────────────────────────
    let animationDuration: Double = 1.35

    // MARK: - Views

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            ZStack {
                Circle()
                    .trim(from: 0, to: circleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .rotationEffect(rotationDegree)
                    .frame(width: 130, height: 130)

                Circle()
                    .trim(from: 0, to: smallerCircleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .opacity(0.9)
                    .rotationEffect(smallerRotationDegree)
                    .frame(width: 48, height: 48)
            }
            .offset(y: -72)
            .onAppear {
                animate()
                Timer.scheduledTimer(withTimeInterval: animationDuration * 1.98, repeats: true) { _ in
                    reset()
                    animate()
                }
            }
        }
    }

    // MARK: - Functions

    /// Runs one full animation cycle across three timed phases.
    func animate() {
        withAnimation(.easeOut(duration: animationDuration)) {
            circleEnd = 1
        }
        withAnimation(.easeOut(duration: animationDuration * 1.1)) {
            rotationDegree = RotationDegrees.initialCicle.getRotationDegrees()
        }

        withAnimation(.easeOut(duration: animationDuration * 0.85)) {
            smallerCircleEnd = 0.001
            smallerRotationDegree = RotationDegrees.initialSmallCircle.getRotationDegrees()
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration * 0.7, repeats: false) { _ in
            withAnimation(.easeIn(duration: animationDuration * 0.4)) {
                smallerRotationDegree = RotationDegrees.middleSmallCircle.getRotationDegrees()
                rotationDegree = RotationDegrees.middleCircle.getRotationDegrees()
            }
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(.easeOut(duration: animationDuration)) {
                rotationDegree = RotationDegrees.last.getRotationDegrees()
                circleEnd = 0.001
            }
            withAnimation(.linear(duration: animationDuration * 0.8)) {
                smallerCircleEnd = 1
                smallerRotationDegree = RotationDegrees.last.getRotationDegrees()
            }
        }
    }

    /// Snaps both arcs back to their initial rotation angles without animation.
    func reset() {
        rotationDegree = .degrees(-90)
        smallerRotationDegree = .degrees(-30)
    }
}

#Preview {
    SpinningView()
}
