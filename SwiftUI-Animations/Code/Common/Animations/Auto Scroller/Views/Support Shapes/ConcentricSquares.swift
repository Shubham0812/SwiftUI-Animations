//
//  ConcentricSquares.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A set of nested squares, each inset further than the last. Used as a subtle
/// stroked texture on the metal and purple card faces.
struct ConcentricSquares: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let count = 16
        let shrinkFactor = 0.125

        for i in 0..<count {
            let inset = CGFloat(i) * rect.width * shrinkFactor
            let square = CGRect(
                x: inset,
                y: inset,
                width: rect.width - 2 * inset,
                height: rect.height - 2 * inset
            )
            path.addRect(square)
        }
        return path
    }
}
