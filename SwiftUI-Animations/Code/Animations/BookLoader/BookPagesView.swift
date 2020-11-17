//
//  BookPagesView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct BookPagesView: View {
    
    // MARK:- variables for the viewController
    @State var isAppeared: Bool = false
    
    @State var leftEndDegree: Angle = .zero
    @State var leftYOffset: CGFloat = 0
    
    @State var rightEndDegree: Angle = .zero
    @State var rightYOffset: CGFloat = -20
    
    @State var pagesDegree: Angle = .zero
    @Binding var animationStarted: Bool
    
    let bookCoverWidth: CGFloat = 100
    let barsOffset: CGFloat = -78
    let animationDuration: TimeInterval
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(.green)
                .frame(width: bookCoverWidth, height: 8)
                .offset(x: barsOffset, y: leftYOffset)
                .rotationEffect(leftEndDegree)
                .animation(Animation.easeOut(duration: animationDuration))
            
            Capsule()
                .foregroundColor(.red)
                .frame(width: bookCoverWidth, height: 8)
                .offset(x: barsOffset, y: rightYOffset)
                .rotationEffect(rightEndDegree)
                .animation(Animation.easeOut(duration: animationDuration))
            
            //            // Bars
            ForEach(0..<13) { num in
                Capsule()
                    .foregroundColor(.white)
                    .frame(width: bookCoverWidth, height: 8)
                    .offset(x: barsOffset)
                    .rotationEffect(pagesDegree)
                    .animation(Animation.easeOut(duration: animationDuration).delay((animationDuration * 0.21) * Double(num)))
            }
        }.onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { animationTimer in
                if (animationStarted) {
                    animatePages()
                    Timer.scheduledTimer(withTimeInterval: animationDuration * 11, repeats: true) { _ in
                        animatePages()
                    }
                    animationTimer.invalidate()
                }
            }
        }
    }
    
    // MARK:- functions
    func animatePages() {
        self.isAppeared.toggle()
        self.rightEndDegree = .degrees(180)
        self.pagesDegree = .degrees(180)
        self.rightYOffset = 0
        
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2.7, repeats: false) { _ in
            self.leftYOffset = 20
            self.leftEndDegree = .degrees(180)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 5, repeats: false) { _ in
            self.leftYOffset = 0
            self.leftEndDegree = .zero
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 5.25, repeats: false) { _ in
            self.pagesDegree = .degrees(0)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 7.5, repeats: false) { _ in
            self.rightEndDegree = .degrees(0)
            self.rightYOffset = -20
        }
    }
    
}

struct BookPagesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            BookPagesView(animationStarted: .constant(true), animationDuration: 0.5)
        }
    }
}
