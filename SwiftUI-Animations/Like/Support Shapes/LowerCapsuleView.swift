//
//  LowerCapsuleView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct LowerCapsuleView: View {
    
    // MARK:- variables
    @Binding var isAnimating: Bool
    
    // MARK:- views
    var body: some View {
        ZStack {
            ShrinkingCapsule(rotationAngle: .degrees(16), offset: CGSize(width: -42.5, height: 10), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees( -16), offset: CGSize(width: 42.5, height: 10), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(48), offset: CGSize(width: -107, height: -30), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-48), offset: CGSize(width: 107, height: -30), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(82), offset: CGSize(width: -142, height: -95), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-82), offset: CGSize(width: 142, height: -95), isAnimating: $isAnimating)
        }
        .offset(y: 260)
    }
}

struct LowerCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        LowerCapsuleView(isAnimating: .constant(false))
    }
}
