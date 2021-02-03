//
//  WifiView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 10/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct WifiView: View {
    
    // MARK:- variables
    @State var isAnimating: Bool = false
    @State var isConnected: Bool = false
    
    @State var circleOffset: CGFloat = 20
    @State var smallArcOffset: CGFloat = 16
    @State var mediumArcOffset: CGFloat = 14.5
    @State var largeArcOffset: CGFloat = 14
    
    @State var arcColor: Color = Color.white
    @State var shadowColor: Color = Color.blue
    @State var wifiHeaderLabel: String = "Wi-Fi"
    
    static var animationMovingUpwards: Bool = true
    static var moveArc: Bool = true
    
    var animationDuration: Double = 0.35
    
    var body: some View {
        ZStack {
            Color.wifiBackground
                .edgesIgnoringSafeArea(.all)
            CircleEmitter(isAnimating: $isConnected)
//                .offset(y: 90)
//                .frame(height: 300)
            ZStack {
                Circle()
                    .fill(self.arcColor)
                    .scaleEffect(0.075)
                    .shadow(color: Color.blue, radius: 5)
                    .offset(y: self.circleOffset)
                    .animation(Animation.easeOut(duration: animationDuration))
                ZStack {
                    ArcView(radius: 12, fillColor: $arcColor, shadowColor: $shadowColor)
                        .rotationEffect(getRotation(arcBoolean: Self.moveArc))
                        .offset(y: smallArcOffset)
                        .animation(Animation.easeOut(duration: self.animationDuration))
                    
                    ArcView(radius: 24, fillColor: $arcColor, shadowColor: $shadowColor)
                        .rotationEffect(getRotation(arcBoolean: Self.moveArc))
                        .offset(y: self.mediumArcOffset)
                        .animation(Animation.easeOut(duration: self.animationDuration).delay(self.animationDuration))
                    
                    
                    ArcView(radius: 36, fillColor: $arcColor, shadowColor: $shadowColor)
                        .rotationEffect(getRotation(arcBoolean: Self.moveArc))
                        .offset(y: self.largeArcOffset)
                        .animation(Animation.easeOut(duration: self.animationDuration).delay(self.animationDuration * 1.9))
                    Circle().stroke(style: StrokeStyle(lineWidth: 2.5))
                        .foregroundColor(Color.white)
                        .opacity(0.8)
                    Circle().fill(Color.blue.opacity(0.1))
                    Circle().fill(Color.blue.opacity(0.025))
                        .scaleEffect(self.isAnimating ? 5 : 0)
                        .animation(self.isAnimating ? Animation.easeIn(duration: animationDuration * 2.5).repeatForever(autoreverses: false) :Animation.linear(duration: 0)
                        )
                    
                }
            }.frame(height: 120)
//            .scaleEffect(self.isConnected ? 1.2 : 1)
//            .animation(self.isConnected ? Animation.easeOut(duration: animationDuration) : .none)
            .onTapGesture {
                self.isAnimating.toggle()
                self.wifiHeaderLabel = "Searching"
                self.smallArcOffset -= 7.5
                self.circleOffset -= 15
                self.mediumArcOffset = -5.5
                self.largeArcOffset = -19
                self.isConnected = false
                self.arcColor = Color.white
                self.shadowColor = Color.blue
                
                Timer.scheduledTimer(withTimeInterval: self.animationDuration, repeats: true) { (arcTimer) in
                    if (self.isAnimating) {
                        self.circleOffset += Self.animationMovingUpwards ? -15 : 15
                        self.smallArcOffset += Self.moveArc ? -15 : 15
                        if (self.circleOffset == -25) {
                            Self.animationMovingUpwards = false
                        } else if (self.circleOffset == 20) {
                            Self.animationMovingUpwards = true
                        }
                        if (Self.moveArc) {
                            self.mediumArcOffset += -15
                        }
                    } else {
                        arcTimer.invalidate()
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: (self.animationDuration) * 2, repeats: true) { (arcTimer) in
                    if (self.isAnimating) {
                        self.mediumArcOffset += 15
                    } else {
                        arcTimer.invalidate()
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: (self.animationDuration) * 3, repeats: true) { (arcTimer) in
                    if (self.isAnimating) {
                        Self.moveArc.toggle()
                        self.smallArcOffset = !Self.moveArc ? -15 : 8.5
                        if (Self.animationMovingUpwards) {
                            self.largeArcOffset = -19
                            self.mediumArcOffset = -5.5
                        } else {
                            self.largeArcOffset = 14
                            self.mediumArcOffset = 0
                        }
                    } else {
                        arcTimer.invalidate()
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: self.animationDuration * 12, repeats: false) { (_) in
                    self.restoreAnimation()
                    self.arcColor = Color.wifiConnected
                    self.shadowColor = Color.white.opacity(0.5)
                    self.wifiHeaderLabel = "Connected"
                    self.isConnected.toggle()
                    
                    Timer.scheduledTimer(withTimeInterval: self.animationDuration + 0.05, repeats: false) { (Timer) in
                        self.isConnected.toggle()
                    }
                }
            }
            Text(self.wifiHeaderLabel)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .opacity(self.isAnimating ? 0 : 1)
                .foregroundColor(Color.white)
                .offset(y: 100)
                .animation(self.isAnimating ? Animation.spring().speed(0.65).repeatForever(autoreverses: false) : Animation.linear(duration: 0).repeatCount(0))
        }
    }
    
    func getRotation(arcBoolean: Bool) -> Angle {
        if (self.isAnimating && arcBoolean) {
            return Angle.degrees(180)
        } else if (self.isAnimating && arcBoolean) {
            return Angle.degrees(-180)
        }
        return Angle.degrees(0)
    }
    
    func restoreAnimation() {
        self.isAnimating = false
        Self.animationMovingUpwards = true
        Self.moveArc = true
        
        self.circleOffset = 20
        self.smallArcOffset = 16
        self.mediumArcOffset = 14.5
        self.largeArcOffset = 14
    }
}

struct WifiView_Previews: PreviewProvider {
    static var previews: some View {
        WifiView()
    }
}
