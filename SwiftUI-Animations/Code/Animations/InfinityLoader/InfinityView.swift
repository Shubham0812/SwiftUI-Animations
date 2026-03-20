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
    let strokeWidth: CGFloat = 20
    let duration: Double = 2.0
    
    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            InfinityShape()
                .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.gray)
                .opacity(0.4)
            
            // Layer 1: The Main Stroke
            renderStroke(from: phase - 0.1, to: phase)
            
            // Layer 2: The "Wrap-Around" Stroke
            // When phase is 0.1, this draws from -0.1 to 0.1
            // When phase is 0.9, this draws from 0.7 to 0.9
            // By adding/subtracting 1.0, we catch the "overflow"
            renderStroke(from: phase - 1.2, to: phase - 1.0)
            renderStroke(from: phase + 0.9, to: phase + 1.0)
        }
        .onAppear {
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                phase = 1.0
            }
        }
    }

    @ViewBuilder
    private func renderStroke(from: CGFloat, to: CGFloat) -> some View {
        InfinityShape()
            .trim(from: from, to: to)
            .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
            .foregroundStyle(.white)
    }
}

#Preview {
    InfinityView()
}
