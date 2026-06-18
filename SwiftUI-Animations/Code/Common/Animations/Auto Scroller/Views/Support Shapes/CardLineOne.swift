//
//  CardLineOne.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Two thick, rounded bezier strokes used as a flowing decorative accent on the
/// metal and purple card faces.
struct CardLineOne: View {

    // MARK: - variables
    @State var lineStrokeOne: CGFloat = 1
    @State var lineStrokeTwo: CGFloat = 1

    var colorOne: Color = Color(hex: "#FDADAC")
    var colorTwo: Color = Color(hex: "#8D79F6")

    // MARK: - views
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 454, y: 308.46))
                path.addCurve(to: CGPoint(x: -133.07, y: 308.46), control1: CGPoint(x: 103.46, y: 629.48), control2: CGPoint(x: 43.99, y: 137.39))
            }
            .stroke(style: StrokeStyle(lineWidth: 100, lineCap: .round))
            .trim(from: 0, to: lineStrokeOne)
            .foregroundColor(colorOne)

            Path { path in
                path.move(to: CGPoint(x: 454, y: 420))
                path.addCurve(to: CGPoint(x: -133.07, y: 490.46), control1: CGPoint(x: 103.46, y: 679.48), control2: CGPoint(x: 43.99, y: 137.39))
            }
            .stroke(style: StrokeStyle(lineWidth: 80, lineCap: .round))
            .trim(from: 0, to: lineStrokeTwo)
            .foregroundColor(colorTwo)
        }
    }
}

#Preview {
    CardLineOne()
}
