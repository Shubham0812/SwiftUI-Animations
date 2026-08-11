//
//  FluidGrainView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 09/08/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - FluidGrainView

/// A full-screen, animated shader background: a slow "smoky" wave of a tint color drifting
/// over black, dusted with film grain (`FluidGrain.metal`).
///
/// A small color swatch in the navigation bar opens a custom pop-up menu of preset tints,
/// letting the viewer recolor the glow live.
struct FluidGrainView: View {

    // MARK: - variables

    /// The glow color fed into the shader. Changing it recolors the wave in real time.
    @State private var themeColor: Color = .blue

    /// Whether the custom color menu is showing.
    @State private var showColorMenu = false

    /// Anchor for driving the shader's time uniform.
    private let startDate = Date()

    /// Preset tints offered in the color menu.
    private let palette: [Color] = [
        .blue, .purple, .pink, .red,
        .orange, .yellow, .green, .teal,
    ]

    // MARK: - views
    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsedTime = timeline.date.timeIntervalSince(startDate)

            Rectangle()
                .colorEffect(
                    ShaderLibrary.fluidGrain(
                        .float(elapsedTime),
                        .color(themeColor)
                    )
                )
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                colorPickerButton
            }
        }
    }

    // MARK: - views (private)

    /// The navigation-bar swatch showing the current tint. Tapping it opens the color menu.
    private var colorPickerButton: some View {
        Button {
            HapticManager().makeImpactFeedback(mode: .light)
            showColorMenu.toggle()
        } label: {
            Circle()
                .fill(themeColor)
                .frame(width: 24, height: 24)
                .overlay(Circle().stroke(.white.opacity(0.7), lineWidth: 1.5))
                .shadow(color: themeColor.opacity(0.6), radius: 4)
        }
        .popover(isPresented: $showColorMenu) {
            colorMenu
                .presentationCompactAdaptation(.popover)
        }
    }

    /// The custom pop-up menu: a compact grid of tappable color swatches.
    private var colorMenu: some View {
        let columns = Array(repeating: GridItem(.fixed(40), spacing: 14), count: 4)

        return VStack(alignment: .leading, spacing: 12) {
            Text("Glow Color")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(Array(palette.enumerated()), id: \.offset) { _, color in
                    let isSelected = color == themeColor

                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                        .overlay {
                            // Ring the currently selected swatch.
                            Circle()
                                .stroke(Color.primary, lineWidth: isSelected ? 3 : 0)
                                .padding(-3)
                        }
                        .overlay {
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .contentShape(Circle())
                        .onTapGesture {
                            HapticManager().makeSelectionFeedback()
                            withAnimation(.snappy(duration: 0.2)) {
                                themeColor = color
                            }
                            showColorMenu = false
                        }
                }
            }
        }
        .padding(16)
        .frame(width: 232)
    }
}

#Preview {
    NavigationStack {
        FluidGrainView()
    }
}
