//
//  CardPatternOneView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A decorative `Shape` that draws a single cubic bezier swoosh used as a subtle overlay on `CardFrontView`.
///
/// The curve starts at `(cX−140, cY)`, arcs up through a top-left control point at `(cX+10, cY−150)`,
/// and lands at `(cX+160, cY+150)` — creating a shallow S-curve. Applied at 0.075 opacity,
/// rotated −27.5°, and scaled 1.4× to extend beyond the card bounds as a background texture.
struct CardPatternOneView: Shape {

    /// Constructs the single closed bezier curve relative to the center of `rect`.
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX
        let cY: CGFloat = rect.midY

        var path = Path()
        path.move(to: CGPoint(x: cX - 140, y: cY))
        path.addCurve(to: CGPoint(x: cX + 160, y: cY + 150), control1: CGPoint(x: cX + 10, y: cY - 150), control2: CGPoint(x: cX + 150, y: cY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CardPatternOneView()
}
