//
//  SpinningView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/03/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI



/// Keyframe rotation angles used during the spinner animation.
///
/// Angles are expressed in degrees > 360 deliberately — SwiftUI interpolates
/// through the full rotation rather than taking the shortest path, which is
/// what produces the continuous sweeping motion rather than a snap or reverse.
///
/// The progression from `initialCircle` (365°) → `middle` (375°/825°) → `last` (990°)
/// means each arc always rotates forward (clockwise), never backwards.
enum RotationDegrees {
    
    // ── Large arc keyframes ───────────────────────────────────────────────────
    case initialCicle      // End of Phase 1 rotation for the large arc
    case middleCircle      // Mid-cycle nudge position for the large arc
    
    // ── Small arc keyframes ───────────────────────────────────────────────────
    case initialSmallCircle   // End of Phase 1 rotation for the small arc
    case middleSmallCircle    // Mid-cycle nudge position for the small arc
    
    // ── Shared final keyframe ─────────────────────────────────────────────────
    case last  // Both arcs rotate to this angle in Phase 3, creating the handoff effect
    
    /// Returns the `Angle` for this keyframe.
    /// Values deliberately exceed 360° to force continuous forward rotation
    /// through SwiftUI's animation interpolation.
    func getRotationDegrees() -> Angle {
        switch self {
        case .initialCicle:
            return .degrees(365)    // Just past one full rotation
        case .initialSmallCircle:
            return .degrees(679)    // ~1.9 rotations — small arc sweeps faster
            
        case .middleCircle:
            return .degrees(375)    // Slight nudge beyond initialCircle
        case .middleSmallCircle:
            return .degrees(825)    // Continued fast sweep for the small arc
            
        case .last:
            return .degrees(990)    // ~2.75 rotations — shared landing angle for both arcs
        }
    }
}


/// An animated spinner consisting of two arcs — a large outer circle and a small inner circle —
/// that take turns expanding and collapsing in a looping sequence.
///
/// **Animation choreography (one cycle = `animationDuration * 1.98`):**
/// ```
/// t = 0              Large arc expands (0→1) + rotates to initialCircle
///                    Small arc collapses (1→0) + rotates to initialSmallCircle
///
/// t = duration×0.7   Both arcs nudge rotation (middleCircle / middleSmallCircle)
///                    — adds a subtle bounce/ease in the middle of the sweep
///
/// t = duration×1.0   Large arc collapses (1→0) + rotates to last
///                    Small arc expands (0→1)    + rotates to last
///
/// t = duration×1.98  reset() snaps both rotations back to their start angles (no animation),
///                    then animate() fires again for the next loop
/// ```
/// The overlap between the large arc's collapse and the small arc's expansion
/// is what creates the fluid "handoff" effect between the two circles.
struct SpinningView: View {
    
    // MARK: - Variables
    
    // ── Large circle state ────────────────────────────────────────────────────
    
    /// Trim end value for the large arc (0.001 = invisible, 1 = full circle).
    /// Starts near-zero so the arc appears to grow from nothing on the first frame.
    @State var circleEnd: CGFloat = 0.001
    
    /// Rotation angle for the large arc.
    /// Starts at –90° (12 o'clock) so the trim begins at the top of the circle.
    @State var rotationDegree: Angle = Angle.degrees(-90)
    
    // ── Small circle state ────────────────────────────────────────────────────
    
    /// Trim end value for the small arc (starts at 1 = fully visible,
    /// then collapses to 0.001 when the large arc takes over).
    @State var smallerCircleEnd: CGFloat = 1
    
    /// Rotation angle for the small arc.
    /// Starts at –30° (slightly offset from 12 o'clock for visual variety).
    @State var smallerRotationDegree: Angle = Angle.degrees(-30)
    
    // ── Timing constants ──────────────────────────────────────────────────────
    
    /// Unused in the current implementation — reserved for a future tracker rotation feature.
    let trackerRotation: Double = 1
    
    /// Base duration for one animation phase. All other timings are multiples of this.
    /// One full cycle = `animationDuration * 1.98`.
    let animationDuration: Double = 1.35
    
    // MARK: - Views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                // ── Large arc ─────────────────────────────────────────────────
                // Outer ring, 130pt diameter, 18pt stroke.
                // Expands and rotates during the first half of each cycle,
                // then collapses during the second half as the small arc takes over.
                Circle()
                    .trim(from: 0, to: circleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .fill(Color.white)
                    .rotationEffect(self.rotationDegree)
                    .frame(width: 130, height: 130)
                
                // ── Small arc ─────────────────────────────────────────────────
                // Inner ring, 48pt diameter, same stroke weight.
                // Collapses while the large arc expands, then expands again as
                // the large arc collapses — the two arcs trade off in sequence.
                // Slightly dimmer (opacity 0.9) to visually distinguish the two.
                Circle()
                    .trim(from: 0, to: smallerCircleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .fill(Color.white.opacity(0.9))
                    .rotationEffect(self.smallerRotationDegree)
                    .frame(width: 48, height: 48)
            }
            .offset(y: -48) // Shift the spinner upward to give visual breathing room above the watermark
            
            // ── Watermark ─────────────────────────────────────────────────────
            Text("@shubham_iosdev")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium, design: .monospaced))
                .opacity(0.7)
                .offset(x: 96, y: 380)
            
            // ── Animation lifecycle ───────────────────────────────────────────
            // Kick off immediately on appear, then repeat every 1.98× duration.
            // The 1.98 multiplier is tuned so reset() + animate() fire just as
            // the previous cycle's final animation finishes — no visible gap or overlap.
                .onAppear() {
                    animate()
                    Timer.scheduledTimer(withTimeInterval: animationDuration * 1.98, repeats: true) { _ in
                        // Snap rotations back to start (no animation — both arcs are near-invisible
                        // at this point in the cycle, so the jump produces no visible flicker)
                        reset()
                        animate()
                    }
                }
        }
    }
    
    // MARK: - Functions
    
    /// Runs one full animation cycle across three timed phases:
    ///
    /// **Phase 1 (t = 0)** — Large arc expands, small arc collapses simultaneously.
    ///
    /// **Phase 2 (t = duration × 0.7)** — Both arcs nudge their rotation angles
    /// mid-sweep. This adds a subtle acceleration bump that prevents the motion
    /// from feeling overly linear.
    ///
    /// **Phase 3 (t = duration × 1.0)** — Large arc collapses, small arc expands.
    /// Both rotate to the same final angle, visually "handing off" motion
    /// from the large arc to the small arc.
    func animate() {
        
        // ── Phase 1: Large arc expands, small arc collapses ───────────────────
        
        // Large arc grows from near-zero to full and sweeps to its initial angle
        withAnimation(Animation.easeOut(duration: animationDuration)) {
            self.circleEnd = 1
        }
        withAnimation(Animation.easeOut(duration: animationDuration * 1.1)) {
            self.rotationDegree = RotationDegrees.initialCicle.getRotationDegrees()
        }
        
        // Small arc simultaneously collapses and sweeps away
        withAnimation(Animation.easeOut(duration: animationDuration * 0.85)) {
            self.smallerCircleEnd = 0.001
            self.smallerRotationDegree = RotationDegrees.initialSmallCircle.getRotationDegrees()
        }
        
        // ── Phase 2: Mid-cycle rotation nudge (both arcs) ────────────────────
        // Fires at 70% through the base duration — while both arcs are mid-sweep.
        // The extra rotation bump creates a subtle elastic quality to the motion.
        Timer.scheduledTimer(withTimeInterval: animationDuration * 0.7, repeats: false) { _ in
            withAnimation(Animation.easeIn(duration: animationDuration * 0.4)) {
                self.smallerRotationDegree = RotationDegrees.middleSmallCircle.getRotationDegrees()
                self.rotationDegree        = RotationDegrees.middleCircle.getRotationDegrees()
            }
        }
        
        // ── Phase 3: Large arc collapses, small arc expands ───────────────────
        // Fires at 100% of base duration. Both arcs rotate to the same final angle
        // so they appear to meet and hand off to one another seamlessly.
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            // Large arc collapses with easeOut (decelerates as it disappears)
            withAnimation(Animation.easeOut(duration: animationDuration)) {
                self.rotationDegree = RotationDegrees.last.getRotationDegrees()
                self.circleEnd      = 0.001
            }
            // Small arc expands with linear timing to counterbalance the large arc's easeOut
            withAnimation(Animation.linear(duration: animationDuration * 0.8)) {
                self.smallerCircleEnd      = 1
                self.smallerRotationDegree = RotationDegrees.last.getRotationDegrees()
            }
        }
    }
    
    /// Snaps both arcs back to their initial rotation angles without animation.
    ///
    /// Called just before `animate()` at the start of each new cycle.
    /// The snap is invisible because both arcs are at near-zero trim (0.001)
    /// at the point in the cycle where `reset()` fires — so there's nothing
    /// visible to jump.
    func reset() {
        self.rotationDegree        = .degrees(-90)   // Large arc back to 12 o'clock
        self.smallerRotationDegree = .degrees(-30)   // Small arc back to slightly offset start
    }
}

#Preview {
    ZStack {
        SpinningView()
    }
}
