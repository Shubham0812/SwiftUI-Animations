//
//  CircleLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A circular progress loader with a colored arc that sweeps and expands on a white background.
///
/// The animation runs in four timed phases per cycle:
/// 1. Spring: snaps the arc back to a start angle with a spring bounce
/// 2. Sweep: rotates the arc ~2 full turns (720° + 120°) via `getRotationAngle()`
/// 3. Expand: grows `circleEnd` from 0.325 to 0.925 (arc covers ¾ of the ring)
/// 4. Collapse: resets the rotation and snaps `circleEnd` back to 0.325
///
/// The outer track ring (`circleTrackGradient`) is always fully visible; the
/// colored arc (`circleRoundGradient`) trims on top of it with rounded caps.
struct CircleLoader: View {

    // MARK:- variables

    /// Gradient used for the static background track ring.
    let circleTrackGradient = LinearGradient(gradient: .init(colors: [Color.circleTrackStart, Color.circleTrackEnd]), startPoint: .leading, endPoint: .bottomLeading)
    /// Gradient used for the animated foreground arc.
    let circleRoundGradient = LinearGradient(gradient: .init(colors: [Color.circleRoundStart, Color.circleRoundEnd]), startPoint: .topLeading, endPoint: .trailing)

    /// Number of full rotations during the sweep phase. Multiplied by 360° in `getRotationAngle()`.
    let trackerRotation: Double = 2
    /// Base duration for one animation phase. The full cycle repeats every `trackerRotation × animationDuration + animationDuration`.
    let animationDuration: Double = 0.75

    /// Controls whether the loader is currently animating (unused as a branch; reserved).
    @State var isAnimating: Bool = false
    /// Fixed trim start of the arc (stays constant throughout the animation).
    @State var circleStart: CGFloat = 0.17
    /// Trim end of the arc — expands to 0.925 during the sweep, then snaps back to 0.325.
    @State var circleEnd: CGFloat = 0.325

    /// Current rotation angle of the foreground arc.
    @State var rotationDegree: Angle = Angle.degrees(0)
    
     // MARK:- views
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 20))
                    .fill(circleTrackGradient)
                Circle()
                    .trim(from: circleStart, to: circleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .fill(circleRoundGradient)
                    .rotationEffect(self.rotationDegree)
            }.frame(width: 200, height: 200)
            .onAppear() {
                self.animateLoader()
                Timer.scheduledTimer(withTimeInterval: self.trackerRotation * self.animationDuration + (self.animationDuration), repeats: true) { (mainTimer) in
                    self.animateLoader()
                }
            }
        }
    }
    
    // MARK:- functions

    /// Returns the total rotation for the sweep phase: `trackerRotation` full turns plus an extra 120°.
    /// The extra 120° ensures the arc visually "lands" at a different position each cycle,
    /// which disguises the seamless loop and makes the animation feel continuous.
    func getRotationAngle() -> Angle {
        return .degrees(360 * self.trackerRotation) + .degrees(120)
    }

    /// Runs one animation cycle across four staggered timer phases:
    ///
    /// - **t = 0**: Spring-snaps `rotationDegree` to –57.5° (slightly before 12 o'clock).
    /// - **t = animationDuration**: Eases the arc through `getRotationAngle()` (720° + 120°).
    /// - **t = animationDuration × 1.25**: Expands `circleEnd` to 0.925 at half the sweep duration.
    /// - **t = trackerRotation × animationDuration**: Snaps `rotationDegree` to 47.5° and
    ///   collapses `circleEnd` back to 0.325 — ready for the next cycle.
    func animateLoader() {
        withAnimation(Animation.spring(response: animationDuration * 2 )) {
            self.rotationDegree = .degrees(-57.5)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: self.trackerRotation * self.animationDuration)) {
                self.rotationDegree += self.getRotationAngle()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            withAnimation(Animation.easeOut(duration: (self.trackerRotation * self.animationDuration) / 2.25 )) {
                self.circleEnd = 0.925
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration, repeats: false) { _ in
            self.rotationDegree = .degrees(47.5)
            withAnimation(Animation.easeOut(duration: self.animationDuration)) {
                self.circleEnd = 0.325
            }
        }
    }
}

struct CircleLoader_Previews: PreviewProvider {
    static var previews: some View {
        CircleLoader()
    }
}
