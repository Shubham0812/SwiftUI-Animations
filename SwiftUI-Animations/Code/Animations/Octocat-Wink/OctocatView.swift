//
//  OctocatView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 12/10/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

struct OctocatView: View {
    
    // MARK:- variables
    @State var resetStrokes: Bool = true
    @State var strokeStart: CGFloat = 0
    @State var strokeEnd: CGFloat = 0
    
    @State var winkLeft = false
    
    // MARK:- views
    var body: some View {
        GeometryReader { proxy in
            let cX: CGFloat = proxy.frame(in: .global).midX
            let cY: CGFloat = proxy.frame(in: .global).midY
            
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                ZStack {
                    OctocatShape()
                        .trim(from: 0, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round, miterLimit: 8))
                        .scaleEffect(1.35)
                        .foregroundColor(.label.opacity(0.1))
                        .shadow(color: Color.white.opacity(0.075), radius: 5, y: 2)
                    OctocatShape()
                        .trim(from: strokeStart, to: strokeEnd)
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round, miterLimit: 8))
                        .scaleEffect(1.35)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 1)
                    OctoHead()
                        .scaleEffect(0.3925)
                        .opacity(0.8)
                        .offset(x: 3)
                    
                    Path { path in
                        path.move(to: CGPoint(x: cX + -66.13, y: cY + -14.34))
                        path.addCurve(to: CGPoint(x: cX + -80.6, y: cY + 7.17), control1: CGPoint(x: cX + -73.81, y: cY + -13.04), control2: CGPoint(x: cX + -79.51, y: cY + -4.54))
                        path.addCurve(to: CGPoint(x: cX + -69.38, y: cY + 34.62), control1: CGPoint(x: cX + -81.76, y: cY + 19.57), control2: CGPoint(x: cX + -77.08, y: cY + 30.95))
                        path.addCurve(to: CGPoint(x: cX + -63.92, y: cY + 35.56), control1: CGPoint(x: cX + -67.53, y: cY + 35.5), control2: CGPoint(x: cX + -67.2, y: cY + 35.56))
                        path.addCurve(to: CGPoint(x: cX + -58.4, y: cY + 34.56), control1: CGPoint(x: cX + -60.58, y: cY + 35.56), control2: CGPoint(x: cX + -60.34, y: cY + 35.5))
                        path.addCurve(to: CGPoint(x: cX + -54.4, y: cY + -10.21), control1: CGPoint(x: cX + -45.63, y: cY + 28.34), control2: CGPoint(x: cX + -43.2, y: cY + 1.07))
                        path.addLine(to: CGPoint(x: cX + -54.34, y: cY + -10.15))
                        path.addCurve(to: CGPoint(x: cX + -61.29, y: cY + -14.16), control1: CGPoint(x: cX + -56.18, y: cY + -12.19), control2: CGPoint(x: cX + -58.61, y: cY + -13.59))
                        path.addLine(to: CGPoint(x: cX + -61.33, y: cY + -14.16))
                        path.addCurve(to: CGPoint(x: cX + -66, y: cY + -14.37), control1: CGPoint(x: cX + -62.84, y: cY + -14.63), control2: CGPoint(x: cX + -64.45, y: cY + -14.7))
                        path.addLine(to: CGPoint(x: cX + -66.13, y: cY + -14.34))
                        path.closeSubpath()
                    }
                    .scaleEffect(0.3925)
                    .foregroundColor(.background)
                    .offset(y: -19)
                    .scaleEffect(CGSize(width: 1.0, height: resetStrokes ? 1 : winkLeft ? 0.225 : 1))
                    .animation(.easeInOut(duration: 0.3))
                    
                    Path { path in
                        path.move(to: CGPoint(x: cX + 66.87, y: cY + -14.34))
                        path.addCurve(to: CGPoint(x: cX + 52.4, y: cY + 7.17), control1: CGPoint(x: cX + 59.19, y: cY + -13.04), control2: CGPoint(x: cX + 53.49, y: cY + -4.54))
                        path.addCurve(to: CGPoint(x: cX + 63.62, y: cY + 34.62), control1: CGPoint(x: cX + 51.24, y: cY + 19.57), control2: CGPoint(x: cX + 55.92, y: cY + 30.95))
                        path.addCurve(to: CGPoint(x: cX + 69.08, y: cY + 35.56), control1: CGPoint(x: cX + 65.47, y: cY + 35.5), control2: CGPoint(x: cX + 65.8, y: cY + 35.56))
                        path.addCurve(to: CGPoint(x: cX + 74.6, y: cY + 34.56), control1: CGPoint(x: cX + 72.42, y: cY + 35.56), control2: CGPoint(x: cX + 72.66, y: cY + 35.5))
                        path.addCurve(to: CGPoint(x: cX + 78.6, y: cY + -10.21), control1: CGPoint(x: cX + 87.37, y: cY + 28.34), control2: CGPoint(x: cX + 89.8, y: cY + 1.07))
                        path.addLine(to: CGPoint(x: cX + 78.66, y: cY + -10.15))
                        path.addCurve(to: CGPoint(x: cX + 71.71, y: cY + -14.16), control1: CGPoint(x: cX + 76.82, y: cY + -12.19), control2: CGPoint(x: cX + 74.39, y: cY + -13.59))
                        path.addLine(to: CGPoint(x: cX + 71.67, y: cY + -14.16))
                        path.addCurve(to: CGPoint(x: cX + 67, y: cY + -14.37), control1: CGPoint(x: cX + 70.16, y: cY + -14.63), control2: CGPoint(x: cX + 68.55, y: cY + -14.7))
                        path.addLine(to: CGPoint(x: cX + 66.87, y: cY + -14.34))
                        path.closeSubpath()
                    }
                    .scaleEffect(0.3925)
                    .foregroundColor(.background)
                    .offset(y: -19)
                    .scaleEffect(CGSize(width: 1.0, height: resetStrokes ? 1 : !winkLeft ? 0.225 : 1))
                    .animation(.easeInOut(duration: 0.3))
                }
                .scaleEffect(1.5)
                .offset(y: -42)
            }
        }
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { timer in
                withAnimation(Animation.easeOut(duration: 0.55)) {
                    self.strokeEnd += CGFloat.random(in: 0.075 ..<  0.115)
                    self.strokeStart = self.strokeEnd - 0.25
                }
                if (self.strokeEnd >= 1) {
                    if (self.resetStrokes) {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            
                            self.strokeEnd = 0
                            self.strokeStart = 0
                            self.resetStrokes.toggle()
                            self.winkLeft = Bool.random()
                        }
                        self.resetStrokes = false
                    }
                }
            }
        }
    }
}

struct OctocatView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            OctocatView()
        }
        .preferredColorScheme(.dark)
    }
}
