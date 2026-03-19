//
//  LightSwitchView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 16/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An interactive light switch view with a dramatic on/off animation.
///
/// When the switch is off, the screen is dark with a flattened yellow ellipse
/// sitting below the visible frame. Tapping the circular pull-cord knob
/// "turns the light on" — the ellipse rapidly expands to fill the entire screen
/// with a warm yellow glow. Tapping again collapses it back down.
///
/// **Layout structure (back to front):**
/// ```
/// 1. Black background
/// 2. Yellow light bloom (Circle scaled into an ellipse, animates in/out)
/// 3. Back arrow (top-left nav)
/// 4. Pull-cord switch (right edge — capsule track + line + knob)
/// ```
struct LightSwitchView: View {
    
    // MARK: - Variables
    
    // ── Screen dimensions ─────────────────────────────────────────────────────
    // Captured once at init; used to position and size the switch cord and bloom.
    let appWidth  = UIScreen.main.bounds.width
    let appHeight = UIScreen.main.bounds.height
    
    /// Duration of the light bloom animation.
    /// The collapse is slightly faster (`× 0.75`) than the expand for a snappier off-feel.
    let animationDuration: TimeInterval = 0.35
    
    // ── Light bloom state ─────────────────────────────────────────────────────
    
    /// Horizontal scale of the yellow bloom circle.
    /// Off: `2` (wide ellipse compressed below frame). On: `4` (fills screen).
    @State var xScale: CGFloat = 2
    
    /// Vertical scale of the yellow bloom circle.
    /// Off: `0.4` (very flat, hidden below frame). On: `4` (fills screen).
    @State var yScale: CGFloat = 0.4
    
    /// Vertical offset of the yellow bloom circle.
    /// Off: `height × 0.8` (pushed well below visible area).
    /// On: `0` (centered on screen, fully visible).
    @State var yOffset: CGFloat = UIScreen.main.bounds.height * 0.8
    
    @State var dragYOffset: CGFloat = 0
    
    /// Whether the light is currently off.
    /// Drives the bloom scale/offset, knob position, cord length, and arrow color.
    @State var isOff: Bool = true
    
    // MARK: - Views
    var body: some View {
        ZStack {
            
            // ── 1. Background ─────────────────────────────────────────────────
            Color.black
            
            // ── 2. Yellow light bloom ─────────────────────────────────────────
            // A circle scaled into an ellipse and positioned below the frame when off.
            // `toggleAllLights()` animates it to fill the screen, simulating a light turning on.
            Circle()
                .fill(Color.yellow)
                .scaleEffect(CGSize(width: xScale, height: yScale))
                .offset(y: yOffset)
            
            // ── 3. Back arrow ─────────────────────────────────────────────────
            // Top-left navigation chevron. Color flips with `isOff` to stay
            // readable on both dark (off) and bright yellow (on) backgrounds.
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(isOff ? .white : .black)
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    Spacer()
                }
                .padding([.top, .bottom], 24)
                Spacer()
            }
            .offset(y: 32)
            .padding([.leading, .trailing], 24)
            
            // ── 4. Pull-cord switch ───────────────────────────────────────────
            // Positioned along the right edge. Consists of three layers:
            //   a) A dim capsule track (static background rail)
            //   b) A white vertical line (the cord) whose length changes with state
            //   c) A white circle knob at the end of the cord (the tap target)
            ZStack {
                // a) Static dim capsule track
                Capsule(style: .continuous)
                    .foregroundStyle(.gray)
                    .frame(width: 52, height: appHeight * 0.25 + 6)
                    .opacity(0.275)
                    .offset(x: appWidth / 2 - 48, y: 16)

                ZStack {
                    // b) Cord line
                    // We calculate the height change clearly.
                    let baseHeight = isOff ? appHeight * 0.41 : appHeight * 0.625
                    let totalHeight = baseHeight + dragYOffset
                    
                    Capsule()
                        .frame(width: 3, height: totalHeight)
                        .foregroundStyle(.white)
                        // THE FIX: Capsules expand from the center.
                        // To keep the TOP stationary, we must move the center DOWN by half the height.
                        .offset(y: totalHeight / 2)

                    // c) Knob
                    Circle()
                        .fill(Color.white)
                        .frame(width: 42, height: 42)
                        // The knob sits exactly at the bottom of the totalHeight.
                        .offset(y: totalHeight + (isOff ? 12.0 : -12.0))
                        .onTapGesture {
                            toggleAllLights()
                        }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    guard isOff else { return }
                                        
                                        // 1. Get the raw movement
                                        let translation = value.translation.height
                                        
                                        // 2. Define the hard limit.
                                        // We want the knob to stop at the bottom of the gray rail.
                                        // The rail is roughly 25% of the screen.
                                        let maxAllowedDrag = appHeight * 0.19
                                        
                                        withAnimation(.interactiveSpring()) {
                                            // CLAMP:
                                            // max(0, ...) -> Stops the cord from shrinking/going up.
                                            // min(..., maxAllowedDrag) -> Stops the cord from growing past the rail.
                                            dragYOffset = max(0, min(translation, maxAllowedDrag))
                                        }
                                })
                                .onEnded({ value in
                                    if dragYOffset > 60 {
                                        toggleAllLights()
                                    }
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        dragYOffset = 0
                                    }
                                })
                        )
                }
                // This moves the "0,0" point of the cord/knob group to the ceiling
                .offset(x: appWidth / 2 - 48, y: -appHeight / 2)
            }
            // Spring animation on the switch — gives the knob a satisfying bounce
            // when pulled. Applied to the whole cord+knob ZStack so both animate together.
            .animation(.spring(dampingFraction: 0.65).speed(1.25), value: isOff)

        }
        .ignoresSafeArea()
    }
    
    // MARK: - Functions
    
    /// Toggles the light on or off, animating the yellow bloom accordingly.
    ///
    /// **Turning on** (`isOff == true`):
    /// Expands the bloom from a flat ellipse below the frame to fill the entire screen.
    /// Uses `easeIn` so the light appears to accelerate — like a bulb warming up.
    ///
    /// **Turning off** (`isOff == false`):
    /// Collapses the bloom back below the frame at `× 0.75` speed for a snappier cutoff.
    /// Uses `easeOut` so the light fades quickly at first then settles.
    func toggleAllLights() {
        if isOff {
            // Light on — bloom expands to fill the screen
            withAnimation(Animation.easeIn(duration: animationDuration)) {
                xScale  = 4
                yScale  = 4
                yOffset = 0
            }
        } else {
            // Light off — bloom collapses back below the frame
            withAnimation(Animation.easeOut(duration: animationDuration * 0.75)) {
                yScale  = 0.4
                xScale  = 2
                yOffset = UIScreen.main.bounds.height * 0.8
            }
        }
        isOff.toggle()
    }
}

#Preview {
    LightSwitchView()
}
