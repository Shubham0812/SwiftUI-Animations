//
//  BulbSilhouette.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/12/25.
//  Copyright © 2025 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The outline of the bulb's glass body — a rounded balloon that narrows to a straight neck
/// at the top. Built from four curves plus the two neck edges, all sized as fractions of `rect`.
struct BulbSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        // Start at the top-right of the neck.
        path.move(to: CGPoint(x: w * 0.68, y: 0))

        // Right shoulder: a short straight drop, then bulge out to the widest point.
        path.addLine(to: CGPoint(x: w * 0.68, y: h * 0.1))
        path.addCurve(to: CGPoint(x: w, y: h * 0.6),
                      control1: CGPoint(x: w * 0.72, y: h * 0.25),
                      control2: CGPoint(x: w, y: h * 0.35))

        // Rounded bottom sweeping across to the left side.
        path.addCurve(to: CGPoint(x: 0, y: h * 0.6),
                      control1: CGPoint(x: w, y: h * 1.05),
                      control2: CGPoint(x: 0, y: h * 1.05))

        // Left shoulder curving back up to the neck.
        path.addCurve(to: CGPoint(x: w * 0.32, y: h * 0.1),
                      control1: CGPoint(x: 0, y: h * 0.35),
                      control2: CGPoint(x: w * 0.28, y: h * 0.25))

        // Left neck edge back up to the top.
        path.addLine(to: CGPoint(x: w * 0.32, y: 0))

        path.closeSubpath()
        return path
    }
}

#Preview {
    BulbSilhouette()
        .stroke(lineWidth: 5)
        .padding()
}
