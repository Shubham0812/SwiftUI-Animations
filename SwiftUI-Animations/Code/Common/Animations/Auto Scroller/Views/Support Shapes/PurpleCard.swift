//
//  PurpleCard.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The purple card face: a violet gradient with a faint concentric-square texture
/// and a flowing line accent.
struct PurpleCard: View {

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
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "#3C29A9"), Color(hex: "#5C3BB4"), Color(hex: "#A463C9")]), startPoint: .topLeading, endPoint: .bottomTrailing)

                    ConcentricSquares()
                        .stroke(lineWidth: 0.5)
                        .scale(1.5)
                        .foregroundStyle(.white)
                        .opacity(0.2)

                    CardLineOne(colorOne: Color(hex: "#000000").opacity(0.5), colorTwo: Color(hex: "#EFEFEF").opacity(0.1))
                        .scaleEffect(1)
                        .rotationEffect(.degrees(220))
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
    PurpleCard()
        .padding(24)
}
