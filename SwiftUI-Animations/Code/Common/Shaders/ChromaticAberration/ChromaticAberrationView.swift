//
//  ChromaticAberrationView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - ChromaticAberrationView
struct ChromaticAberrationView: View {

    // MARK: - variables
    @State private var strength: Float = 0.0
    @State private var isActive: Bool  = false
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
                        ShaderLibrary.chromaticAberration(
                            .float2(imageSize),
                            .float(strength),
                            .float(elapsed)
                        ),
                        maxSampleOffset: CGSize(width: 50, height: 50)
                    )
                    .cornerRadius(12)
                    .offset(y: -40)
                    .onTapGesture {
                        isActive.toggle()
                        withAnimation(.interpolatingSpring(stiffness: 60, damping: 12)) {
                            strength = isActive ? 30.0 : 0.0
                        }
                    }
            }
        }
        .overlay(alignment: .top) {
            Text("Tap to toggle aberration")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.label)
                .padding(.top, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ChromaticAberrationView()
    }
}
