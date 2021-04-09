//
//  CircleTickShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 08/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

struct CircleTickShape: Shape {
    
    // MARK:- variables
    var circleSize: CGFloat = 60
    var scaleFactor: CGFloat = 0.3

    // MARK:- functions
    func path(in rect: CGRect) -> Path {
        let cX = rect.midX
        let cY = rect.midY
        
        var path = Path()
        path.move(to: CGPoint(x: cX, y: cY))
    
        /// circle
        path.addEllipse(in: CGRect(x: cX - (circleSize / 2), y: cY - (circleSize / 2), width: circleSize, height: circleSize))
        
        /// tick
        path.move(to: CGPoint(x: cX - (38 * scaleFactor), y: (cY + 2) - (scaleFactor)))
        path.addLine(to: CGPoint(x: cX - (scaleFactor * 18), y: cY + (scaleFactor * 28)))
        path.addLine(to: CGPoint(x: cX + (scaleFactor * 40), y: cY - (scaleFactor * 26)))
        
        return path
    }
}

struct CircleTickShape_Previews: PreviewProvider {
    static var previews: some View {
        CircleTickShape(circleSize: 50)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
    }
}
