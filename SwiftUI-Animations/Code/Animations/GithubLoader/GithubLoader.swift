//
//  GithubLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 14/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An animated GitHub Octocat loader that traces a glowing stroke segment
/// around the Octocat silhouette in a continuous loop.
///
/// Two `OctocatShape` layers are stacked:
/// - A dim, full-outline ghost (opacity 0.35) — always visible as a guide track
/// - A brighter, trimmed segment that travels around the path like a comet
///
/// The animation is driven by a repeating `Timer` that increments `strokeEnd`
/// every 0.35s, dragging `strokeStart` 0.3 units behind it to form a
/// fixed-length glowing arc. When `strokeEnd` reaches 1.0, the stroke
/// resets after a 1-second pause before looping again.
struct GithubLoader: View {

    // MARK: - Variables

    /// Guards against the reset firing more than once per loop cycle.
    @State var resetStrokes: Bool = true

    /// Leading edge of the travelling stroke segment (0–1 along the path).
    @State var strokeStart: CGFloat = 0

    /// Trailing edge of the travelling stroke segment (0–1 along the path).
    @State var strokeEnd: CGFloat = 0

    // MARK: - Views

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ZStack {
                // Ghost track — full Octocat outline at low opacity
                OctocatShape()
                    .stroke(style: StrokeStyle(lineWidth: 4.5, lineCap: .round, lineJoin: .round, miterLimit: 5))
                    .foregroundStyle(.white)
                    .opacity(0.35)

                // Travelling stroke — brighter, trimmed segment
                OctocatShape()
                    .trim(from: strokeStart, to: strokeEnd)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 10))
                    .foregroundStyle(.white)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { timer in
                            if strokeEnd >= 1 {
                                if resetStrokes {
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                        strokeEnd = 0
                                        strokeStart = 0
                                        resetStrokes.toggle()
                                    }
                                    resetStrokes = false
                                }
                            }

                            withAnimation(.easeOut(duration: 0.5)) {
                                strokeEnd += 0.1
                                strokeStart = strokeEnd - 0.3
                            }
                        }
                    }
            }
            .scaleEffect(2)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("@Shubham_iosdev")
                        .foregroundStyle(.white)
                        .font(.system(size: 28, weight: .medium, design: .monospaced))
                        .opacity(0.3)
                }
                .padding(.trailing, 16)
            }
        }
    }
}

#Preview {
    GithubLoader()
}
