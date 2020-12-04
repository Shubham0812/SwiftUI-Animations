//
//  InfinityView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 03/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct InfinityView: View {
    
    // MARK:- variables
    let animationDuration: TimeInterval = 0.2
    let strokeWidth: CGFloat = 20
    let animationCap: CGFloat = 1.205
    
    
    @State var strokeStart: CGFloat = 0
    @State var strokeEnd: CGFloat = 0
    @State var additionalLength: CGFloat = 0
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            InfinityShape()
                .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(.white)
                .shadow(color: Color.white,radius: 4)
                .overlay(
                    InfinityShape()
                        .trim(from: strokeStart, to: strokeEnd)
                        .stroke(style: StrokeStyle(lineWidth: strokeWidth - 0.5, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.materialBlack)
                        .shadow(color: Color.white, radius: 5)
                )
        }.onAppear() {
            Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                withAnimation(Animation.linear(duration: animationDuration)) {
                    strokeEnd += 0.05
                    strokeStart = strokeEnd - (0.05 + additionalLength)
                }
                
                // reset values
                if (strokeEnd >= animationCap) {
                    strokeEnd = 0
                    additionalLength = 0
                    strokeStart = 0
                }
            }
            
            Timer.scheduledTimer(withTimeInterval: animationDuration * 3, repeats: true) { _ in
                additionalLength += 0.015
            }
        }
    }
}

struct InfinityView_Previews: PreviewProvider {
    static var previews: some View {
        InfinityView()
    }
}
