//
//  Arc.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws a single arc segment, used to represent one band of a WiFi signal icon.
///
/// The arc is drawn as a 100-degree sweep (from 220 to 320 degrees) centered at the rect's midpoint,
/// spanning the upper portion like a WiFi signal wave. Multiple `ArcShape` instances with increasing
/// radii can be stacked to create the full WiFi indicator.
struct ArcShape : Shape {
    /// The radius of the arc, controlling how far from center this signal band appears.
    /// Larger values place the arc further out, representing stronger signal rings.
    var radius: CGFloat

    /// Draws a rounded arc segment centered in the rect.
    ///
    /// The arc sweeps counter-clockwise from 220 to 320 degrees (a 100-degree span pointing upward),
    /// then converts the arc into a stroked path with rounded line caps for a smooth appearance.
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: self.radius, startAngle: .degrees(220), endAngle: .degrees(320), clockwise: false)
        // Convert the arc outline into a filled shape with rounded ends
        return p.strokedPath(.init(lineWidth: 6, lineCap: .round))
    }
}
