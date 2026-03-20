//
//  CardBackView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The back face of a bank card, showing a magnetic stripe, security code panel, and card number watermark.
///
/// The gradient uses the same `cardPalatte` as `CardFrontView` but with colors swapped
/// (colorTwo leading, colorOne trailing) to give a mirrored feel. The card number is rendered
/// with `rotation3DEffect(.degrees(180), axis: (x:0, y:1, z:0))` so it reads correctly when
/// the parent `CardView` completes the flip.
struct CardBackView: View {

    // MARK: - Variables

    /// Width of the card — must match the `CardFrontView` instance in the same `CardView`.
    let width: CGFloat
    /// ISO 7810 card aspect ratio used to derive the card height from its width.
    let ratioConstant: CGFloat = 1.593

    /// Card data supplying the palette, security code, and card number watermark.
    let card: Card

    // MARK: - Views

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            LinearGradient(gradient: Gradient(colors: [card.cardPalatte.colorTwo.opacity(0.9), card.cardPalatte.colorOne.opacity(0.9)]), startPoint: .trailing, endPoint: .leading)
            VStack {
                Rectangle()
                    .frame(height: 40)
                    .opacity(0.5)
                    .foregroundStyle(Color.label)
                    .overlay(
                        Rectangle()
                            .frame(width: 180, height: 38)
                            .cornerRadius(3)
                            .foregroundStyle(.white)
                            .overlay(
                                HStack {
                                    Spacer()
                                    Text(card.security)
                                        .foregroundStyle(Color.label)
                                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                        .opacity(0.75)
                                }
                                .padding()
                            )
                            .offset(x: 40)
                    )
                Spacer()
                Text(card.cardNumber)
                    .font(.system(size: width * 0.065, weight: .bold, design: .monospaced))
                    .foregroundStyle(.background)
                    .opacity(0.35)
                    .shadow(color: .background, radius: 5)
                    .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .animation(.default, value: card.cardNumber)
                    .offset(y: -12)
                Spacer()
                Spacer()
            }
            .padding(.top, 24)
        }
        .shadow(radius: 5)
        .cornerRadius(20)
        .frame(width: width, height: width / ratioConstant)
    }
}

#Preview {
    CardBackView(width: UIScreen.main.bounds.width * 0.85, card: AppConstants.cards[0])
}
