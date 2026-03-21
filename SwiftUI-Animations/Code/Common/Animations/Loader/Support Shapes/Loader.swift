//
//  Loader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A single animated capsule that moves in a specific direction as part of the square Loader animation.
///
/// Each `Loader` instance represents one capsule that stretches and slides along one edge of an
/// invisible square. Multiple `Loader` instances (one per direction) are combined to create the
/// full square loader effect. The capsule animates in two phases per cycle: first it stretches
/// in the movement direction (`increment_before`), then it contracts and slides to the final
/// position (`increment_after`), creating a fluid bouncing motion. The animation cycles through
/// all `LoaderState` cases (directions) continuously.
struct Loader: View {
    
    // MARK:- variables
    @State var capsuleWidth: CGFloat = 40
    @State var capsuleHeight: CGFloat = 40
    @State var xOffset: CGFloat = 0
    @State var yOffset: CGFloat = 0
    @State var loaderState: LoaderState
    @State var currentIndex = 0
    @State var animationStarted: Bool = true
    
    var timerDuration: TimeInterval
    @Binding var startAnimating: Bool
    
    // MARK:- views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            Capsule()
                .stroke(style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .frame(width: capsuleWidth, height: capsuleHeight, alignment: .center)
                .animation(.easeOut(duration: 0.35))
                .offset(x: self.xOffset, y: self.yOffset)
            
        }).frame(width: 40, height: 0, alignment: loaderState.alignment)
        .onAppear() {
            self.setIndex()
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (initialTimer) in
                if (self.startAnimating) {
                    Timer.scheduledTimer(withTimeInterval: self.timerDuration, repeats: false) { (separatorTimer) in
                        self.animateCapsule()
                        Timer.scheduledTimer(withTimeInterval: 2.1, repeats: true) { (loaderTimer) in
                            if (!self.startAnimating) {
                                loaderTimer.invalidate()
                            }
                            self.loaderState = self.getNextCase()
                            self.animateCapsule()
                        }
                    }
                    // invalidate the initialTimer that starts the animation once the binding constant is true
                    initialTimer.invalidate()
                }
            }
        }
    }
    
    // MARK:- functions
    
    // provides the next case defined in the enum based on the currentIndex
    func getNextCase() -> LoaderState {
        let allCases = LoaderState.allCases
        if (self.currentIndex == allCases.count - 1) {
            self.currentIndex = -1
        }
        self.currentIndex += 1
        let index = self.currentIndex
        return allCases[index]
    }
    
    // sets the initialIndex & offset values based on the loader state provided to the view
    func setIndex() {
        for (ix, loaderCase) in LoaderState.allCases.enumerated() {
            if (loaderCase == self.loaderState) {
                self.currentIndex = ix
                self.xOffset = LoaderState.allCases[self.currentIndex].increment_before.0
                self.yOffset = LoaderState.allCases[self.currentIndex].increment_before.1
            }
        }
    }
    
    // animates the capsule to a direction
    func animateCapsule() {
        self.xOffset = self.loaderState.increment_before.0
        self.yOffset = self.loaderState.increment_before.1
        self.capsuleWidth = self.loaderState.increment_before.2
        self.capsuleHeight = self.loaderState.increment_before.3
        
        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { (Timer) in
            self.xOffset = self.loaderState.increment_after.0
            self.yOffset = self.loaderState.increment_after.1
            self.capsuleWidth = self.loaderState.increment_after.2
            self.capsuleHeight = self.loaderState.increment_after.3
        }
    }
}


#Preview {
    ZStack {
        Loader(loaderState: .down, timerDuration: 0.35, startAnimating: .constant(true))
    }
}
