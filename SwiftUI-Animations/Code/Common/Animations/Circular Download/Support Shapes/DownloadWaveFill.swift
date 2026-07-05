//
//  DownloadWaveFill.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 07/03/22.
//  Copyright © 2022 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A sine-wave shape used as the "liquid" fill inside `CircularDownloadView`.
///
/// The bottom of the shape extends well past the frame so that, when masked to a circle
/// and offset vertically, only a rising water-like surface with a rippling top edge is visible.
struct DownloadWaveFill: Shape {

    // MARK: - Variables

    /// Horizontal phase of the wave. Advancing this over time makes the surface ripple.
    var curve: CGFloat

    /// Amplitude of the ripple — how tall the crests and troughs are.
    let curveHeight: CGFloat

    /// Frequency of the ripple — how many crests span the width.
    let curveLength: CGFloat

    // MARK: - Functions
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Anchor the shape's base below the visible frame so the fill reads as solid liquid.
        path.move(to: CGPoint(x: rect.width, y: rect.height * 2))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 2))

        // Trace the rippling surface across the width using a sine curve.
        for x in stride(from: 0, to: CGFloat(rect.width), by: 1) {
            let y = sin(((x / rect.height) + curve) * curveLength * .pi) * curveHeight + rect.midY
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 2))
        return path
    }
}

struct DownloadWaveFill_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWaveFill(curve: 1, curveHeight: 4, curveLength: 3)
            .fill(Color.orange.opacity(0.5))
            .frame(width: 200, height: 100)
    }
}
