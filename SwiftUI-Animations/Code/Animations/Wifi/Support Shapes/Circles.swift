//
//  Circles.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 12/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that scatters 36 small randomly-placed circles across the upper half of the rect.
///
/// Used in the WiFi animation to create a particle/sparkle effect. Each circle has a random size
/// (2.5-7pt diameter) and random position. The circles are split into two groups of 18 -- one
/// for the left half and one for the right half -- ensuring even distribution across the width.
/// Because positions are randomized, each render produces a unique pattern.
struct Circles: Shape {

    /// Generates a path of 36 randomly-placed small circles in the upper half of the rect.
    ///
    /// The circles are drawn as rounded rects with corner radii equal to half their size,
    /// making them perfectly round. Two loops of 18 each cover the left and right halves.
    func path(in rect: CGRect) -> Path {

        var path = Path()
        path.move(to: rect.origin)
        // 18 random circles in the upper-left quadrant
        for _ in 0 ..< 18 {
            let barHeight = CGFloat.random(in: 2.5 ..< 7)
            let barRect = CGRect(x: CGFloat.random(in: rect.minX ..< rect.midX),
                                 y: CGFloat.random(in: rect.minY ..< rect.midY),
                                 width: barHeight,
                                 height: barHeight)
            path.addRoundedRect(in: barRect, cornerSize: CGSize(width: barHeight / 2, height: barHeight / 2))
        }
        for _ in 0 ..< 18 {
            let barHeight = CGFloat.random(in: 2.5 ..< 7)
            let barRect = CGRect(x: CGFloat.random(in: rect.midX ..< rect.maxX),
                                 y: CGFloat.random(in: rect.minY ..< rect.midY),
                                 width: barHeight,
                                 height: barHeight)
            path.addRoundedRect(in: barRect, cornerSize: CGSize(width: barHeight / 2, height: barHeight / 2))
        }
        return path
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        Circles()
            .fill(Color.red)
            .frame(height: 300)
    }
}
