//
//  GithubLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 14/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An animated GitHub Octocat loader that traces a glowing stroke segment
/// around the Octocat silhouette in a continuous loop.
///
/// Two `OctocatShape` layers are stacked:
/// - A dim, full-outline ghost (opacity 0.35) — always visible as a guide track
/// - A brighter, trimmed segment that travels around the path like a comet
///
/// The animation is driven by a repeating `Timer` that increments `strokeEnd`
/// every 0.35s, dragging `strokeStart` 0.3 units behind it to form a
/// fixed-length glowing arc. When `strokeEnd` reaches 1.0, the stroke
/// resets after a 1-second pause before looping again.
struct GithubLoader: View {
    
    // MARK: - Variables
    
    /// Guards against the reset firing more than once per loop cycle.
    /// Set to `false` the moment a reset is scheduled, then flipped back
    /// to `true` after the stroke values are zeroed out.
    @State var resetStrokes: Bool = true
    
    /// Leading edge of the travelling stroke segment (0–1 along the path).
    @State var strokeStart: CGFloat = 0
    
    /// Trailing edge of the travelling stroke segment (0–1 along the path).
    /// Incremented by 0.1 on every timer tick; `strokeStart` follows
    /// 0.3 units behind to maintain a constant arc length.
    @State var strokeEnd: CGFloat = 0
    
    
    // MARK: - Views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // ── Ghost track ───────────────────────────────────────────────────
            // Full Octocat outline at low opacity — gives the travelling
            // stroke a visible "rail" to run along, like an unlit neon tube.
            ZStack {
                OctocatShape()
                    .stroke(style: StrokeStyle(lineWidth: 4.5, lineCap: .round, lineJoin: .round, miterLimit: 5))
                    .foregroundColor(Color.white)
                    .opacity(0.35)
                
                // ── Travelling stroke ─────────────────────────────────────────────
                // Brighter, thicker segment trimmed to [strokeStart, strokeEnd].
                // Animates smoothly between timer ticks via `.easeOut`.
                OctocatShape()
                    .trim(from: strokeStart, to: strokeEnd)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 10))
                    .foregroundColor(Color.white)
                    .onAppear() {
                        // Tick every 0.35s — drives the stroke forward by 0.1 units per tick.
                        // Each tick also re-evaluates whether a loop reset is needed.
                        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { timer in
                            
                            // ── Reset logic ───────────────────────────────────────
                            // Once the stroke has fully traversed the path (strokeEnd ≥ 1),
                            // schedule a one-shot timer to zero both values after a short pause,
                            // creating a visible "rest" moment before the next loop starts.
                            // `resetStrokes` prevents this block from firing repeatedly on
                            // subsequent ticks while the 1-second delay is still pending.
                            if (self.strokeEnd >= 1) {
                                if (self.resetStrokes) {
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                        self.strokeEnd = 0
                                        self.strokeStart = 0
                                        self.resetStrokes.toggle() // Re-arm for the next cycle
                                    }
                                    self.resetStrokes = false // Block re-entry until reset completes
                                }
                            }
                            
                            // ── Advance the stroke ────────────────────────────────
                            // Increment both ends together so the arc length stays
                            // fixed at 0.3 (strokeEnd - strokeStart = constant).
                            // easeOut softens the deceleration at the end of each tick step.
                            withAnimation(Animation.easeOut(duration: 0.5)) {
                                self.strokeEnd   += 0.1
                                self.strokeStart  = self.strokeEnd - 0.3
                            }
                        }
                    }
            }
            .scaleEffect(2)
            
            
            // ── Watermark ─────────────────────────────────────────────────────
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("@Shubham_iosdev")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .medium, design: .monospaced))
                        .opacity(0.3)
                }.padding(.trailing, 16)
            }
        }
    }
}

struct InfinityLoader_Previews: PreviewProvider {
    static var previews: some View {
        GithubLoader()
    }
}
