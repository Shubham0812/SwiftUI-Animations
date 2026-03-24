//
//  RippleEffectView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - RippleEffectView
struct RippleEffectView: View {

    // MARK: - variables
    @State private var touchPoint: CGPoint = CGPoint(x: 175, y: 200)
    @State private var progress: Float = 0.0
    @State private var isAnimating: Bool = false
    @State private var startDate = Date()

    private let imageSize = CGSize(width: 350, height: 400)

    // MARK: - views
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            TimelineView(.animation) { timeline in
                let elapsed = Float(timeline.date.timeIntervalSince(startDate))

                Image(.charmeleon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .clipped()
                    .distortionEffect(
                        ShaderLibrary.waveRipple(
                            .float2(imageSize),
                            .float2(touchPoint),
                            .float(elapsed),
                            .float(progress)
                        ),
                        maxSampleOffset: CGSize(width: 20, height: 20)
                    )
                    .cornerRadius(12)
                    .offset(y: -40)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                // Translate tap from view coords to image coords
                                let loc = value.location
                                let clampedX = max(0, min(imageSize.width,  loc.x))
                                let clampedY = max(0, min(imageSize.height, loc.y + 40))
                                touchPoint = CGPoint(x: clampedX, y: clampedY)

                                startDate = Date()
                                progress  = 0.0
                                withAnimation(.easeOut(duration: 1.6)) {
                                    progress = 1.0
                                }
                            }
                    )
            }
        }
        .overlay(alignment: .top) {
            Text("Tap to create ripples")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.label)
                .padding(.top, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RippleEffectView()
    }
}
