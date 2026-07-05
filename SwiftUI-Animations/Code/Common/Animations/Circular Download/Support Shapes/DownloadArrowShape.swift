//
//  DownloadArrowShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 07/03/22.
//  Copyright © 2022 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The downward-pointing arrow at the centre of `CircularDownloadView`.
///
/// It is built from a vertical shaft plus two diagonal head strokes. Two animatable
/// inputs let it morph on tap:
/// - `animatableX` pinches the two head strokes inward so the arrowhead narrows into a droplet.
/// - `lineDifference` extends the shaft downward so the arrow stretches as it "falls".
struct DownloadArrowShape: Shape {

    // MARK: - Variables

    /// Base height of the arrow, used to size the shaft and head.
    let lineWidth: CGFloat

    /// Horizontal pinch of the arrowhead. Larger values pull the head strokes toward the centre.
    var animatableX: CGFloat = 0

    /// Extra length added to the top of the shaft, stretching the arrow downward.
    var lineDifference: CGFloat = 0

    /// Animate the two morph inputs together so tap transitions interpolate smoothly.
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(animatableX, lineDifference) }
        set {
            animatableX = newValue.first
            lineDifference = newValue.second
        }
    }

    // MARK: - Functions
    func path(in rect: CGRect) -> Path {
        let cX = rect.midX
        let cY = rect.midY

        var path = Path()
        // Shaft: top point (stretched by `lineDifference`) down to the base.
        path.move(to: CGPoint(x: cX, y: cY - lineWidth / 2 + lineDifference))
        path.addLine(to: CGPoint(x: cX, y: cY + lineWidth / 2))
        // Left head stroke, pulled inward by `animatableX`.
        path.addLine(to: CGPoint(x: cX - lineWidth / 3 + animatableX, y: cY - 45 + lineWidth / 2 + animatableX))
        // Right head stroke, mirrored.
        path.move(to: CGPoint(x: cX, y: cY + lineWidth / 2))
        path.addLine(to: CGPoint(x: cX + lineWidth / 3 - animatableX, y: cY - 45 + lineWidth / 2 + animatableX))

        return path
    }
}

struct DownloadArrowShape_Previews: PreviewProvider {
    static var previews: some View {
        DownloadArrowShape(lineWidth: 100)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
    }
}
