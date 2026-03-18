//
//  Triangle.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 06/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws an isosceles triangle, used in the Cart animation
/// as a decorative or indicator element.
///
/// The triangle has its apex at the top-center of the rect and a flat base at 85%
/// of the rect's height. This slight raise of the base above the bottom edge
/// keeps the triangle visually centered within its frame.
struct Triangle: Shape {
    /// Draws a triangle path with three vertices: top-center apex and two base corners.
    ///
    /// The base sits at 85% of the rect's height rather than the full bottom edge,
    /// giving the triangle a slightly elevated appearance within its bounding rect.
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Apex at top-center
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        // Bottom-left corner at 85% height
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        // Bottom-right corner at 85% height
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        // Close back to apex
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle()
    }
}
