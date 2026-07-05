//
//  CurvedSlider.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/12/25.
//  Copyright © 2025 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An arc-shaped brightness slider. A knob rides along a semicircular track; dragging it
/// left-to-right maps to a `0...1` value.
///
/// The arc sweeps from `startAngle` (left) clockwise across the bottom to `endAngle` (right),
/// crossing the 0°/360° boundary — hence the angle bookkeeping in `angleForValue(_:)` and
/// `updateValue(location:center:)`.
struct CurvedSlider: View {

    // MARK: - Variables

    /// The current brightness, `0.0` (left end) to `1.0` (right end).
    @Binding var value: Double

    /// Radius of the arc the knob travels along.
    private let radius: CGFloat = 140

    /// Angle (degrees) of the left end of the arc. `0°` points right, angles increase clockwise.
    private let startAngle: Double = 160

    /// Angle (degrees) of the right end of the arc, reached after crossing 360°.
    private let endAngle: Double = 20

    // MARK: - Views
    var body: some View {
        GeometryReader { geometry in
            // Anchor the arc's center at the bottom-center so it bows upward.
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height)

            ZStack {
                // 1. The track — a translucent white arc.
                Path { path in
                    path.addArc(center: center,
                                radius: radius,
                                startAngle: .degrees(startAngle),
                                endAngle: .degrees(endAngle),
                                clockwise: false)
                }
                .stroke(Color.white.opacity(0.5), style: StrokeStyle(lineWidth: 6, lineCap: .round))

                // 2. The knob — positioned along the arc for the current value and draggable.
                let angle = angleForValue(value)
                let rads = Angle.degrees(angle).radians
                let x = center.x + radius * CGFloat(cos(rads))
                let y = center.y + radius * CGFloat(sin(rads))

                Circle()
                    .fill(Color.clear)
                    .frame(width: 25, height: 25)
                    .glassKnob()
                    .overlay(Circle().stroke(Color.yellow.opacity(0.1), lineWidth: 2))
                    .position(x: x, y: y)
                    .gesture(
                        DragGesture()
                            .onChanged { drag in
                                updateValue(location: drag.location, center: center)
                            }
                    )

                // 3. Sun icons bookending the arc for visual flair.
                Image(systemName: "sun.min.fill")
                    .foregroundColor(.white)
                    .position(x: center.x - radius - 20, y: center.y - 10)
                    .opacity(0.8)

                Image(systemName: "sun.max.fill")
                    .foregroundColor(.white)
                    .position(x: center.x + radius + 20, y: center.y - 10)
                    .opacity(0.8)
            }
        }
    }

    // MARK: - Functions

    /// Maps a `0...1` value to a point on the arc, in degrees.
    /// `0.0` sits at `startAngle` (left) and `1.0` at `startAngle + span` (right, past 360°).
    private func angleForValue(_ val: Double) -> Double {
        let totalAngleSpan = (360 - startAngle) + endAngle
        return startAngle + (totalAngleSpan * val)
    }

    /// Converts a drag location into a new `0...1` value by measuring its angle around `center`.
    private func updateValue(location: CGPoint, center: CGPoint) {
        // Angle of the touch relative to the arc's center, normalized to 0...2π.
        let vector = CGVector(dx: location.x - center.x, dy: location.y - center.y)
        var angleRadians = atan2(vector.dy, vector.dx)
        if angleRadians < 0 { angleRadians += 2 * .pi }

        var angleDegrees = angleRadians * 180 / .pi

        // Shift the right-hand portion past 360° so the arc is one continuous 160°...380° range.
        if angleDegrees < 90 { angleDegrees += 360 }

        let start = startAngle
        let end = 360 + endAngle   // 380°

        // Clamp to the arc's ends so the knob can't jump off the track.
        angleDegrees = min(max(angleDegrees, start), end)

        // Map the clamped angle back into 0...1.
        let newValue = (angleDegrees - start) / (end - start)

        withAnimation(.interactiveSpring(duration: 0.3, extraBounce: 0, blendDuration: 0.5)) {
            value = newValue
        }
    }
}

/// Applies a circular Liquid Glass surface to the knob on iOS 26+, falling back to a
/// material-backed circle on earlier systems (where `glassEffect` is unavailable).
private extension View {
    @ViewBuilder func glassKnob() -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(.regular, in: .circle)
        } else {
            background(.ultraThinMaterial, in: Circle())
        }
    }
}

#Preview {
    CurvedSlider(value: .constant(0.5))
        .frame(width: 320, height: 160)
        .background(Color.yellow)
}
