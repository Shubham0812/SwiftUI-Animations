//
//  ExpandingView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 22/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A single action tile that flies out from the center of `AddView` in a given direction.
///
/// When `expand` is `true`:
/// - The white square container slides to `direction.offsets`, scales to full size,
///   and rounds its corners to a circle (cornerRadius 41).
/// - The SF Symbol icon fades in and counter-rotates by –43° so it appears upright
///   despite the container's 43° rotation effect.
///
/// The container rotation and icon counter-rotation cancel each other out visually,
/// creating the impression that the icon "pops" straight out while the tile spins open.
struct ExpandingView: View {

    // MARK: - Variables

    /// Bound to `AddView.isAnimating`; `true` = tile expanded, `false` = collapsed.
    @Binding var expand: Bool
    /// Direction this tile flies toward when expanded.
    var direction: ExpandDirection
    /// SF Symbol name rendered inside the tile (e.g. "mic.fill", "photo").
    var symbolName: String

    // MARK: - Views

    var body: some View {
        ZStack {
            Image(systemName: symbolName)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundStyle(Color.background)
                .padding()
                .opacity(expand ? 0.85 : 0)
                .scaleEffect(expand ? 1 : 0)
                .rotationEffect(expand ? .degrees(-43) : .degrees(0))
                .animation(.easeOut(duration: 0.15), value: expand)
        }
        .frame(width: 82, height: 82)
        .background(Color.label)
        .cornerRadius(expand ? 41 : 8)
        .scaleEffect(expand ? 1 : 0.5)
        .offset(x: expand ? direction.offsets.0 : 0, y: expand ? direction.offsets.1 : 0)
        .rotationEffect(expand ? .degrees(43) : .degrees(0))
        .animation(.easeOut(duration: 0.25).delay(0.05), value: expand)
        .offset(x: direction.containerOffset.0, y: direction.containerOffset.1)
    }
}

#Preview {
    ExpandingView(expand: .constant(true), direction: .bottom, symbolName: "doc.fill")
}
