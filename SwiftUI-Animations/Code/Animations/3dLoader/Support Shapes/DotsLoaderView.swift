//
//  DotsLoaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct DotsLoaderView: View {
    
    // MARK:- variables
    @State var leftOffset: CGFloat = -75
    @State var rightOffset: CGFloat = 75
    
    let animationDuration: TimeInterval = 1
    
    // MARK:- views
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: animationDuration))
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: animationDuration).delay(0.2))
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: animationDuration).delay(0.4))
        }
        .onAppear() {
            swap(&self.leftOffset, &self.rightOffset)
            Timer.scheduledTimer(withTimeInterval: animationDuration * 1.5, repeats: true) { _ in
                swap(&self.leftOffset, &self.rightOffset)
            }
        }
    }
}

struct DotsLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            DotsLoaderView()
        }
    }
}
