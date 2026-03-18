//
//  ShrinkingPlus.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A `+` symbol particle that periodically rotates and collapses then re-expands.
///
/// Placed at a fixed `PlusPosition` in `LoginView`, each `ShrinkingPlus`:
/// 1. Appears at `position.scale`, rotated to `position.degree`.
/// 2. Collapses to scale 0 (easeOut) after `position.delay`.
/// 3. Re-expands to `position.scale` after a further `delay × 3`, then repeats every `delay × 20`.
///
/// The varying delays across 7 instances mean they collapse and re-expand asynchronously,
/// creating a twinkling `+` field around the profile image.
struct ShrinkingPlus: View {

    // MARK:- variables

    /// Layout and timing data for this specific particle instance.
    let position: PlusPosition
    /// Duration for both the collapse and re-expand easeOut animations.
    let animationDuration: TimeInterval = 0.4

    /// Current rotation angle — starts at 0 then snaps to `position.degree` on appear.
    @State var rotationDegree: Angle = Angle.degrees(0)
    /// Current scale — starts at 0, grows to `position.scale` on appear, collapses periodically.
    @State var scale: CGFloat = 0
    
    // MARK:- views
    var body: some View {
        Plus()
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
            .foregroundColor(position.color)
            .rotationEffect(rotationDegree)
            .scaleEffect(scale)
            .opacity(position.opacity)
            .onAppear() {
                self.scale = position.scale
                self.rotationDegree = position.degree
                animatePlus()
                Timer.scheduledTimer(withTimeInterval: position.delay * 20, repeats: true) { _ in
                    animatePlus()
                }
            }
    }
    
    // MARK:- functions

    /// Runs one collapse-and-re-expand cycle:
    /// - After `position.delay`: rotates to `position.degree` and collapses scale to 0.
    /// - After a further `delay × 3`: resets rotation to 0° and restores `position.scale`.
    func animatePlus() {
        Timer.scheduledTimer(withTimeInterval: position.delay, repeats: false) { _ in
            withAnimation(Animation.easeOut(duration: animationDuration)) {
                rotationDegree = (position.degree)
            }
            withAnimation(Animation.easeOut(duration: animationDuration).delay(animationDuration / 4)) {
                scale = 0
            }
            
            Timer.scheduledTimer(withTimeInterval: position.delay * 3, repeats: false) { _ in
                withAnimation(Animation.easeOut(duration: animationDuration)) {
                    rotationDegree = .degrees(0)
                }
                withAnimation(Animation.easeOut(duration: animationDuration).delay(animationDuration / 4)) {
                    scale = position.scale
                }
            }
        }
    }
}

struct ShrinkingPlus_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ShrinkingPlus(position: PlusPosition(id: 0, color: Color.white, offsetX: -92, offsetY: -100, delay: 0.2, scale: 0.8, opacity: 1, degree: Angle(degrees: 43)))
        }
    }
}
