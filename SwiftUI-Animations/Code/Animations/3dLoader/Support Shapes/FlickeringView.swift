//
//  FlickeringView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct FlickeringView: View {
    
    // MARK:- variables
    let backgroundColor: Color
    let initialOffset: CGSize
    let initialSize: CGSize
    
    let finalSize: CGSize
    let finalOffset: CGSize
    
    let fadeDuration: TimeInterval
    let animationDuration: TimeInterval = 0.75
    
    @State var rectangleOpacity: Double = 1
    @State var isAnimating: Bool = false
    
    // MARK:- views
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
                .offset(self.isAnimating ? finalOffset : initialOffset)
                .frame(width: self.isAnimating ? self.finalSize.width : initialSize.width, height: self.isAnimating ? finalSize.height : initialSize.height)
                .opacity(rectangleOpacity)
        }.onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                withAnimation(Animation.easeOut(duration: 0.25)) {
                    isAnimating.toggle()
                }
                withAnimation(Animation.easeOut(duration: animationDuration)) {
                    self.rectangleOpacity = 0.8
                }
                withAnimation(Animation.easeOut(duration: animationDuration).delay(animationDuration * 1.5)) {
                    self.rectangleOpacity = 0.1
                }
                withAnimation(Animation.easeOut(duration: animationDuration).delay(animationDuration * 1.75)) {
                    self.rectangleOpacity = 0.7
                }
                withAnimation(Animation.easeOut(duration: animationDuration).delay(fadeDuration)) {
                    self.rectangleOpacity = 0
                }
            }
        }
    }
}

struct FlickeringView_Previews: PreviewProvider {
    static var previews: some View {
        FlickeringView(backgroundColor: Color.black, initialOffset: CGSize(width: 50, height: -200), initialSize: CGSize(width: 200, height: 40), finalSize: CGSize(width: 40, height: 40), finalOffset: CGSize(width: -100, height: -200), fadeDuration: 4)
    }
}
