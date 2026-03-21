//
//  BookHold.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 15/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom `Shape` that draws the book spine — a shallow U-shaped path
/// used as the central hinge in `BookLoaderView`.
///
/// The path is an open three-sided rectangle (no top edge): left vertical,
/// horizontal bottom, right vertical. Rendered with a rounded stroke, it
/// resembles the bottom binding of an open book held flat.
struct BookHoldView: Shape {

    // MARK: - Functions

    /// Draws the spine path centered in `rect`.
    ///
    /// Origin is offset 28 pt left of center so the spine visually aligns
    /// between the two cover capsules. The U spans 56 pt wide and 12 pt tall.
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX - 28
        let cY: CGFloat = rect.midY

        var path = Path()
        path.move(to: CGPoint(x: cX, y: cY))
        path.addLine(to: CGPoint(x: cX, y: cY + 12))
        path.addLine(to: CGPoint(x: cX + 56, y: cY + 12))
        path.addLine(to: CGPoint(x: cX + 56, y: cY))
        return path
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        BookHoldView()
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .miter))
            .foregroundStyle(.white)
        Capsule()
            .frame(width: 5)
            .foregroundStyle(.white)
    }
}
