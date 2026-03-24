//
//  HalftoneView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - HalftoneView
struct HalftoneView: View {

    // MARK: - variables
    @State private var progress: Float = 0.0
    @State private var isHalftone: Bool = false

    private let dotSize: Float = 8.0
    private let imageSize = CGSize(width: 350, height: 400)

    // MARK: - views
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            Image(.charmeleon)
                .resizable()
                .scaledToFill()
                .frame(width: imageSize.width, height: imageSize.height)
                .clipped()
                .layerEffect(
                    ShaderLibrary.halftone(
                        .float2(imageSize),
                        .float(dotSize),
                        .float(progress)
                    ),
                    maxSampleOffset: CGSize(width: 10, height: 10)
                )
                .cornerRadius(12)
                .offset(y: -40)
                .onTapGesture {
                    isHalftone.toggle()
                    withAnimation(.interpolatingSpring(stiffness: 5, damping: 12)) {
                        progress = isHalftone ? 1.0 : 0.0
                    }
                }
        }
        .overlay(alignment: .top) {
            Text("Tap to halftone")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.label)
                .padding(.top, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HalftoneView()
    }
}
