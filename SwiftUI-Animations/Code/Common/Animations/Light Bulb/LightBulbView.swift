//
//  LightBulbView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/12/25.
//  Copyright © 2025 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A vector-style hanging light bulb that can be switched on and dimmed.
///
/// **Interaction:**
/// - Tap the power button to toggle the bulb. When it turns on the whole scene floods
///   with a warm yellow and the bulb scales up slightly.
/// - While lit, a `CurvedSlider` appears; dragging its knob adjusts `brightness`, which
///   feeds both the background tint and the bulb's glow radius.
///
/// **Composition:**
/// - `BulbView` draws the bulb (silhouette, screw cap and filament) and takes the glow.
/// - `CurvedSlider` is the arced brightness control.
///
/// > Note: On iOS 26+ the controls use Liquid Glass (`GlassEffectContainer` / `.glassEffect`).
/// > Below that the code falls back to a plain stack and a material-backed knob.
struct LightBulbView: View {

    // MARK: - Variables

    /// Whether the bulb is currently lit. Drives the background, glow and slider visibility.
    @State private var isLightOn = false

    /// Brightness in the 0...1 range. Scales the background tint and the bulb's glow radius.
    @State private var brightness: Double = 0.5

    /// Near-black used as the "lights off" background and the power icon tint when lit.
    private let vectorBlack = Color(white: 0.1)

    /// The warm background shown when the bulb is on, brightened by `brightness`.
    private var lightBackground: Color {
        Color.yellow.opacity(0.6 + (brightness * 0.4))
    }

    // MARK: - Views
    var body: some View {
        ZStack(alignment: .top) {
            // Scene background: warm yellow when lit, near-black when off.
            (isLightOn ? lightBackground : vectorBlack)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: isLightOn)
                .animation(.easeInOut(duration: 0.2), value: brightness)

            VStack(spacing: 0) {
                // The bulb itself, with a subtle scale-up when switched on.
                BulbView(isOn: isLightOn, brightness: brightness)
                    .frame(width: 240, height: 440)   // Tall aspect ratio to match the vector art.
                    .offset(y: 20)
                    .scaleEffect(isLightOn ? 1.0 : 0.95)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isLightOn)

                Spacer()

                controls
                    .padding(.bottom, 50)
            }
            .ignoresSafeArea()
        }
    }

    /// The brightness slider (visible only when lit) stacked with the power button.
    ///
    /// On iOS 26+ both live inside a `GlassEffectContainer` so their Liquid Glass surfaces
    /// can blend together; older systems fall back to a plain `ZStack`.
    @ViewBuilder private var controls: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                brightnessSlider
                powerButton
            }
        } else {
            ZStack {
                brightnessSlider
                powerButton
            }
        }
    }

    /// The arced brightness control. Only present while the bulb is on, so it scales/fades
    /// in and out with the toggle.
    @ViewBuilder private var brightnessSlider: some View {
        if isLightOn {
            CurvedSlider(value: $brightness)
                .frame(width: 320, height: 160)
                .offset(y: -50)
                .transition(.scale.combined(with: .opacity))
        }
    }

    /// The round power button that toggles the bulb, with a haptic tap and a soft glow when lit.
    private var powerButton: some View {
        Button {
            HapticManager().makeImpactFeedback(mode: .medium)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isLightOn.toggle()
            }
        } label: {
            ZStack {
                Circle()
                    .fill(isLightOn ? Color.white : Color(white: 0.2))
                    .shadow(color: isLightOn ? Color.white.opacity(0.5) : .clear, radius: 15)

                Image(systemName: "power")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(isLightOn ? vectorBlack : .white)
                    .overlay {
                        // Thin ring around the glyph, tinted yellow once lit.
                        Circle()
                            .stroke(lineWidth: 1.5)
                            .foregroundStyle(isLightOn ? .yellow : .white)
                            .padding(-16)
                            .blur(radius: 0.1)
                    }
            }
            .frame(width: 110, height: 110)
        }
    }
}

#Preview {
    LightBulbView()
}
