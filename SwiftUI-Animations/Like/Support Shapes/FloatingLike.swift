//
//  FloatingLike.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct FloatingLike: View {
    
    let animationDuration: TimeInterval = 0.45
    let animation = Animation.spring(response: 0.75).speed(0.75)
    
    @State var scale: CGFloat = 1.25
    @State var offset: CGSize = CGSize(width: 0, height: 0)
    @State var rotationAngle: Angle = Angle.degrees(-4)
    @State var opacity: Double = 1
    
    @Binding var isAnimating: Bool
    
    var body: some View {
        ZStack{
            Capsule(style: .circular)
                .fill(Color.likeColor)
            HStack {
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(Color.white)
                    .font(.system(size: 52, weight: .bold, design: .monospaced))
                Text("1")
                    .foregroundColor(.white)
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                Spacer()
            }
        }.frame(width: 165, height: 130, alignment: .center)
        .rotationEffect(rotationAngle)
        .scaleEffect(scale)
        .offset(offset)
        .opacity(opacity)
        .onAppear() {
            self.scale = 0.1
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { checkingTimer in
                if (isAnimating) {
                    checkingTimer.invalidate()
                    floatCapsule()
                }
            }
        }
    }
    
    // MARK:- functions
    func floatCapsule() {
        withAnimation(animation) {
            self.scale = 0.75
            self.offset = CGSize(width: 10, height: -100)
            self.rotationAngle = .degrees(-10)
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(animation) {
                self.offset = CGSize(width: -10, height: -200)
            }
            withAnimation(Animation.spring(response: animationDuration * 1.2).speed(0.75)) {
                self.rotationAngle = .degrees(10)
            }
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration , repeats: false) { _ in
            withAnimation(animation) {
                self.offset = CGSize(width: 0, height: -300)
                self.rotationAngle = .degrees(0)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.5, repeats: false) { _ in
            withAnimation(animation) {
                self.opacity = 0
            }
        }
    }
}

struct FloatingLike_Previews: PreviewProvider {
    static var previews: some View {
        FloatingLike(isAnimating: .constant(true))
    }
}
