//
//  ShrinkingCapsule.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct ShrinkingCapsule: View {
    
    // MARK:- variables
    let animationDuration: Double = 0.4
    let rotationAngle: Angle
    let offset: CGSize
    
    @Binding var isAnimating: Bool
    @State var hideCapsule: Bool = false
    
    var body: some View {
        ZStack {
        Capsule(style: .continuous)
            .fill(Color.likeColor)
            .frame(width: 15, height: self.isAnimating ? 30 : 65, alignment: .bottomLeading)
            .rotationEffect(rotationAngle)
        }.offset(offset)
        .opacity(self.hideCapsule ? 0 : 0.8)
        .animation(Animation.easeIn(duration: animationDuration))
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if (self.isAnimating) {
                    Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
                        self.hideCapsule.toggle()
                    }
                    timer.invalidate()
                }
            }
        }
    }
}

struct ShrinkingCapsule_Previews: PreviewProvider {
    static var previews: some View {
        ShrinkingCapsule(rotationAngle: .degrees(35), offset: CGSize(width: 10, height: 10), isAnimating: .constant(false))
    }
}
