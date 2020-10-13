//
//  PillDrop.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct PillGroupView: View {
    
    // MARK:- variables
    @Binding var isAnimating: Bool
    
    let initialOffSet: CGSize
    let animationOffset: Double
    
    // MARK:- views
    var body: some View {
        ZStack {
            Pill(initialOffset: CGSize(width: initialOffSet.width + 45, height: initialOffSet.height + 125), animationOffset: CGSize(width: initialOffSet.width + -20, height: -150), animationDelay: animationOffset, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + -45, height: initialOffSet.height + 118), animationOffset: CGSize(width: initialOffSet.width + -20, height: -145), animationDelay: animationOffset + 0.05, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + 10, height: initialOffSet.height + 124), animationOffset: CGSize(width: initialOffSet.width + -20, height: -150), animationDelay: animationOffset + 0.1, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + -10, height: initialOffSet.height + 125), animationOffset: CGSize(width: initialOffSet.width , height:-145), animationDelay: animationOffset + 0.15, isAnimating: $isAnimating)
            
            Pill(initialOffset: CGSize(width: initialOffSet.width + -30, height: initialOffSet.height + 145), animationOffset: CGSize(width: initialOffSet.width + +10, height: -157.5), animationDelay: animationOffset + 0.2, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + -40, height: initialOffSet.height + 135), animationOffset: CGSize(width: initialOffSet.width + -20, height: -145), animationDelay: animationOffset + 0.25, isAnimating: $isAnimating)
            
            Pill(initialOffset: CGSize(width: initialOffSet.width + 40, height: initialOffSet.height + 140), animationOffset: CGSize(width: initialOffSet.width + -10, height: -120), animationDelay: animationOffset + 0.3, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + 25, height: initialOffSet.height + 155), animationOffset: CGSize(width: initialOffSet.width + -30, height: -125), animationDelay: animationOffset + 0.35, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width, height: initialOffSet.height + 160), animationOffset: CGSize(width: initialOffSet.width + 20, height: -155), animationDelay: animationOffset + 0.4, isAnimating: $isAnimating)
            Pill(initialOffset: CGSize(width: initialOffSet.width + -20, height: initialOffSet.height + 155), animationOffset: CGSize(width: initialOffSet.width , height: -125), animationDelay: animationOffset +  0.45, isAnimating: $isAnimating)
        }
    }
}

struct PillDrop_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                PillGroupView(isAnimating: .constant(false), initialOffSet: CGSize(width: 0, height: 0), animationOffset: 0.1)
            Capsule(style: .circular)
                .stroke(style: StrokeStyle(lineWidth: 10))
                .foregroundColor(.white)
            Color.white
                .frame(height: 6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .frame(width: 140, height: 360)
        }
    }
}
