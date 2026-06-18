//
//  CardWhite.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The white "metal" card face: a light silver gradient with two faint embossed circles.
struct CardWhite: View {

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
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#BABABA"), Color(hex: "#F0F0F0"), Color.white]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Circle()
                        .stroke(lineWidth: 1.5)
                        .foregroundStyle(.black.opacity(0.1))
                        .offset(y: 70)
                        .scaleEffect(1.4)

                    Circle()
                        .stroke(lineWidth: 1.5)
                        .foregroundStyle(.black.opacity(0.1))
                        .offset(y: -70)
                        .scaleEffect(1.4)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            .frame(height: width / ratioConstant)
    }
}

#Preview {
    CardWhite()
        .padding(24)
        .preferredColorScheme(.dark)
}
