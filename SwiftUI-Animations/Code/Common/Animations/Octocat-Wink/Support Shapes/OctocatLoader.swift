//
//  OctocatLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 12/10/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A SwiftUI `Shape` that draws the GitHub Octocat silhouette as a single stroked path.
///
/// Like `YinYangShape`, all coordinates are offset from the bounding rect's center
/// (`cX`, `cY`) so the symbol scales and repositions correctly in any frame.
///
/// The path is drawn in four named sections that trace the outline clockwise:
/// **right side → top arc → left side → tail**
///
/// Intended to be used with `.stroke()` rather than `.fill()` — the tail is a
/// separate open sub-path and won't close cleanly as a filled shape.
struct OctocatShape: Shape {
    
    // MARK: - Functions
    func path(in rect: CGRect) -> Path {
        
        // Center of the bounding rect — every coordinate is relative to this point
        let cX: CGFloat = rect.midX
        let cY: CGFloat = rect.midY
        
        var path = Path()
        
        // ── Entry point ───────────────────────────────────────────────────────
        // Start at the bottom-right of the body (right leg base)
        path.move(to: CGPoint(x: cX + 24.07, y: cY + 77.5))
        
        // ── Right side ────────────────────────────────────────────────────────
        // Traces up the right leg, through the right shoulder curve,
        // then sweeps inward to the top of the right "ear"
        
        // Right leg — straight up to the hip
        path.addLine(to: CGPoint(x: cX + 24.07, y: cY + 52.94))
        path.addLine(to: CGPoint(x: cX + 24.06, y: cY + 53.12)) // Micro-correction point (export artifact)
        
        // Hip curve — transitions from the leg into the upper body
        path.addCurve(to: CGPoint(x: cX + 18.14, y: cY + 36.4),
                      control1: CGPoint(x: cX + 24.6,  y: cY + 46.95),
                      control2: CGPoint(x: cX + 22.44, y: cY + 40.85))
        
        // Right body arc — sweeps up and right toward the head
        path.addCurve(to: CGPoint(x: cX + 58.99, y: cY + -8.06),
                      control1: CGPoint(x: cX + 38.04, y: cY + 34.15),
                      control2: CGPoint(x: cX + 58.99, y: cY + 26.6))
        path.addLine(to: CGPoint(x: cX + 58.99, y: cY + -8.06)) // Redundant anchor (export artifact)
        
        // Right shoulder — curves upward toward the right ear base
        path.addCurve(to: CGPoint(x: cX + 49.3,  y: cY + -32.04),
                      control1: CGPoint(x: cX + 58.99, y: cY + -17),
                      control2: CGPoint(x: cX + 55.52, y: cY + -25.6))
        path.addLine(to: CGPoint(x: cX + 49.56, y: cY + -32.1)) // Sub-pixel correction (export artifact)
        
        // Right ear — curves up to the ear tip then back down to the head top
        path.addCurve(to: CGPoint(x: cX + 48.72, y: cY + -56.2),
                      control1: CGPoint(x: cX + 52.41, y: cY + -39.94),
                      control2: CGPoint(x: cX + 52.11, y: cY + -48.58))
        
        // Right ear base meets the top of the head
        path.addCurve(to: CGPoint(x: cX + 24.08, y: cY + -46.4),
                      control1: CGPoint(x: cX + 48.9,  y: cY + -55.79),
                      control2: CGPoint(x: cX + 41.41, y: cY + -58.02))
        path.addLine(to: CGPoint(x: cX + 23.84, y: cY + -46.46)) // Sub-pixel correction (export artifact)
        
        // ── Top arc ───────────────────────────────────────────────────────────
        // Smooth curve across the crown of the head from right to left,
        // connecting the right ear base to the left ear base symmetrically
        path.addCurve(to: CGPoint(x: cX + -20.12, y: cY + -46.46),
                      control1: CGPoint(x: cX + 9.44,  y: cY + -50.32),
                      control2: CGPoint(x: cX + -5.72, y: cY + -50.32))
        
        // ── Left side ─────────────────────────────────────────────────────────
        // Mirrors the right side: left ear tip → shoulder → body arc → hip → left leg
        
        // Left ear — descends from the head top to the left ear tip
        path.addCurve(to: CGPoint(x: cX + -45.17, y: cY + -55.79),
                      control1: CGPoint(x: cX + -37.69, y: cY + -58.01),
                      control2: CGPoint(x: cX + -45.11, y: cY + -55.79))
        path.addLine(to: CGPoint(x: cX + -45.22, y: cY + -55.69)) // Sub-pixel correction (export artifact)
        
        // Left ear base back to shoulder level
        path.addCurve(to: CGPoint(x: cX + -45.64, y: cY + -31.58),
                      control1: CGPoint(x: cX + -48.48, y: cY + -48.01),
                      control2: CGPoint(x: cX + -48.63, y: cY + -39.37))
        path.addLine(to: CGPoint(x: cX + -45.58, y: cY + -32.04)) // Sub-pixel correction (export artifact)
        
        // Left shoulder — mirrors the right shoulder curve
        path.addCurve(to: CGPoint(x: cX + -55.27, y: cY + -8.05),
                      control1: CGPoint(x: cX + -51.79, y: cY + -25.6),
                      control2: CGPoint(x: cX + -55.27, y: cY + -17))
        
        // Left body arc — sweeps down and inward toward the hip
        path.addCurve(to: CGPoint(x: cX + -14.39, y: cY + 36.56),
                      control1: CGPoint(x: cX + -55.27, y: cY + 26.53),
                      control2: CGPoint(x: cX + -34.32, y: cY + 34.09))
        path.addLine(to: CGPoint(x: cX + -14.4,  y: cY + 36.58)) // Micro-correction point (export artifact)
        
        // Left hip curve — transitions from the body into the left leg
        path.addCurve(to: CGPoint(x: cX + -20.36, y: cY + 52.93),
                      control1: CGPoint(x: cX + -18.62, y: cY + 40.94),
                      control2: CGPoint(x: cX + -20.78, y: cY + 46.88))
        
        // Left leg — straight down to the foot, closing the main body outline
        path.addLine(to: CGPoint(x: cX + -20.36, y: cY + 77.5))
        
        // ── Tail ──────────────────────────────────────────────────────────────
        // A separate open sub-path — not connected to the body outline above.
        // Starts mid-way up the left leg and curves out to the left,
        // forming the Octocat's characteristic tentacle/tail.
        path.move(to: CGPoint(x: cX + -20.36, y: cY + 58.46))
        path.addCurve(to: CGPoint(x: cX + -64.79, y: cY + 39.42),
                      control1: CGPoint(x: cX + -52.09, y: cY + 67.98),
                      control2: CGPoint(x: cX + -52.09, y: cY + 42.59))
        
        return path
    }
}

#Preview {
    ZStack {
        Color.black
        
        OctocatShape()
        //  .trim(from: 0, to: 0.2)  // Useful for debugging — reveals path draw order
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 8))
            .foregroundStyle(.white)
    }
}
