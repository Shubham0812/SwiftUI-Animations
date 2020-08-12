//
//  Test.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 12/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct CircleEmitter: View {
    @Binding var isAnimating: Bool
    
    var body: some View {
            Circles()
                .fill(Color.white.opacity(0.75))
                .scaleEffect(self.isAnimating ? 2 : 0)
                .animation(self.isAnimating ? Animation.spring(): Animation.easeInOut(duration: 0))
    }
}

struct CircleEmitter_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CircleEmitter(isAnimating: .constant(true))
        }
    }
}
