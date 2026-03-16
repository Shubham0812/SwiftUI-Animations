//
//  TriangleShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 14/09/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

// A custom Shape that draws a triangle within a given rectangle.
struct TriangleShape: Shape {
    
    // Required by the Shape protocol — defines the triangle's path within the bounding rect.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Move to the top-center point (apex of the triangle)
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        // Draw line to the bottom-left corner (at 85% of the rect's height)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        // Draw line to the bottom-right corner (at 85% of the rect's height)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        // Close the triangle back to the apex
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        // Note: The path is drawn twice below — this is redundant and can be removed
        // without any visual difference. Likely a copy-paste artifact.
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

#Preview {
    TriangleShape()
}
