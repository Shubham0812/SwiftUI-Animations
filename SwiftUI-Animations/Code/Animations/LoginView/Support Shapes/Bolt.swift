//
//  Bolt.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws a lightning bolt (⚡) using absolute coordinates.
///
/// The bolt is drawn with `addLine` points in a small absolute coordinate space
/// (~175–241 x, ~327–401 y). It is displayed scaled up 2× in `LoginView` with
/// a gradient fill that draws in progressively via `.trim(from:to:)`.
///
/// Note: The path uses absolute points rather than `rect`-relative calculations.
/// When used in layouts, apply `.scale()` to fit the desired frame.
struct Bolt: Shape {

    /// Constructs the lightning bolt as a seven-point polyline in absolute coordinates.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 211.67, y: 327.33))
        path.addLine(to: CGPoint(x: 175, y: 371.33))
        path.addLine(to: CGPoint(x: 208, y: 371.33))
        
        path.addLine(to: CGPoint(x: 204.33, y: 400.67))
        path.addLine(to: CGPoint(x: 241, y: 356.67))
        
        path.addLine(to: CGPoint(x: 208, y: 356.67))
        path.addLine(to: CGPoint(x: 211.67, y: 327.33))
        return path
    }
}

struct Bolt_Previews: PreviewProvider {
    static var previews: some View {
        Bolt()
    }
}
