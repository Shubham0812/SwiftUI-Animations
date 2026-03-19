//
//  DashedLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The white face of the 3D cube loader, showing a dashed ring with two orbiting dots.
///
/// Displayed when the cube is flipped to its white side in `RotatingLoaderView`.
/// The dashed circle rotates continuously (5 s linear loop), while two satellite dots
/// orbit at 75% of that speed (3.75 s), creating an independent layered spin effect.
struct DashedLoaderView: View {

    // MARK: - Variables

    /// Drives all three `repeatForever` rotation animations — toggled once on appear.
    @State var isAnimating: Bool = false

    /// Duration for one full rotation of the dashed ring.
    /// The two satellite dots use `animationDuration × 0.75` so they orbit faster.
    let animationDuration: TimeInterval = 5

    // MARK: - Views

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, miterLimit: 2, dash: [10, 40, 20], dashPhase: 6))
                    .foregroundStyle(.black)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 2)
                    .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                    .animation(.linear(duration: animationDuration).repeatForever(autoreverses: false), value: isAnimating)
                Circle()
                    .frame(width: geometry.size.width * 0.06, height: geometry.size.width * 0.1)
                    .offset(x: -geometry.size.width / 4)
                    .foregroundStyle(.black)
                    .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                    .animation(.linear(duration: animationDuration * 0.75).repeatForever(autoreverses: false), value: isAnimating)
                Circle()
                    .frame(width: geometry.size.width * 0.06, height: geometry.size.width * 0.1)
                    .offset(x: geometry.size.width / 4)
                    .foregroundStyle(.black)
                    .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                    .animation(.linear(duration: animationDuration * 0.75).repeatForever(autoreverses: false), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating.toggle()
        }
    }
}

#Preview {
    DashedLoaderView()
}
