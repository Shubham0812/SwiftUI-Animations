//
//  WifiView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 10/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An interactive Wi-Fi signal animation that simulates scanning and connecting.
///
/// Displays three concentric `ArcView` arcs and a central dot. Tapping the widget
/// launches a scanning animation where the arcs oscillate up and down. After
/// `animationDuration × 12`, the arcs turn green (`wifiConnected`) and a particle
/// burst (`CircleEmitter`) celebrates the simulated connection.
///
/// **State machine (simplified):**
/// ```
/// idle  →[tap]→  searching  →[12× duration]→  connected  →[brief burst]→  idle-connected
/// ```
/// Three overlapping repeating timers drive the arc oscillation during the searching phase.
struct WifiView: View {

    // MARK:- variables

    /// `true` while the arcs are oscillating in the scanning phase.
    @State var isAnimating: Bool = false
    /// `true` for a brief window after connection to trigger the `CircleEmitter` particle burst.
    @State var isConnected: Bool = false

    /// Vertical offset of the central dot — bounces between –25 and +20 pt during scanning.
    @State var circleOffset: CGFloat = 20
    /// Vertical offset of the small (innermost) arc.
    @State var smallArcOffset: CGFloat = 16
    /// Vertical offset of the medium arc — oscillates on a 2× timer period.
    @State var mediumArcOffset: CGFloat = 14.5
    /// Vertical offset of the large (outermost) arc — oscillates on a 3× timer period.
    @State var largeArcOffset: CGFloat = 14

    /// Fill color of all arcs — white during scanning, green (`wifiConnected`) on connection.
    @State var arcColor: Color = Color.white
    /// Shadow color for all arcs — blue during scanning, white on connection.
    @State var shadowColor: Color = Color.blue
    /// Label shown below the arcs — "Wi-Fi" → "Searching" → "Connected".
    @State var wifiHeaderLabel: String = "Wi-Fi"

    /// Static flag indicating whether the animation is currently moving upward.
    /// Shared across all three arc timers to synchronise direction changes.
    static var animationMovingUpwards: Bool = true
    /// Static flag used by the 3× timer to alternate the small arc direction.
    static var moveArc: Bool = true

    /// Base timer interval; all arc oscillation periods are multiples of this.
    var animationDuration: Double = 0.35
    
    var body: some View {
        ZStack {
            Color.wifiBackground
                .edgesIgnoringSafeArea(.all)
            CircleEmitter(isAnimating: $isConnected)
//                .offset(y: 90)
//                .frame(height: 300)
            ZStack {
                Circle()
                    .fill(self.arcColor)
                    .scaleEffect(0.075)
                    .shadow(color: Color.blue, radius: 5)
                    .offset(y: self.circleOffset)
                    .animation(Animation.easeOut(duration: animationDuration))
                ZStack {
                    ArcView(radius: 12, fillColor: $arcColor, shadowColor: $shadowColor)
                        .rotationEffect(getRotation(arcBoolean: Self.moveArc))
                        .offset(y: smallArcOffset)
                        .animation(Animation.easeOut(duration: self.animationDuration))
                    
                    ArcView(radius: 24, fillColor: $arcColor, shadowColor: $shadowColor)
                        .rotationEffect(getRotation(arcBoolean: Self.moveArc))
                        .offset(y: self.mediumArcOffset)
                        .animation(Animation.easeOut(duration: self.animationDuration).delay(self.animationDuration))
                    
                    
                    ArcView(radius: 36, fillColor: $arcColor, shadowColor: $shadowColor)
                        .rotationEffect(getRotation(arcBoolean: Self.moveArc))
                        .offset(y: self.largeArcOffset)
                        .animation(Animation.easeOut(duration: self.animationDuration).delay(self.animationDuration * 1.9))
                    Circle().stroke(style: StrokeStyle(lineWidth: 2.5))
                        .foregroundColor(Color.white)
                        .opacity(0.8)
                    Circle().fill(Color.blue.opacity(0.1))
                    Circle().fill(Color.blue.opacity(0.025))
                        .scaleEffect(self.isAnimating ? 5 : 0)
                        .animation(self.isAnimating ? Animation.easeIn(duration: animationDuration * 2.5).repeatForever(autoreverses: false) :Animation.linear(duration: 0)
                        )
                    
                }
            }.frame(height: 120)
            .onTapGesture {
                resetValues()
                animate()
                
                Timer.scheduledTimer(withTimeInterval: self.animationDuration * 12, repeats: false) { (_) in
                    self.restoreAnimation()
                    self.arcColor = Color.wifiConnected
                    self.shadowColor = Color.white.opacity(0.5)
                    self.wifiHeaderLabel = "Connected"
                    self.isConnected.toggle()
                    
                    Timer.scheduledTimer(withTimeInterval: self.animationDuration + 0.05, repeats: false) { (Timer) in
                        self.isConnected.toggle()
                    }
                }
            }
            Text(self.wifiHeaderLabel)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .opacity(self.isAnimating ? 0 : 1)
                .foregroundColor(Color.white)
                .offset(y: 100)
                .animation(self.isAnimating ? Animation.spring().speed(0.65).repeatForever(autoreverses: false) : Animation.linear(duration: 0).repeatCount(0))
        }
    }
    
    // MARK:- functions

    /// Returns the arc rotation during scanning. Currently only `+180°` is reachable
    /// (the second `else if` branch is unreachable due to identical condition).
    func getRotation(arcBoolean: Bool) -> Angle {
        if (self.isAnimating && arcBoolean) {
            return Angle.degrees(180)
        } else if (self.isAnimating && arcBoolean) {
            return Angle.degrees(-180)
        }
        return Angle.degrees(0)
    }
    
    /// Starts three overlapping repeating timers that drive the arc oscillation:
    /// - **1× timer**: moves the dot and small arc ±15 pt, reversing at ±25/+20 pt bounds.
    /// - **2× timer**: nudges the medium arc back upward every other tick.
    /// - **3× timer**: alternates `moveArc` and snaps small/medium/large offsets based on direction.
    /// All timers self-invalidate when `isAnimating` becomes `false`.
    func animate() {
        Timer.scheduledTimer(withTimeInterval: self.animationDuration, repeats: true) { (arcTimer) in
            if (self.isAnimating) {
                self.circleOffset += Self.animationMovingUpwards ? -15 : 15
                self.smallArcOffset += Self.moveArc ? -15 : 15
                if (self.circleOffset == -25) {
                    Self.animationMovingUpwards = false
                } else if (self.circleOffset == 20) {
                    Self.animationMovingUpwards = true
                }
                if (Self.moveArc) {
                    self.mediumArcOffset += -15
                }
            } else {
                arcTimer.invalidate()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: (self.animationDuration) * 2, repeats: true) { (arcTimer) in
            if (self.isAnimating) {
                self.mediumArcOffset += 15
            } else {
                arcTimer.invalidate()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: (self.animationDuration) * 3, repeats: true) { (arcTimer) in
            if (self.isAnimating) {
                Self.moveArc.toggle()
                self.smallArcOffset = !Self.moveArc ? -15 : 8.5
                if (Self.animationMovingUpwards) {
                    self.largeArcOffset = -19
                    self.mediumArcOffset = -5.5
                } else {
                    self.largeArcOffset = 14
                    self.mediumArcOffset = 0
                }
            } else {
                arcTimer.invalidate()
            }
        }
    }
    
    /// Resets all animation state to the initial idle position, ready for the next tap.
    func restoreAnimation() {
        self.isAnimating = false
        Self.animationMovingUpwards = true
        Self.moveArc = true
        
        self.circleOffset = 20
        self.smallArcOffset = 16
        self.mediumArcOffset = 14.5
        self.largeArcOffset = 14
    }
    
    /// Begins the scanning phase: toggles `isAnimating`, sets label to "Searching",
    /// and snaps the arc offsets to their initial upward positions.
    func resetValues() {
        self.isAnimating.toggle()
        self.wifiHeaderLabel = "Searching"
        self.smallArcOffset -= 7.5
        self.circleOffset -= 15
        self.mediumArcOffset = -5.5
        self.largeArcOffset = -19
        self.isConnected = false
        self.arcColor = Color.white
        self.shadowColor = Color.blue
    }
}

struct WifiView_Previews: PreviewProvider {
    static var previews: some View {
        WifiView()
    }
}
