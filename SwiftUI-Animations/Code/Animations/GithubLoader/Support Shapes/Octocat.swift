//
//  OctocatShape.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 14/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A SwiftUI `Shape` that draws the GitHub Octocat silhouette using absolute coordinates.
///
/// > Note from the author: "phew, had to do a lot of hit and trials for this xD"
///
/// Unlike `OctocatShape` (which offsets every point from `rect.midX/midY`),
/// this version uses **fixed absolute coordinates** — meaning it's sized for
/// one specific frame and won't scale or reposition automatically if the frame changes.
/// Use a fixed `.frame()` matching the original coordinate space, or wrap it in a
/// `GeometryReader` and apply a scale transform if you need it to resize.
///
/// The path is drawn in four named sections:
/// **right side → center crown → left side → tail**
///
/// Designed for `.stroke()` use — the tail is a separate open sub-path
/// and won't close cleanly as a filled shape.
struct Octocat: Shape {
    
    // MARK:- variables
    
    // MARK:- functions
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        // ── Entry point ───────────────────────────────────────────────────────
        // Start at the bottom-right of the body (right leg base)
        path.move(to: CGPoint(x: 243.77, y: 483.38))
        
        // ── Right side ────────────────────────────────────────────────────────
        // Traces up the right leg, through the hip curve, up the right body arc,
        // over the right shoulder, and up to the tip of the right ear.

        // Right leg — straight up to the hip
        path.addLine(to: CGPoint(x: 243.77, y: 441.77))
        path.addLine(to: CGPoint(x: 243.79, y: 441.46)) // Sub-pixel correction (export artifact)

        // Hip curve — transitions from the leg into the upper body
        path.addCurve(to: CGPoint(x: 233.25, y: 413.32),
                      control1: CGPoint(x: 244.53, y: 431),
                      control2: CGPoint(x: 240.68, y: 420.73))

        // Right body arc — sweeps outward and upward toward the head
        path.addCurve(to: CGPoint(x: 303, y: 338.47),
                      control1: CGPoint(x: 267.46, y: 409.95),
                      control2: CGPoint(x: 303,    y: 397.16))
        path.addLine(to: CGPoint(x: 303, y: 338.48)) // Redundant anchor (export artifact)

        // Right shoulder — curves inward and upward toward the right ear base
        path.addCurve(to: CGPoint(x: 286.56, y: 297.86),
                      control1: CGPoint(x: 303,    y: 323.32),
                      control2: CGPoint(x: 297.11, y: 308.76))
        path.addLine(to: CGPoint(x: 287, y: 297.74)) // Sub-pixel correction (export artifact)

        // Right ear — curves up to the ear tip and back down to the head crown
        path.addCurve(to: CGPoint(x: 285.57, y: 256.94),
                      control1: CGPoint(x: 291.84, y: 284.47),
                      control2: CGPoint(x: 291.33, y: 269.84))

        // Right ear base lands at the top-right of the head
        path.addCurve(to: CGPoint(x: 243.77, y: 273.54),
                      control1: CGPoint(x: 285.88, y: 257.63),
                      control2: CGPoint(x: 273.17, y: 253.87))

        // ── Center crown ──────────────────────────────────────────────────────
        // Smooth arc across the top of the head from right to left,
        // symmetrically connecting both ear bases.
        path.addLine(to: CGPoint(x: 243.37, y: 273.43)) // Sub-pixel correction (export artifact)
        path.addCurve(to: CGPoint(x: 168.78, y: 273.43),
                      control1: CGPoint(x: 218.94, y: 266.9),
                      control2: CGPoint(x: 193.21, y: 266.9))

        // ── Left side ─────────────────────────────────────────────────────────
        // Mirrors the right side: left ear tip → shoulder → body arc → hip → left leg

        // Left ear — descends from the head crown to the left ear tip
        path.addCurve(to: CGPoint(x: 126.28, y: 257.63),
                      control1: CGPoint(x: 138.98, y: 253.87),
                      control2: CGPoint(x: 126.28, y: 257.63))
        path.addLine(to: CGPoint(x: 126.2, y: 257.81)) // Sub-pixel correction (export artifact)

        // Left ear base back up to shoulder level
        path.addCurve(to: CGPoint(x: 125.49, y: 298.63),
                      control1: CGPoint(x: 120.67, y: 270.81),
                      control2: CGPoint(x: 120.42, y: 285.45))
        path.addLine(to: CGPoint(x: 125.6, y: 297.86)) // Sub-pixel correction (export artifact)

        // Left shoulder — mirrors the right shoulder curve
        path.addCurve(to: CGPoint(x: 109.15, y: 338.48),
                      control1: CGPoint(x: 115.05, y: 308.76),
                      control2: CGPoint(x: 109.15, y: 323.33))

        // Left body arc — sweeps down and inward toward the hip
        path.addCurve(to: CGPoint(x: 178.51, y: 414.04),
                      control1: CGPoint(x: 109.15, y: 397.06),
                      control2: CGPoint(x: 144.69, y: 409.85))
        path.addLine(to: CGPoint(x: 178.48, y: 414.07)) // Micro-correction point (export artifact)

        // Left hip curve — transitions from the body into the left leg
        path.addCurve(to: CGPoint(x: 168.38, y: 441.76),
                      control1: CGPoint(x: 171.34, y: 421.45),
                      control2: CGPoint(x: 167.67, y: 431.52))

        // Left leg — straight down to the foot, completing the main body outline
        path.addLine(to: CGPoint(x: 168.38, y: 483.38))

        // ── Tail ──────────────────────────────────────────────────────────────
        // A separate open sub-path — not connected to the body outline.
        // Starts partway up the left leg and curves out to the left,
        // forming the Octocat's characteristic tentacle/tail.
        path.move(to: CGPoint(x: 168.38, y: 451.13))
        path.addCurve(to: CGPoint(x: 93, y: 418.88),
                      control1: CGPoint(x: 114.54, y: 467.25),
                      control2: CGPoint(x: 114.54, y: 424.25))

        return path
    }
}

#Preview {
    Color.black
        .edgesIgnoringSafeArea(.all)
    
    OctocatShape()
        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 8))
        .foregroundColor(Color.white)
}
