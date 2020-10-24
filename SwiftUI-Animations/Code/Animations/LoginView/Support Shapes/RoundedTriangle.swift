//
//  RoundedRectangle.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct RoundedTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), control1: CGPoint(x: rect.midX + 124, y: rect.minY), control2: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control1: CGPoint(x: rect.midX, y: rect.minY), control2: CGPoint(x: rect.midX - 124, y: rect.minY))

        
        return path
    }
}

struct RounedTriangle_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTriangle()
    }
}
