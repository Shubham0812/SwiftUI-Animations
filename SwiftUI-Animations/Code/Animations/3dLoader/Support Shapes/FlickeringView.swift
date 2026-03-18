//
//  FlickeringView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A single rectangle that slides from an initial position/size to a final position/size,
/// then fades through a multi-step opacity sequence — used to simulate a lens-flare or
/// light-glint effect during cube face transitions in `RotatingLoaderView`.
///
/// **Opacity sequence (all easeOut):**
/// ```
/// t = 0.1 s   → 0.8  (slide-in + quick brighten)
/// t = 0.75 s  → 0.1  (dim)
/// t = 1.3 s   → 0.7  (brief re-brighten flicker)
/// t = fadeDuration   → 0  (fade out completely)
/// ```
struct FlickeringView: View {

    // MARK:- variables

    /// Background color of the flickering rectangle (typically matching the face color).
    let backgroundColor: Color
    /// Starting (x, y) offset before the animation fires.
    let initialOffset: CGSize
    /// Starting (width, height) of the rectangle — often a wide, short bar.
    let initialSize: CGSize

    /// Target (width, height) the rectangle morphs to when `isAnimating` becomes `true`.
    let finalSize: CGSize
    /// Target (x, y) offset the rectangle slides to when `isAnimating` becomes `true`.
    let finalOffset: CGSize

    /// Delay before the final fade-to-zero opacity animation fires.
    /// Longer values keep the flicker visible for more of the cube transition.
    let fadeDuration: TimeInterval
    /// Base duration shared by all intermediate opacity animations.
    let animationDuration: TimeInterval = 0.75

    /// Drives the opacity sequence — see struct doc for the full timeline.
    @State var rectangleOpacity: Double = 1
    /// When `true`, the rectangle adopts `finalSize` and `finalOffset`.
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
