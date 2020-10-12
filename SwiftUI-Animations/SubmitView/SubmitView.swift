//
//  SubmitView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 07/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI
import UIKit

struct SubmitView: View {
    
    // MARK:- variables
    let animationDuration: TimeInterval = 0.45
    let trackerRotation: Double = 2.585
    
    @State var isAnimating: Bool = false
    @State var taskDone: Bool = false
    
    @State var submitScale: CGFloat = 1
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                RoundedRectangle(cornerRadius: self.isAnimating ? 46 : 20, style: .circular)
                    .fill(Color.submitColor)
                    .frame(width: self.isAnimating ? 92 : 300, height: 92)
                    .scaleEffect(submitScale, anchor: .center)
                    .onTapGesture {
                        if (!self.isAnimating) {
                            toggleIsAnimating()
                            animateButton()
                            resetSubmit()
                            Timer.scheduledTimer(withTimeInterval:  trackerRotation * 0.95, repeats: false) { _ in
                                self.taskDone.toggle()
                            }
                        }
                    }
                if (self.isAnimating) {
                    RotatingCircle(trackerRotation: trackerRotation, timerInterval:  trackerRotation * 0.91)
                }
                Tick(scaleFactor: 0.4)
                    .trim(from: 0, to: self.taskDone ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .foregroundColor(Color.white)
                    .frame(width: 16)
                    .offset(x: -4, y: 4)
                    .animation(.easeOut(duration: 0.35))
                Text("Submit")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.white)
                    .opacity(self.isAnimating ? 0 : 1)
                    .animation(Animation.easeOut(duration: animationDuration))
                    .scaleEffect(self.isAnimating ? 0.7 : 1)
                    .animation(Animation.easeOut(duration: animationDuration))
            }
        }
    }
    
    // MARK:- functions
    func animateButton() {
        expandButton()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            expandButton()
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            expandButton()
        }    }
    
    func expandButton() {
        withAnimation(Animation.linear(duration: 0.5)) {
            self.submitScale = 1.35
        }
        withAnimation(Animation.linear(duration: 0.5).delay(0.5)) {
            self.submitScale = 1
        }
    }
    
    func resetSubmit() {
        Timer.scheduledTimer(withTimeInterval: trackerRotation * 0.95 + animationDuration * 3.5, repeats: false) { _ in
            toggleIsAnimating()
            self.taskDone.toggle()
        }
    }
    
    func toggleIsAnimating() {
        withAnimation(Animation.spring(response: animationDuration * 1.25, dampingFraction: 0.9, blendDuration: 1)){
            self.isAnimating.toggle()
        }
    }
}

struct SubmitView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitView()
    }
}
