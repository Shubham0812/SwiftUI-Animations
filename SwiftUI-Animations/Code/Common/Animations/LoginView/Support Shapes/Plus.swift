//
//  Plus.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 16/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws a `+` symbol as two crossing line segments.
///
/// The cross is centered in `rect` with arms extending ±16 pt from center.
/// Rendered with a round-capped stroke it becomes a clean `+` icon.
/// Used in `ShrinkingPlus` as decorative particles in `LoginView`.
struct Plus: Shape {

    /// Constructs two perpendicular lines (vertical and horizontal) crossing at `rect.mid`.
    func path(in rect: CGRect) -> Path {

        let cX: CGFloat = rect.midX
        let cY: CGFloat = rect.midY
        
        var path = Path()
        
        path.move(to: CGPoint(x: cX, y: cY + -16))
        path.addLine(to: CGPoint(x: cX, y: cY + 16))
        path.move(to: CGPoint(x: cX + -16, y: cY))
        path.addLine(to: CGPoint(x: cX + 16, y: cY))
        return path
    }
    
    
}

#Preview {
    Plus()
        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
}
