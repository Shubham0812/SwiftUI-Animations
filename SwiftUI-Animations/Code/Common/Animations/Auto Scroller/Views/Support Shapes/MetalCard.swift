//
//  MetalCard.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The black "metal" card face: a near-black gradient with a faint concentric-square
/// texture and a flowing line accent.
struct MetalCard: View {

    // MARK: - variables
    let width: CGFloat = UIScreen.main.bounds.width - 48
    let ratioConstant: CGFloat = 1.623
    let cornerRadius: CGFloat = 24

    // MARK: - views
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundStyle(.clear)
            .overlay {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "#000000"), Color(hex: "#121212").opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)

                    ConcentricSquares()
                        .stroke(lineWidth: 0.5)
                        .scale(1.5)
                        .foregroundStyle(.white)
                        .opacity(0.2)

                    CardLineOne(colorOne: Color(hex: "#FAFAFA").opacity(0.4), colorTwo: Color(hex: "#EFEFEF").opacity(0.1))
                        .scaleEffect(0.8)
                        .rotationEffect(.degrees(190))
                        .offset(x: -20, y: 120)
                        .mask(
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: width / ratioConstant)
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            .frame(height: width / ratioConstant)
    }
}

#Preview {
    MetalCard()
        .padding(24)
}
