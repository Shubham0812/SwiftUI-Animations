//
//  RectangleLoaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Four thin white bars that pulse up and down in a staggered "equalizer" pattern.
///
/// Displayed on the dark face of the 3D cube loader (`RotatingLoaderView`).
/// Each bar has a fixed width (12 pt) and a height that alternates between 25% and 10%
/// of the container width, with delays of 0, 0.2, 0.4, and 0.6 s so they cascade.
///
/// The height is set from `GeometryProxy` on appear so it scales with any container size.
struct RectangleLoaderView: View {

    // MARK: - Variables

    /// Current height of all four bars, driven by `animateRectangles(in:)`.
    @State var rectangleHeight: CGFloat = 12

    // MARK: - Views

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.materialBlack
                    .ignoresSafeArea()
                HStack(alignment: .center, spacing: 8) {
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: 12, height: rectangleHeight)
                        .animation(.easeOut.delay(0), value: rectangleHeight)
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: 12, height: rectangleHeight)
                        .animation(.easeOut.delay(0.2), value: rectangleHeight)
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: 12, height: rectangleHeight)
                        .animation(.easeOut.delay(0.4), value: rectangleHeight)
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(width: 12, height: rectangleHeight)
                        .animation(.easeOut.delay(0.6), value: rectangleHeight)
                }
                .onAppear {
                    rectangleHeight = geometry.size.width * 0.25
                    animateRectangles(in: geometry)
                    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                        animateRectangles(in: geometry)
                    }
                }
            }
        }
    }

    // MARK: - Functions

    /// Pulses bar heights: expands to 25% of container width, then collapses to 10% after 0.5 s.
    /// Called on appear and repeats every 1.5 s so the animation loops continuously.
    func animateRectangles(in geometry: GeometryProxy) {
        rectangleHeight = geometry.size.width * 0.25
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            rectangleHeight = geometry.size.width * 0.1
        }
    }
}

#Preview {
    RectangleLoaderView()
        .frame(width: 200, height: 200)
}
