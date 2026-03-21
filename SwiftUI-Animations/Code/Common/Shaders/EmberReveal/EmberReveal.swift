//
//  EmberReveal.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - EmberRevealView
struct EmberRevealView: View {

    // MARK: - variables
    @State private var progress: Float = 0.0

    // MARK: - views
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            Image(.charmeleon)
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 400)
                .clipped()
                .layerEffect(
                    ShaderLibrary.emberReveal(
                        .float(progress),
                        .float2(CGSize(width: 350, height: 400))
                    ),
                    maxSampleOffset: .zero
                )
                .cornerRadius(12)
                .offset(y: -40)
                .onTapGesture {
                    progress = 0.0
                    withAnimation(.interpolatingSpring(stiffness: 4, damping: 12)) {
                        progress = 1.0
                    }
                }
        }
        .overlay(alignment: .top) {
            Text("Tap to reveal")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.label)
                .padding(.top, 24)
        }
        .navigationTitle("Ember Reveal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EmberRevealView()
    }
}
