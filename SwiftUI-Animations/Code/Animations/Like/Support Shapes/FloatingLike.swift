//
//  FloatingLike.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A "+1" pill that floats upward and fades out when a like is registered.
///
/// Waits for `isAnimating` to become `true` (polling every 0.1 s), then runs `floatCapsule()`:
/// - Rises from 0 → –100 → –200 → –300 pt over three timer phases.
/// - Sways left then right (rotationAngle: –10° → +10° → 0°) for an organic drift.
/// - Fades to opacity 0 at `animationDuration × 1.5`.
struct FloatingLike: View {

    /// Base duration for each phase. Total float duration ≈ `animationDuration × 1.5`.
    let animationDuration: TimeInterval = 0.45
    /// Shared spring animation used across all three rise phases.
    let animation = Animation.spring(response: 0.75).speed(0.75)

    /// Current scale — starts 0.1 (invisible) and grows to 0.75 when `isAnimating` fires.
    @State var scale: CGFloat = 1.25
    /// Current (x, y) offset driving the upward float path.
    @State var offset: CGSize = CGSize(width: 0, height: 0)
    /// Sway angle — oscillates –10° → +10° → 0° across the three phases.
    @State var rotationAngle: Angle = Angle.degrees(-4)
    /// Fades to 0 at `animationDuration × 1.5` to make the bubble disappear.
    @State var opacity: Double = 1

    /// Bound from the parent `LikeView`; starts the float when `true`.
    @Binding var isAnimating: Bool
    
    var body: some View {
        ZStack{
            Capsule(style: .circular)
                .fill(Color.likeColor)
            HStack {
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(Color.white)
                    .font(.system(size: 52, weight: .bold, design: .monospaced))
                Text("1")
                    .foregroundColor(.white)
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                Spacer()
            }
        }.frame(width: 165, height: 130, alignment: .center)
        .rotationEffect(rotationAngle)
        .scaleEffect(scale)
        .offset(offset)
        .opacity(opacity)
        .onAppear() {
            self.scale = 0.1
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { checkingTimer in
                if (isAnimating) {
                    checkingTimer.invalidate()
                    floatCapsule()
                }
            }
        }
    }
    
    // MARK:- functions

    /// Animates the "+1" bubble through three upward phases with left/right sway,
    /// then fades it out at the end.
    func floatCapsule() {
        withAnimation(animation) {
            self.scale = 0.75
            self.offset = CGSize(width: 10, height: -100)
            self.rotationAngle = .degrees(-10)
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(animation) {
                self.offset = CGSize(width: -10, height: -200)
            }
            withAnimation(Animation.spring(response: animationDuration * 1.2).speed(0.75)) {
                self.rotationAngle = .degrees(10)
            }
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration , repeats: false) { _ in
            withAnimation(animation) {
                self.offset = CGSize(width: 0, height: -300)
                self.rotationAngle = .degrees(0)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.5, repeats: false) { _ in
            withAnimation(animation) {
                self.opacity = 0
            }
        }
    }
}

struct FloatingLike_Previews: PreviewProvider {
    static var previews: some View {
        FloatingLike(isAnimating: .constant(true))
    }
}
