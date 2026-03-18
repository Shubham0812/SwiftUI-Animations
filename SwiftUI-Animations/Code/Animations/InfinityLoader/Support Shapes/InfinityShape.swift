//
//  InfinityShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 03/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws an infinity symbol (lemniscate) using four cubic Bezier curves.
///
/// The shape is constructed from two mirrored lobes centered on the rect's midpoint.
/// Each lobe is drawn with two cubic Bezier curves that cross at the center,
/// forming the characteristic figure-eight. The path spans 200pt wide and 144pt tall
/// relative to the rect's center, with control points extending 200pt outward to
/// create smooth, rounded lobes.
struct InfinityShape: Shape {

    // MARK:- functions
    /// Constructs the infinity symbol path using four cubic Bezier curves.
    ///
    /// The drawing starts at the bottom of the left lobe and traces:
    /// 1. Left lobe: bottom-left up to top-left (curving outward left)
    /// 2. Crossover: top-left across to bottom-right (crossing through center)
    /// 3. Right lobe: bottom-right up to top-right (curving outward right)
    /// 4. Crossover: top-right back to bottom-left (crossing through center to close)
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Start at the bottom of the left lobe
        path.move(to: CGPoint(x: rect.midX - 100, y: rect.midY + 72))
        
        // Left lobe: curve from bottom-left to top-left, bulging outward to the left
        path.addCurve(to: CGPoint(x: rect.midX - 100, y: rect.midY - 72), control1: CGPoint(x: rect.midX - 200, y: rect.midY + 72), control2: CGPoint(x: rect.midX - 200, y: rect.midY - 72))
        // Crossover: curve from top-left to bottom-right, crossing through the center
        path.addCurve(to: CGPoint(x: rect.midX + 100, y: rect.midY + 72), control1: CGPoint(x: rect.midX , y: rect.midY - 72), control2: CGPoint(x: rect.midX, y: rect.midY + 72))
        // Right lobe: curve from bottom-right to top-right, bulging outward to the right
        path.addCurve(to: CGPoint(x: rect.midX + 100, y: rect.midY - 72), control1: CGPoint(x: rect.midX + 200, y: rect.midY + 72), control2: CGPoint(x: rect.midX + 200, y: rect.midY - 72))

        // Crossover: curve from top-right back to bottom-left, closing the figure-eight
        path.addCurve(to: CGPoint(x: rect.midX - 100, y: rect.midY + 72), control1: CGPoint(x: rect.midX, y: rect.midY - 72), control2: CGPoint(x: rect.midX , y: rect.midY + 72))
        return path
    }
}

struct InfinityShape_Previews: PreviewProvider {
    static var previews: some View {
        InfinityShape()
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
    }
}
