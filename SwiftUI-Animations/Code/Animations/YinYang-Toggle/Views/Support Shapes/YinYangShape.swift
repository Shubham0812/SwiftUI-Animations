//
//  YinYangShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 02/09/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

struct YinYangShape: Shape {
    
    // MARK: - Functions
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX
        let cY: CGFloat = rect.midY
        
        let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let fillColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        //// YinYang
        //// g1878
        //// path1366 Drawing
        let path1366Path = UIBezierPath(ovalIn: CGRect(x: cX + -46.75, y: cY + -46.3, width: 99, height: 99))
        fillColor2.setFill()
        path1366Path.fill()
        
        //// path1351 Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: cX + -0.91, y: cY + 53.13))
        bezierPath.addCurve (to: CGPoint(x: cX + -46.05, y: cY + 14.33), controlPoint1: CGPoint(x: cX + -22.35, y: cY + 52.01), controlPoint2: CGPoint(x: cX + -41.66, y: cY + 35.31))
        bezierPath.addCurve (to: CGPoint(x: cX + -30.04, y: cY + -34.18), controlPoint1: CGPoint(x: cX + -50.1, y: cY + -3.17), controlPoint2: CGPoint(x: cX + -43.76, y: cY + -22.55))
        bezierPath.addCurve (to: CGPoint(x: cX + 5.67, y: cY + -46.14), controlPoint1: CGPoint(x: cX + -20.3, y: cY + -42.65), controlPoint2: CGPoint(x: cX + -7.22, y: cY + -47.11))
        bezierPath.addCurve (to: CGPoint(x: cX + 50.27, y: cY + -10.55), controlPoint1: CGPoint(x: cX + 26.08, y: cY + -45.31), controlPoint2: CGPoint(x: cX + 44.77, y: cY + -30.18))
        bezierPath.addCurve (to: CGPoint(x: cX + 51.61, y: cY + 11.83), controlPoint1: CGPoint(x: cX + 52.52, y: cY + -3.34), controlPoint2: CGPoint(x: cX + 52.52, y: cY + 4.4))
        bezierPath.addCurve (to: CGPoint(x: cX + 14.98, y: cY + 51.66), controlPoint1: CGPoint(x: cX + 48.51, y: cY + 30.75), controlPoint2: CGPoint(x: cX + 33.63, y: cY + 47.08))
        bezierPath.addCurve (to: CGPoint(x: cX + -0.91, y: cY + 53.13), controlPoint1: CGPoint(x: cX + 9.82, y: cY + 52.92), controlPoint2: CGPoint(x: cX + 4.39, y: cY + 53.58))
        bezierPath.close()
        
        bezierPath.move(to: CGPoint(x: cX + -8.55, y: cY + 50.08))
        bezierPath.addCurve (to: CGPoint(x: cX + -21.98, y: cY + 25.2), controlPoint1: CGPoint(x: cX + -17.64, y: cY + 45.61), controlPoint2: CGPoint(x: cX + -23.27, y: cY + 35.27))
        bezierPath.addCurve (to: CGPoint(x: cX + 1.71, y: cY + 3.32), controlPoint1: CGPoint(x: cX + -20.94, y: cY + 13.34), controlPoint2: CGPoint(x: cX + -10.15, y: cY + 3.53))
        bezierPath.addCurve (to: CGPoint(x: cX + 25.04, y: cY + -11.87), controlPoint1: CGPoint(x: cX + 11.64, y: cY + 3.62), controlPoint2: CGPoint(x: cX + 21.43, y: cY + -2.55))
        bezierPath.addCurve (to: CGPoint(x: cX + 16.45, y: cY + -41.08), controlPoint1: CGPoint(x: cX + 29.36, y: cY + -22.07), controlPoint2: CGPoint(x: cX + 25.63, y: cY + -34.86))
        bezierPath.addCurve (to: CGPoint(x: cX + -9.71, y: cY + -43.53), controlPoint1: CGPoint(x: cX + 8.92, y: cY + -46.63), controlPoint2: CGPoint(x: cX + -1.14, y: cY + -45.45))
        bezierPath.addCurve (to: CGPoint(x: cX + -45.91, y: cY + 0.21), controlPoint1: CGPoint(x: cX + -29.5, y: cY + -38.67), controlPoint2: CGPoint(x: cX + -44.8, y: cY + -20.13))
        bezierPath.addCurve (to: CGPoint(x: cX + -21.08, y: cY + 45.88), controlPoint1: CGPoint(x: cX + -47.35, y: cY + 18.57), controlPoint2: CGPoint(x: cX + -37.25, y: cY + 37.1))
        bezierPath.addCurve (to: CGPoint(x: cX + -7.5, y: cY + 50.68), controlPoint1: CGPoint(x: cX + -17.03, y: cY + 48.07), controlPoint2: CGPoint(x: cX + -11.29, y: cY + 50.63))
        bezierPath.addLine(to: CGPoint(x: cX + -7.92, y: cY + 50.42))
        bezierPath.addLine(to: CGPoint(x: cX + -8.55, y: cY + 50.08))
        bezierPath.addLine(to: CGPoint(x: cX + -8.55, y: cY + 50.08))
        bezierPath.close()
        
        fillColor.setFill()
        bezierPath.fill()
        
        
        return Path(bezierPath.cgPath)
    }
}

#Preview {
    ZStack {
        Color.purple
            .opacity(0.1)
        YinYangShape()
            .background {
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 96, height: 96)
                    .offset(y: 2)
            }
    }
}
