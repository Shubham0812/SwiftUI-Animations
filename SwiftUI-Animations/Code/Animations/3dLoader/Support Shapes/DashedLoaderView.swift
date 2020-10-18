//
//  DashedLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct DashedLoaderView: View {
    
    // MARK:- variables
    @State var isAnimating: Bool = false
    
    let animationDuration: TimeInterval = 5
    
    // MARK:- views
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, miterLimit: 2, dash: [10, 40, 20], dashPhase: 6))
                    .foregroundColor(Color.black)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    .rotationEffect(self.isAnimating ? .degrees(360) : .degrees(0))
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                    .animation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false))
                Circle()
                    .frame(width: geometry.size.width * 0.06, height: geometry.size.width * 0.1)
                    .offset(x: -geometry.size.width / 4)
                    .foregroundColor(Color.black)
                    .rotationEffect(self.isAnimating ? .degrees(360) : .degrees(0))
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                    .animation(Animation.linear(duration: animationDuration * 0.75).repeatForever(autoreverses: false))
                Circle()
                    .frame(width: geometry.size.width * 0.06, height: geometry.size.width * 0.1)
                    .offset(x: geometry.size.width / 4)
                    .foregroundColor(Color.black)
                    .rotationEffect(self.isAnimating ? .degrees(360) : .degrees(0))
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                    .animation(Animation.linear(duration: animationDuration * 0.75).repeatForever(autoreverses: false))
            }
        }.onAppear() {
            self.isAnimating.toggle()
        }
    }
}

struct DashedLoader_Previews: PreviewProvider {
    static var previews: some View {
        DashedLoaderView()
    }
}
