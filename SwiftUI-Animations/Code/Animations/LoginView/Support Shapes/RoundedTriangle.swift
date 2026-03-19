//
//  RoundedRectangle.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws an isosceles triangle with a curved apex.
///
/// The base runs along `rect.maxY` (bottom edge). Two cubic bezier curves from
/// the base corners converge at `rect.midX, rect.minY` with control points offset
/// by ±124 pt, producing a rounded, tent-like peak rather than a sharp point.
///
/// Used in `AddCartView` as the speech-bubble triangle that pops above the button
/// during the bounce animation.
struct RoundedTriangle: Shape {
    /// Constructs the rounded-apex triangle path within `rect`.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), control1: CGPoint(x: rect.midX + 124, y: rect.minY), control2: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control1: CGPoint(x: rect.midX, y: rect.minY), control2: CGPoint(x: rect.midX - 124, y: rect.minY))

        
        return path
    }
}

#Preview {
    RoundedTriangle()
}
