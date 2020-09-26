//
//  UpperCapsuleView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct CapusuleGroupView: View {
    
    // MARK:- variables
    @Binding var isAnimating: Bool
    
    // MARK:- views
    var body: some View {
        ZStack {
            ShrinkingCapsule(rotationAngle: .zero, offset: CGSize(width: 0, height: -15), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-33), offset: CGSize(width: -80, height: 7.5), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(33), offset: CGSize(width: 80, height: 7.5), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(-65), offset: CGSize(width: -135, height: 70), isAnimating: $isAnimating)
            ShrinkingCapsule(rotationAngle: .degrees(65), offset: CGSize(width: 135, height: 70), isAnimating: $isAnimating)
            LowerCapsuleView(isAnimating: $isAnimating)
        }
        .onTapGesture {
            self.isAnimating.toggle()
        }
    }
}

struct UpperCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        CapusuleGroupView(isAnimating: .constant(false))
    }
}
