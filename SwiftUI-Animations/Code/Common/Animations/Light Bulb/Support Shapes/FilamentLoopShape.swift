//
//  FilamentLoopShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/12/25.
//  Copyright © 2025 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The filament inside the bulb: two vertical posts joined at the bottom by a small looping
/// curve, echoing the "curly" filament of the vector artwork.
struct FilamentLoopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        let lx = w * 0.38   // Left post X.
        let rx = w * 0.62   // Right post X.
        let bottomY = h * 0.75

        // Left post dropping down.
        path.move(to: CGPoint(x: lx, y: 0))
        path.addLine(to: CGPoint(x: lx, y: bottomY))

        // The loop: dip below the posts and curl toward the center...
        path.addCurve(to: CGPoint(x: w * 0.5, y: bottomY - 10),
                      control1: CGPoint(x: lx, y: bottomY + 25),
                      control2: CGPoint(x: w * 0.45, y: bottomY + 25))

        // ...then loop back out to meet the right post.
        path.addCurve(to: CGPoint(x: rx, y: bottomY),
                      control1: CGPoint(x: w * 0.55, y: bottomY - 35),
                      control2: CGPoint(x: rx, y: bottomY + 25))

        // Right post back up to the top.
        path.addLine(to: CGPoint(x: rx, y: 0))

        return path
    }
}

#Preview {
    FilamentLoopShape()
        .stroke(lineWidth: 4)
        .padding()
}
