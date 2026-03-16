//
//  YinYangToggleView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 02/09/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A custom toggle control styled as a yin-yang capsule switcher.
///
/// On appear, the capsule border draws itself in (trim 0→1), then the
/// background fill fades in. Tapping slides the yin-yang symbol across
/// the capsule and rotates it 180°, while flipping `themeToggled` in the
/// shared `YinYangViewModel` to drive the app-wide light/dark transition.
struct YinToggleView: View {
    
    // MARK: - Variables
    
    /// Shared view model that owns the light/dark toggle state.
    /// Read and written here; observed by `YinYangAnimationView` to drive
    /// the full-screen background transition.
    @Environment(YinYangViewModel.self) var yinYangViewModel
    
    /// Flipped once in `onAppear` to trigger the capsule's entrance animation.
    @State var viewAppeared = false
    
    /// Duration of a single animation step. Delays for each layer are
    /// expressed as multiples of this value to stagger the entrance sequence.
    let animationDuration: TimeInterval = 0.75
    
    /// Half the travel distance for the yin-yang knob.
    /// Subtracted from half the capsule width to keep the knob inset from the edges.
    let xOffset: CGFloat = 28.5
    
    // MARK: - Views
    var body: some View {
        GeometryReader { proxy in
            
            // ── Capsule border ────────────────────────────────────────────────
            // Draws itself on via trim (0→1) during the entrance animation.
            // Acts as the outermost layer; the knob and background sit inside it.
            Capsule(style: .continuous)
                .trim(from: 0, to: viewAppeared ? 1 : 0)
                .stroke(lineWidth: 3)
                .foregroundColor(.gray)
                .animation(.smooth(duration: animationDuration).delay(animationDuration * 1.25), value: viewAppeared)
            
                // ── Yin-yang knob ─────────────────────────────────────────────
                // Aligned to `.leading` so its natural resting position is the left side.
                // `xOffset` insets it from the edge; the full `proxy.size.width` travel
                // carries it to the right side when `themeToggled` is true.
                .overlay(alignment: .leading) {
                    YinYangView(scale: 0.565, yYingOffset: 10, yYangOffset: 15)
                        .offset(y: -2) // Fine-tune vertical centering within the capsule
                        // Rotates 180° on toggle — gives the impression of the symbol "flipping"
                        .rotationEffect(yinYangViewModel.themeToggled ? .degrees(180) : .zero)
                        // Slides between left and right ends of the capsule.
                        // Right position:  +width/2 - xOffset (inset from right edge)
                        // Left position:   -width/2 + xOffset (inset from left edge)
                        .offset(x: yinYangViewModel.themeToggled
                                ? proxy.size.width / 2 - xOffset
                                : -proxy.size.width / 2 + xOffset)
                }
            
                // ── Capsule background fill ───────────────────────────────────
                // Fades in after the border finishes drawing (longer delay).
                // Color inverts with the theme: black fill in light mode, white in dark.
                // Opacity is slightly lower in light mode (0.8 vs 0.95) to keep it subtle.
                .background {
                    Capsule(style: .continuous)
                        .opacity(viewAppeared ? yinYangViewModel.themeToggled ? 0.95 : 0.8 : 0)
                        .foregroundStyle(!yinYangViewModel.themeToggled ? .black : .white)
                        // Delayed further than the border so the fill appears last in the sequence
                        .animation(.smooth(duration: animationDuration * 1.25).delay(animationDuration * 1.5), value: viewAppeared)
                }
            
                // ── Tap handler ───────────────────────────────────────────────
                // Toggles `themeToggled`, which simultaneously:
                //   • slides and rotates the yin-yang knob
                //   • swaps the capsule background color
                //   • triggers the full-screen background transition in YinYangAnimationView
                .onTapGesture {
                    withAnimation(.snappy(duration: animationDuration)) {
                        yinYangViewModel.themeToggled.toggle()
                    }
                }
            
                // One-shot toggle that fires the entrance animation sequence
                .onAppear() {
                    viewAppeared.toggle()
                }
        }
    }
}

#Preview {
    YinToggleView()
        .frame(width: 140, height: 62)
        .environment(YinYangViewModel())
}
