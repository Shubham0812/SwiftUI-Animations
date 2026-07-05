//
//  DownloadTickShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 07/03/22.
//  Copyright © 2022 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The success checkmark drawn inside the ring once a download completes.
///
/// Because it is a `Shape`, it can be paired with `.trim(from:to:)` to animate the tick
/// drawing itself in stroke by stroke.
struct DownloadTickShape: Shape {

    /// Multiplier applied to every point so the tick can be scaled up or down as a whole.
    let scaleFactor: CGFloat

    func path(in rect: CGRect) -> Path {
        // Centre the tick slightly right and up so it sits visually balanced in the ring.
        let cX = rect.midX + 4
        let cY = rect.midY - 3

        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        // Start of the short leg (upper left).
        path.move(to: CGPoint(x: cX - (42 * scaleFactor), y: cY - (4 * scaleFactor)))
        // Down to the elbow.
        path.addLine(to: CGPoint(x: cX - (18 * scaleFactor), y: cY + (28 * scaleFactor)))
        // Up to the tip of the long leg (upper right).
        path.addLine(to: CGPoint(x: cX + (40 * scaleFactor), y: cY - (36 * scaleFactor)))
        return path
    }
}

struct DownloadTickShape_Previews: PreviewProvider {
    static var previews: some View {
        DownloadTickShape(scaleFactor: 1)
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
    }
}
