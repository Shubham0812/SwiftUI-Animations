//
//  FillShapes.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct FillShapes: View {
    
    // MARK:- variables
    @State var xOffset: CGFloat
    @State var yOffset: CGFloat
    
    @State var capsuleSpacing: CGFloat
    
    // MARK:- views
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.white.opacity(0.55))
                .shadow(color: .white, radius: 10, x: 1, y: 1)
                .offset(x: xOffset, y: yOffset)
            
            Capsule(style: .continuous)
                .frame(width: 20, height: 40)
                .foregroundColor(Color.white.opacity(0.55))
                .shadow(color: .white, radius: 10, x: 1, y: 1)
                .offset(x: xOffset, y: yOffset + capsuleSpacing)
            
        }
    }
}

struct HalfCapsuleFill_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.blue
                .edgesIgnoringSafeArea(.all)
            FillShapes(xOffset: -45, yOffset: -10, capsuleSpacing: 40)
        }
    }
}
