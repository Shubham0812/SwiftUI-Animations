//
//  GlitchEffectView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - GlitchEffectView
struct GlitchEffectView: View {

    // MARK: - variables
    @State private var intensity: Float = 0.0
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
                    .layerEffect(
                        ShaderLibrary.glitchEffect(
                            .float2(imageSize),
                            .float(elapsed),
                            .float(intensity)
                        ),
                        maxSampleOffset: CGSize(width: 30, height: 0)
                    )
                    .cornerRadius(12)
                    .offset(y: -40)
                    .onTapGesture {
                        startDate = Date()
                        intensity = 1.0
                        // Decay the glitch back to zero
                        withAnimation(.easeOut(duration: 2.0)) {
                            intensity = 0.0
                        }
                    }
            }
        }
        .overlay(alignment: .top) {
            Text("Tap to glitch")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.label)
                .padding(.top, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GlitchEffectView()
    }
}
