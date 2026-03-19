//
//  FillShapes.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A decorative pair of shapes (a circle and a capsule) used as floating accents
/// around the pill loader container in `PillLoader`.
///
/// Two instances are placed above and below the pill with mirrored offsets,
/// giving the animation a sense of depth and particle decoration during the spin.
struct FillShapes: View {

    // MARK: - Variables

    /// Horizontal position of both the circle and capsule.
    @State var xOffset: CGFloat
    /// Vertical position of the circle. The capsule is offset by `capsuleSpacing` from this.
    @State var yOffset: CGFloat

    /// Additional vertical offset applied to the capsule relative to `yOffset`.
    /// A positive value moves the capsule below the circle; negative moves it above.
    @State var capsuleSpacing: CGFloat

    // MARK: - Views
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white.opacity(0.55))
                .shadow(color: .white, radius: 10, x: 1, y: 1)
                .offset(x: xOffset, y: yOffset)

            Capsule(style: .continuous)
                .frame(width: 20, height: 40)
                .foregroundStyle(.white.opacity(0.55))
                .shadow(color: .white, radius: 10, x: 1, y: 1)
                .offset(x: xOffset, y: yOffset + capsuleSpacing)
        }
    }
}

#Preview {
    ZStack {
        Color.blue
            .ignoresSafeArea()
        FillShapes(xOffset: -45, yOffset: -10, capsuleSpacing: 40)
    }
}
