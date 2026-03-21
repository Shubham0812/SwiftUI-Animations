//
//  TriangleShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 14/09/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws an isosceles triangle, used as the base shape for the TriangleLoader animation.
///
/// The triangle has its apex at the top-center and a flat base at 85% of the rect's height.
/// The path is drawn twice (likely a copy-paste artifact) but this has no visual effect since
/// both sub-paths are identical. When stroked with `trim(from:to:)` animation, this creates
/// a drawing/undrawing effect for the loader.
struct TriangleShape: Shape {

    /// Draws the triangle path within the bounding rect.
    ///
    /// Vertices are placed at top-center (apex), bottom-left, and bottom-right, with the base
    /// at 85% of the rect's height. The path is traced twice for the full triangle outline.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Move to the top-center point (apex of the triangle)
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        // Draw line to the bottom-left corner (at 85% of the rect's height)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        // Draw line to the bottom-right corner (at 85% of the rect's height)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        // Close the triangle back to the apex
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        // Note: The path is drawn twice below — this is redundant and can be removed
        // without any visual difference. Likely a copy-paste artifact.
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

#Preview {
    TriangleShape()
}
