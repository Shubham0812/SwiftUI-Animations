//
//  Circle.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct Pill: View {
    
    // MARK:- variables
    let width: CGFloat = 40
    let height: CGFloat = 40
    
    let initialOffset: CGSize
    let animationOffset: CGSize
    
    let animationDuration: TimeInterval = 0.1
    let animationDelay: TimeInterval
    
    @Binding var isAnimating: Bool
    
    // MARK:- views
    var body: some View {
        Circle()
            .foregroundColor(Color.pillColor)
            .frame(width: width, height: height)
            .offset(self.isAnimating ? animationOffset : initialOffset)
            .animation(Animation.interpolatingSpring(stiffness: 0.5, damping: 1) .delay(animationDelay))
    }
}

struct Circle_Previews: PreviewProvider {
    static var previews: some View {
        Pill(initialOffset: CGSize(width: 0, height: 0), animationOffset: CGSize(width: 40, height: 40), animationDelay: 0.1, isAnimating: .constant(true))
    }
}
