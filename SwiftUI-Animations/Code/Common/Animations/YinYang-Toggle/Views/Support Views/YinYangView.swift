//
//  YinYangView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 02/09/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A self-animating yin-yang view that plays a two-stage entrance sequence:
///
/// **Stage 1** — A stroked outline of the shape draws itself on (trim 0→1),
/// then fades out once complete.
///
/// **Stage 2** — The fully filled yin-yang fades in, followed by the two
/// small accent circles (one black, one white) that draw and fill in sequence.
///
/// All timing is driven by `animationDuration` and `viewAppeared`, which is
/// flipped once in `onAppear`.
struct YinYangView: View {
    
    // MARK: - Variables
    
    /// Flipped to `true` on appear — acts as the single source of truth
    /// that drives every animation in this view.
    @State var viewAppeared = false
    
    /// Uniform scale multiplier applied to the shape and all overlays.
    /// Increase this to embed a larger symbol without changing any other values.
    var scale: CGFloat = 1
    
    /// Diameter of the outer bounding circle, before `scale` is applied.
    var size: CGFloat = 100
    
    /// Vertical offset for the small **black** dot (yin side).
    /// Positive moves it downward; adjust if you change `scale`.
    var yYingOffset: CGFloat = -15
    
    /// Vertical offset for the small **white** dot (yang side).
    /// Positive moves it downward; adjust if you change `scale`.
    var yYangOffset: CGFloat = 20
    
    /// Base duration for a single animation step.
    /// All staggered delays are multiples of this value.
    let animationDuration: TimeInterval = 0.5
    
    // MARK: - Views
    var body: some View {
        ZStack {
            
            // ── Stage 1: Self-drawing outline ────────────────────────────────
            // Renders the yin-yang as a thin stroke that trims from 0→1,
            // giving the illusion of the shape "drawing itself" on screen.
            // Once the trim completes, this layer fades out so Stage 2 can take over.
            YinYangShape()
                .trim(from: 0, to: viewAppeared ? 1 : 0)
                .stroke(lineWidth: 2)
                .scaleEffect(scale)
                // Trim animation — draws the outline over `animationDuration`
                .animation(.easeInOut(duration: animationDuration), value: viewAppeared)
                // Fade-out animation — begins after the draw completes
                .opacity(viewAppeared ? 0 : 1)
                .animation(.smooth(duration: animationDuration / 2).delay(animationDuration), value: viewAppeared)
            
            // ── Stage 2: Filled symbol + accent dots ─────────────────────────
            // The solid yin-yang fades in after Stage 1 finishes, then two small
            // circles (the classic yin-yang dots) draw and fill in sequence.
            YinYangShape()
                .scaleEffect(scale)
                // Outer ring stroke — gives the symbol a clean circular border
                .overlay {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: size * scale, height: size * scale)
                        .offset(x: 2, y: 2)
                }
                // White backing circle — sits behind the shape to prevent the dark
                // background from showing through the white (yang) half of the shape
                .background {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: size * scale, height: size * scale)
                        .offset(y: 2)
                }
                // Fade the filled symbol in after Stage 1's draw animation finishes
                .opacity(viewAppeared ? 1 : 0)
                .animation(.smooth.delay(animationDuration), value: viewAppeared)
            
                // ── Yin dot (black) ───────────────────────────────────────────
                // Small black circle on the light (yang) half.
                // First the stroke draws itself, then the fill fades in.
                .overlay {
                    ZStack {
                        // Stroke draws itself (trim 0→1)
                        Circle()
                            .trim(from: 0, to: viewAppeared ? 1 : 0)
                            .stroke(lineWidth: 2)
                            .animation(.snappy.delay(animationDuration * 1.2), value: viewAppeared)
                        // Fill fades in slightly after the stroke completes
                        Circle()
                            .opacity(viewAppeared ? 1 : 0)
                            .animation(.smooth.delay(animationDuration * 1.5), value: viewAppeared)
                    }
                    .frame(width: 11.5 * scale)
                    // Negated so that a positive `yYingOffset` moves the dot upward
                    // toward the light half of the symbol. Adjust alongside `scale`.
                    .offset(y: -yYingOffset)
                }
            
                // ── Yang dot (white) ──────────────────────────────────────────
                // Small white circle on the dark (yin) half.
                // Draws and fills with a slightly longer delay than the yin dot,
                // so both accent circles animate in sequence rather than together.
                .overlay {
                    ZStack {
                        // Stroke draws itself (trim 0→1)
                        Circle()
                            .trim(from: 0, to: viewAppeared ? 1 : 0)
                            .stroke(lineWidth: 2)
                            .animation(.snappy.delay(animationDuration * 1.5), value: viewAppeared)
                        // Fill fades in after stroke
                        Circle()
                            .opacity(viewAppeared ? 1 : 0)
                            .animation(.smooth.delay(animationDuration * 1.5), value: viewAppeared)
                    }
                    .foregroundStyle(.white)
                    .frame(width: 12 * scale)
                    // Positive offset pushes the dot downward into the dark half.
                    // Adjust alongside `scale`.
                    .offset(y: yYangOffset)
                }
        }
        .onAppear {
            // One-shot toggle — flips `viewAppeared` to true and kicks off
            // the entire animation sequence. Never toggled back to false.
            viewAppeared.toggle()
        }
    }
}

#Preview {
    YinYangView(scale: 0.7, size: 100)
}
