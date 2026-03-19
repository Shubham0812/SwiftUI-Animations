//
//  WaveFill.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws a filled sine-wave surface, simulating liquid rising
/// inside the pill loader container.
///
/// The path starts at the bottom-right, traces a horizontal baseline at 2× `rect.height`
/// (well below the visible frame), then draws a pixel-by-pixel sine wave across the width,
/// and closes back at the bottom-right. The filled region below the wave produces the
/// liquid-fill effect when masked to the pill capsule.
///
/// Animating `curve` over time shifts the sine wave horizontally, making the surface undulate.
struct WaveFill: Shape {

    // MARK: - Variables

    /// Phase offset of the sine wave. Incrementing this value over time causes the
    /// wave to scroll horizontally, simulating a liquid surface in motion.
    var curve: CGFloat
    /// Amplitude of the wave in points — larger values produce taller ripples.
    let curveHeight: CGFloat
    /// Frequency multiplier for the sine function. Values > 1 compress the wave
    /// (more peaks per unit width); values < 1 stretch it.
    let curveLength: CGFloat

    // MARK: - Functions

    /// Constructs the wave path pixel by pixel across the full width of `rect`.
    ///
    /// The formula `sin(((i / rect.height) + curve) * curveLength * π) * curveHeight + rect.midY`
    /// maps each x-coordinate `i` to a y-coordinate on the undulating surface.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width, y: rect.height * 2))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 2))

        for i in stride(from: 0, to: CGFloat(rect.width), by: 1) {
            path.addLine(to: CGPoint(x: i, y: sin(((i / rect.height) + curve) * curveLength * .pi) * curveHeight + rect.midY))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 2))
        return path
    }
}

#Preview {
    WaveFill(curve: 1, curveHeight: 4, curveLength: 3)
        .fill(Color.orange.opacity(0.5))
        .opacity(0.5)
        .frame(width: 200, height: 100)
        .offset(y: 140)
}
