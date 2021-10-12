//
//  OctoHead.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 12/10/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

struct OctoHead: Shape {
    
    // MARK:- functions
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX
        let cY: CGFloat = rect.midY
        
        var path = Path()
        
        path.move(to: CGPoint(x: cX + -41.87, y: cY + -63.23))
        path.addCurve(to: CGPoint(x: cX + 43.23, y: cY + -63.46), control1: CGPoint(x: cX + -7.92, y: cY + -60.68), control2: CGPoint(x: cX + 7.6, y: cY + -60.73))
        path.addCurve(to: CGPoint(x: cX + 87.78, y: cY + -63.5), control1: CGPoint(x: cX + 57.7, y: cY + -64.55), control2: CGPoint(x: cX + 81.18, y: cY + -64.59))
        path.addCurve(to: CGPoint(x: cX + 122, y: cY + -46.71), control1: CGPoint(x: cX + 103.39, y: cY + -61), control2: CGPoint(x: cX + 112.85, y: cY + -56.31))
        path.addLine(to: CGPoint(x: cX + 122.28, y: cY + -46.42))
        path.addCurve(to: CGPoint(x: cX + 139.09, y: cY + -14.8), control1: CGPoint(x: cX + 130.74, y: cY + -37.66), control2: CGPoint(x: cX + 136.56, y: cY + -26.71))
        path.addCurve(to: CGPoint(x: cX + 139.75, y: cY + 13.04), control1: CGPoint(x: cX + 140.43, y: cY + -8.71), control2: CGPoint(x: cX + 140.7, y: cY + 4.67))
        path.addCurve(to: CGPoint(x: cX + 119.68, y: cY + 58.59), control1: CGPoint(x: cX + 137.38, y: cY + 33.15), control2: CGPoint(x: cX + 131.33, y: cY + 46.94))
        path.addCurve(to: CGPoint(x: cX + 46.64, y: cY + 85.85), control1: CGPoint(x: cX + 104.53, y: cY + 73.75), control2: CGPoint(x: cX + 81.32, y: cY + 82.44))
        path.addCurve(to: CGPoint(x: cX + -0, y: cY + 87.63), control1: CGPoint(x: cX + 32.08, y: cY + 87.31), control2: CGPoint(x: cX + 23.53, y: cY + 87.63))
        path.addCurve(to: CGPoint(x: cX + -47.87, y: cY + 85.85), control1: CGPoint(x: cX + -23.71, y: cY + 87.63), control2: CGPoint(x: cX + -33.54, y: cY + 87.26))
        path.addCurve(to: CGPoint(x: cX + -141.76, y: cY + 12.5), control1: CGPoint(x: cX + -108.09, y: cY + 79.8), control2: CGPoint(x: cX + -136.94, y: cY + 57.27))
        path.addCurve(to: CGPoint(x: cX + -140.94, y: cY + -15.4), control1: CGPoint(x: cX + -142.58, y: cY + 5.04), control2: CGPoint(x: cX + -142.12, y: cY + -10.34))
        path.addLine(to: CGPoint(x: cX + -140.89, y: cY + -15.61))
        path.addCurve(to: CGPoint(x: cX + -131.37, y: cY + -37.52), control1: CGPoint(x: cX + -139.09, y: cY + -23.44), control2: CGPoint(x: cX + -135.86, y: cY + -30.86))
        path.addCurve(to: CGPoint(x: cX + -113.96, y: cY + -55.13), control1: CGPoint(x: cX + -127.56, y: cY + -43.34), control2: CGPoint(x: cX + -118.87, y: cY + -52.13))
        path.addCurve(to: CGPoint(x: cX + -87.24, y: cY + -63.82), control1: CGPoint(x: cX + -106.72, y: cY + -59.59), control2: CGPoint(x: cX + -97.85, y: cY + -62.5))
        path.addCurve(to: CGPoint(x: cX + -41.87, y: cY + -63.23), control1: CGPoint(x: cX + -80.1, y: cY + -64.73), control2: CGPoint(x: cX + -58.35, y: cY + -64.46))
        path.addLine(to: CGPoint(x: cX + -41.87, y: cY + -63.23))

        path.closeSubpath()
        return path
    }
}

struct OctoHead_Previews: PreviewProvider {
    static var previews: some View {
        OctoHead()
            .stroke(lineWidth: 12)
    }
}
