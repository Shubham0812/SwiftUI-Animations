//
//  PillDropView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct PillsDropView: View {
    
    // MARK:- variables
    @Binding var isAnimating: Bool
    
    var body: some View {
        ZStack {
            PillGroupView(isAnimating: $isAnimating, initialOffSet: CGSize(width: 0, height: 0), animationOffset: 0.05)
            PillGroupView(isAnimating: $isAnimating, initialOffSet: CGSize(width: 10, height: -45), animationOffset: 0.05)
            PillGroupView(isAnimating: $isAnimating, initialOffSet: CGSize(width: -10, height: -99.5), animationOffset: 0.025)
        }
    }
}

struct PillDropView_Previews: PreviewProvider {
    static var previews: some View {
        PillsDropView(isAnimating: .constant(false))
    }
}
