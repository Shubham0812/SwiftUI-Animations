//
//  PillLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct PillLoader: View {
    
    // MARK:- variables
    let trackerRotation: Double = 1.5
    let animationDuration: Double = 3
    let backgroundColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottom)
    
    @State var isAnimating: Bool = false
    @State var hideCapsule: Bool = false
    @State var fillCapsule: Bool = false

    @State private var time: CGFloat = 0.5
    
    // MARK:- views
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            ZStack {
                PillsDropView(isAnimating: $hideCapsule)
                    .opacity(self.hideCapsule ? 1 : 0)
                // Outer container
                Capsule(style: .circular)
                    .stroke(style: StrokeStyle(lineWidth: 10))
                    .foregroundColor(Color.white)
                    .shadow(color: Color.white.opacity(0.1), radius: 1)
                
                FillShapes(xOffset: -45, yOffset: -100, capsuleSpacing: 40)
                
                // Line
                Color.white
                    .frame(height: 6, alignment: .center)
                
                // Initial Half Capsule
                Capsule(style: .circular)
                    .trim(from: 0, to: 0.5)
                    .foregroundColor(Color.pillColor)
                    .padding(5.5)
                    .padding(.top, 6)
                    .opacity(self.hideCapsule ? 0 : 1)
                FillShapes(xOffset: 45, yOffset: 100, capsuleSpacing: -40)
                
                // Filling Capsule
                ZStack {
                    WaveFill(curve: time * 0.25, curveHeight: 10, curveLength: 1.5)
                        .fill(Color.pillColor.opacity(0.985))
                        .offset(y: self.fillCapsule ? 0 : 180)
                    WaveFill(curve: time * 5, curveHeight: 12, curveLength: 1.5)
                        .fill(Color.pillColor.opacity(0.9))
                        .offset(y: self.fillCapsule ? 0 : 180)
                    FillShapes(xOffset: 45, yOffset: 100, capsuleSpacing: -40)
                }
                .rotationEffect(.degrees(180))
                .opacity(self.hideCapsule ? 1 : 0)
                .mask(
                    Capsule(style: .circular)
                        .trim(from: 0.5, to: 1)
                        .foregroundColor(Color.red)
                        .padding(5.5)
                        .padding(.bottom, 8)
                    
                )
            }
            .frame(width: 140, height: 360)
            .rotationEffect(self.isAnimating ? getRotationAngle() : .degrees(0))
        }.onAppear() {
            self.animateLoader()
            Timer.scheduledTimer(withTimeInterval: (self.animationDuration * self.trackerRotation) * 3.75, repeats: true) { _ in
                self.animateLoader()
            }
        }
    }
    
    // MARK:- functions
    func getRotationAngle() -> Angle {
        return .degrees(360 * self.trackerRotation)
    }
    
    func animateLoader() {
        withAnimation(Animation.interactiveSpring(response: self.animationDuration * self.trackerRotation, dampingFraction: 1, blendDuration: 1)) {
            self.isAnimating.toggle()
        }
        Timer.scheduledTimer(withTimeInterval: (self.animationDuration * self.trackerRotation) - 0.25, repeats: false) { _ in
            withAnimation(Animation.easeOut(duration: self.animationDuration / 2)) {
                self.hideCapsule.toggle()
            }
            withAnimation(Animation.easeIn(duration: self.animationDuration * 1.85).delay(0.05)) {
                self.fillCapsule.toggle()
            }
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { curveTimer in
                if (self.hideCapsule) {
                    self.time += 0.01
                } else {
                    curveTimer.invalidate()
                }
            }
        }
        Timer.scheduledTimer(withTimeInterval: (self.animationDuration * self.trackerRotation) * 2.5, repeats: false) { (_) in
            self.hideCapsule.toggle()
            self.isAnimating.toggle()
            self.fillCapsule.toggle()
            self.time = 0.5
        }
    }
}

struct PillLoader_Previews: PreviewProvider {
    static var previews: some View {
        PillLoader()
    }
}
