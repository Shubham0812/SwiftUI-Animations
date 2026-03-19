//
//  InfinityView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 03/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An infinity-symbol (∞) loader that draws a dark "eraser" arc chasing a white glowing path.
///
/// The `InfinityShape` is rendered twice in the same frame:
/// - **Background**: full white stroke with a glow shadow — the complete ∞ outline.
/// - **Overlay**: a dark (`materialBlack`) trimmed arc that moves across the shape,
///   masking the white beneath it to create the illusion of a traveling light segment.
///
/// **Two-timer choreography:**
/// - A fast timer fires every `animationDuration` (0.2 s) and advances `strokeEnd` by 0.05,
///   keeping `strokeStart` 0.05 + `additionalLength` behind. When `strokeEnd` reaches
///   `animationCap` (1.205 — slightly past 1.0 to handle the path endpoint), everything resets.
/// - A slow timer fires every `animationDuration × 3` (0.6 s) and grows `additionalLength` by 0.015,
///   gradually lengthening the visible white tail until the next reset.
struct InfinityView: View {

    // MARK: - Variables

    /// Interval for the fast advance timer. Each tick moves `strokeEnd` forward by 0.05.
    let animationDuration: TimeInterval = 0.2
    /// Stroke width of both the white glow and the dark eraser overlay.
    let strokeWidth: CGFloat = 20
    /// Reset threshold for `strokeEnd`. Slightly above 1.0 ensures the arc cleanly exits
    /// the path endpoint before wrapping — avoids a visible seam at the ∞ crossover.
    let animationCap: CGFloat = 1.205

    /// Leading edge of the dark eraser arc (moves forward each tick).
    @State var strokeStart: CGFloat = 0
    /// Trailing edge of the dark eraser arc — always `strokeEnd - (0.05 + additionalLength)`.
    @State var strokeEnd: CGFloat = 0
    /// Grows over time via the slow timer, elongating the visible white tail segment.
    @State var additionalLength: CGFloat = 0

    // MARK: - Views

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            InfinityShape()
                .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.white)
                .shadow(color: .white, radius: 4)
                .overlay(
                    InfinityShape()
                        .trim(from: strokeStart, to: strokeEnd)
                        .stroke(style: StrokeStyle(lineWidth: strokeWidth - 0.5, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(Color.materialBlack)
                        .shadow(color: .white, radius: 5)
                )
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                withAnimation(.linear(duration: animationDuration)) {
                    strokeEnd += 0.05
                    strokeStart = strokeEnd - (0.05 + additionalLength)
                }

                if strokeEnd >= animationCap {
                    strokeEnd = 0
                    additionalLength = 0
                    strokeStart = 0
                }
            }

            Timer.scheduledTimer(withTimeInterval: animationDuration * 3, repeats: true) { _ in
                additionalLength += 0.015
            }
        }
    }
}

#Preview {
    InfinityView()
}
