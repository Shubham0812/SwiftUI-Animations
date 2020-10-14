//
//  OctocatShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 14/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct OctocatShape: Shape {
    
    // MARK:- variables
    
    // MARK:- functions
    func path(in rect: CGRect) -> Path {
        
        ///phew, had to do a lot of hit and trials for this xD
        var path = Path()
        path.move(to: CGPoint(x: 243.77, y: 483.38))
        
        // right side
        path.addLine(to: CGPoint(x: 243.77, y: 441.77))
        path.addLine(to: CGPoint(x: 243.79, y: 441.46))
        
        path.addCurve(to: CGPoint(x: 233.25, y: 413.32), control1: CGPoint(x: 244.53, y: 431), control2: CGPoint(x: 240.68, y: 420.73))
        path.addCurve(to: CGPoint(x: 303, y: 338.47), control1: CGPoint(x: 267.46, y: 409.95), control2: CGPoint(x: 303, y: 397.16))
        path.addLine(to: CGPoint(x: 303, y: 338.48))
        path.addCurve(to: CGPoint(x: 286.56, y: 297.86), control1: CGPoint(x: 303, y: 323.32), control2: CGPoint(x: 297.11, y: 308.76))
        path.addLine(to: CGPoint(x: 287, y: 297.74))
        path.addCurve(to: CGPoint(x: 285.57, y: 256.94), control1: CGPoint(x: 291.84, y: 284.47), control2: CGPoint(x: 291.33, y: 269.84))
        path.addCurve(to: CGPoint(x: 243.77, y: 273.54), control1: CGPoint(x: 285.88, y: 257.63), control2: CGPoint(x: 273.17, y: 253.87))
        
        // center
        path.addLine(to: CGPoint(x: 243.37, y: 273.43))
        path.addCurve(to: CGPoint(x: 168.78, y: 273.43), control1: CGPoint(x: 218.94, y: 266.9), control2: CGPoint(x: 193.21, y: 266.9))
        
        // leftSide
        path.addCurve(to: CGPoint(x: 126.28, y: 257.63), control1: CGPoint(x: 138.98, y: 253.87), control2: CGPoint(x: 126.28, y: 257.63))
        path.addLine(to: CGPoint(x: 126.2, y: 257.81))
        path.addCurve(to: CGPoint(x: 125.49, y: 298.63), control1: CGPoint(x: 120.67, y: 270.81), control2: CGPoint(x: 120.42, y: 285.45))
        path.addLine(to: CGPoint(x: 125.6, y: 297.86))
        path.addCurve(to: CGPoint(x: 109.15, y: 338.48), control1: CGPoint(x: 115.05, y: 308.76), control2: CGPoint(x: 109.15, y: 323.33))
        
        path.addCurve(to: CGPoint(x: 178.51, y: 414.04), control1: CGPoint(x: 109.15, y: 397.06), control2: CGPoint(x: 144.69, y: 409.85))
        path.addLine(to: CGPoint(x: 178.48, y: 414.07))
        path.addCurve(to: CGPoint(x: 168.38, y: 441.76), control1: CGPoint(x: 171.34, y: 421.45), control2: CGPoint(x: 167.67, y: 431.52))
        path.addLine(to: CGPoint(x: 168.38, y: 483.38))
        
        // tail
        path.move(to: CGPoint(x: 168.38, y: 451.13))
        path.addCurve(to: CGPoint(x: 93, y: 418.88), control1: CGPoint(x: 114.54, y: 467.25), control2: CGPoint(x: 114.54, y: 424.25))
        return path
    }
}

struct OctocatShape_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            OctocatShape()
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 8))
                .foregroundColor(Color.white)
        }
    }
}
