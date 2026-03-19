//
//  Tick.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 06/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws a checkmark (tick) symbol, used in the Cart animation
/// to indicate a completed action (e.g., item added to cart).
///
/// The tick is drawn as two connected line segments forming a "V" shape tilted to resemble
/// a standard checkmark. All coordinates are scaled by `scaleFactor` so the tick can be
/// resized proportionally.
struct Tick: Shape {
    /// Controls the overall size of the checkmark. A value of 1.0 produces the default size;
    /// smaller values shrink the tick, larger values enlarge it.
    let scaleFactor: CGFloat

    /// Draws the checkmark path as two line segments.
    ///
    /// The path traces: top-left arm down to the bottom vertex, then up to the top-right arm,
    /// forming the familiar checkmark "V" shape. The center point (cX, cY) is offset slightly
    /// from the rect's center to visually balance the asymmetric tick shape.
    func path(in rect: CGRect) -> Path {
        let cX = rect.midX + 4
        let cY = rect.midY - 3

        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.move(to: CGPoint(x: cX - (42 * scaleFactor), y: cY - (4 * scaleFactor)))
        path.addLine(to: CGPoint(x: cX - (scaleFactor * 18), y: cY + (scaleFactor * 28)))
        path.addLine(to: CGPoint(x: cX + (scaleFactor * 40), y: cY - (scaleFactor * 36)))
        return path
    }
}

#Preview {
    Tick(scaleFactor: 1)
}
