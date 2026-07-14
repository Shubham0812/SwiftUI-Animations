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
        // GeometryReader gives us the real rendered size so the shader can normalize
        // coordinates correctly. The `emberReveal` shader computes `uv = position / size`,
        // so `size` must match the view's actual bounds — passing a hardcoded size breaks
        // the center-out reveal whenever the image isn't exactly that size.
        GeometryReader { proxy in
            ZStack {
                Color.black
                    .ignoresSafeArea()

                Image(.landing1)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .layerEffect(
                        ShaderLibrary.emberReveal(
                            .float(progress),
                            .float2(proxy.size)
                        ),
                        maxSampleOffset: .zero
                    )
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.gray.opacity(0.1))
                    }
                    .onTapGesture {
                        progress = 0.0
                        withAnimation(.smooth(duration: 5)) {
                            progress = 1.0
                        }
                    }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            Text("Tap to reveal")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.background)
                .padding(.top, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EmberRevealView()
    }
}
