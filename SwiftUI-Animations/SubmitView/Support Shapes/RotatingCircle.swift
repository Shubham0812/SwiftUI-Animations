//
//  RotatingCircle.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 07/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct RotatingCircle: View {
    
    // MARK:- variables
    @State var isAnimating: Bool = false
    @State var rotationAngle: Angle = .degrees(0)
    @State var circleScale: CGFloat = 0.5
    @State var xOffset: CGFloat = 30
    @State var yOffSet: CGFloat = 0
    @State var opacity: Double = 1
    
    let trackerRotation: Double
    let timerInterval: TimeInterval
    
    // MARK:- views
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 40)
            .offset(x: xOffset, y: yOffSet)
            .rotationEffect(rotationAngle)
            .scaleEffect(circleScale)
            .opacity(opacity)
            .onAppear() {
                //                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                withAnimation(Animation.easeOut(duration: 0.2)) {
                    self.circleScale = 1
                    self.xOffset = 130
                }
                withAnimation(Animation.linear(duration: timerInterval)) {
                    self.rotationAngle = getRotationAngle()
                }
                Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { _ in
                    withAnimation(Animation.easeOut(duration: 0.2)) {
                        self.circleScale = 0.25
                        self.xOffset = 60
                        self.yOffSet = -40
                    }
                }
                Timer.scheduledTimer(withTimeInterval: timerInterval + 0.05, repeats: false) { _ in
                    withAnimation(Animation.default) {
                        self.opacity = 0
                    }
                }
            }
        //            }
    }
    
    // MARK:- functions
    func getRotationAngle() -> Angle {
        return .degrees(360 * self.trackerRotation)
    }
}

struct RotatingCircle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            RotatingCircle(trackerRotation: 2.4, timerInterval:  2.4 * 0.91)
        }
    }
}
