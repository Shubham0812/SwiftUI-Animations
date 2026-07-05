//
//  BulbView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/12/25.
//  Copyright © 2025 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Draws the hanging light bulb: the wire, the screw cap, the glass body and the filament.
///
/// All sizes are expressed as fractions of the provided geometry so the bulb scales cleanly
/// to whatever frame `LightBulbView` gives it. When `isOn` is true the glass and filament
/// gain a white glow whose radius grows with `brightness`.
struct BulbView: View {

    // MARK: - Variables

    /// Whether the bulb is lit — toggles the glow and warms the cap threads.
    var isOn: Bool

    /// Brightness in the 0...1 range, used to scale the glow radius.
    var brightness: Double

    /// Line/fill color for the bulb's vector outline.
    var strokeColor: Color = .black

    // MARK: - Views
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let cx = w / 2

            ZStack {
                // 1. Hanging wire dropping from the top.
                Rectangle()
                    .fill(strokeColor)
                    .frame(width: 8, height: h * 0.25)
                    .position(x: cx, y: h * 0.15)

                // 2. Screw base: a small top nipple above the main cap body.
                VStack(spacing: 6) {
                    // Top nipple.
                    RoundedRectangle(cornerRadius: 2)
                        .fill(strokeColor)
                        .frame(width: w * 0.2, height: h * 0.03)

                    // Main cap body with diagonal "thread" lines cutting across it.
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(strokeColor)

                        // The threads warm up to a filament-yellow when the bulb is on.
                        VStack(spacing: 8) {
                            Rectangle().fill(Color.yellow.opacity(0.0)).frame(height: 2) // Top spacer.
                            Rectangle().fill(isOn ? Color(hex: "F2D966") : Color(white: 0.3))
                                .frame(height: 4)
                                .rotationEffect(.degrees(-5))
                                .padding(.horizontal, 5)
                            Rectangle().fill(isOn ? Color(hex: "F2D966") : Color(white: 0.3))
                                .frame(height: 4)
                                .rotationEffect(.degrees(-5))
                                .padding(.horizontal, 5)
                        }
                    }
                    .frame(width: w * 0.38, height: h * 0.12)
                }
                .position(x: cx, y: h * 0.36)
                .zIndex(2)

                // 3. Glass body: a translucent fill and a thick rounded outline, both glowing when lit.
                ZStack {
                    BulbSilhouette()
                        .fill(isOn ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                        .shadow(color: isOn ? .white : .clear, radius: isOn ? 10 + (brightness * 20) : 0)

                    BulbSilhouette()
                        .stroke(strokeColor, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        .shadow(color: isOn ? .white : .clear, radius: isOn ? 10 + (brightness * 20) : 0)

                    // 4. The filament loop suspended inside the glass.
                    FilamentLoopShape()
                        .stroke(strokeColor, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .shadow(color: isOn ? .white : .clear, radius: isOn ? 10 + (brightness * 10) : 0)
                }
                .frame(width: w * 0.85, height: h * 0.6)
                .position(x: cx, y: h * 0.755)
                .zIndex(1)
            }
        }
    }
}

#Preview {
    BulbView(isOn: false, brightness: 0)
}
