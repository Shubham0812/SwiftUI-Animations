//
//  CircleTickShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 08/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A SwiftUI `Shape` that draws a circle with a checkmark (tick) inside it
/// as a single combined path — useful for animating both elements together
/// via `.trim()` in a download or confirmation flow.
///
/// The circle and tick are separate sub-paths within the same `Path`,
/// so `.trim(from:to:)` will draw the circle first, then the tick,
/// allowing a sequential reveal animation with no extra code.
///
/// - The circle is always centered in the bounding rect regardless of frame size.
/// - The tick scales proportionally via `scaleFactor` around the same center point.
struct CircleTickShape: Shape {
    
    // MARK: - Variables
    
    /// Diameter of the circle in points.
    /// The circle is drawn centered in the bounding rect using this value.
    var circleSize: CGFloat = 60
    
    /// Controls the size of the tick mark relative to the circle.
    /// Increase to make the tick larger; decrease to shrink it.
    /// At the default of `0.3`, the tick fits comfortably inside the 60pt circle.
    var scaleFactor: CGFloat = 0.3
    
    // MARK: - Functions
    
    func path(in rect: CGRect) -> Path {
        // Center of the bounding rect — both the circle and tick are positioned from here
        let cX = rect.midX
        let cY = rect.midY
        
        var path = Path()
        
        // Initial move to center — establishes the path's start point before the ellipse.
        // Required so the trim animation begins from the center rather than (0, 0).
        path.move(to: CGPoint(x: cX, y: cY))
        
        // ── Circle ────────────────────────────────────────────────────────────
        // Centered ellipse using `circleSize` as both width and height.
        // The rect is offset by half `circleSize` in each direction to keep it centered.
        path.addEllipse(in: CGRect(
            x: cX - (circleSize / 2),
            y: cY - (circleSize / 2),
            width: circleSize,
            height: circleSize
        ))
        
        // ── Tick (checkmark) ──────────────────────────────────────────────────
        // Three points forming a classic checkmark: short left stroke, then long right stroke.
        // All offsets are multiplied by `scaleFactor` so the tick resizes with `circleSize`.
        //
        //   start (left tip)  →  pivot (bottom of tick)  →  end (right tip)
        //         •                        •                        •
        //        /                        /
        //       /________________________/
        
        // Left tip of the tick — slightly left of center and near the vertical midpoint
        path.move(to: CGPoint(x: cX - (38 * scaleFactor), y: (cY + 2) - scaleFactor))
        
        // Pivot point — bottom-center of the tick's "V" bend
        path.addLine(to: CGPoint(x: cX - (scaleFactor * 18), y: cY + (scaleFactor * 28)))
        
        // Right tip — upper-right, completing the longer upward stroke of the checkmark
        path.addLine(to: CGPoint(x: cX + (scaleFactor * 40), y: cY - (scaleFactor * 26)))
        
        return path
    }
}

#Preview {
    CircleTickShape(circleSize: 50)
        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
}
