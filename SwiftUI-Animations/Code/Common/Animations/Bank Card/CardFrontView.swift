//
//  CardFrontView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The front face of a bank card, showing type, number, validity, holder name, and logos.
///
/// Sized as `width × width/ratioConstant` (standard ISO 7810 ID-1 aspect ratio).
/// The gradient background is overlaid with a faint `CardPatternOneView` swoosh and a
/// semi-transparent `Circle` to add depth. Layout is driven entirely by `card`'s properties.
struct CardFrontView: View {

    // MARK: - Variables

    /// Width of the card — typically 85% of screen width, passed in by `CardView`.
    let width: CGFloat

    /// ISO 7810 card aspect ratio (85.6 mm ÷ 53.98 mm ≈ 1.586, rounded to 1.593).
    let ratioConstant: CGFloat = 1.593
    /// Visa logo width-to-height ratio used to keep the logo proportional.
    let visaRatio: CGFloat = 2.095

    /// Card data driving all text labels and the gradient palette.
    var card: Card

    // MARK: - Views

    var body: some View {
        ZStack {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                LinearGradient(gradient: Gradient(colors: [card.cardPalatte.colorOne, card.cardPalatte.colorTwo]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .overlay(
                        ZStack {
                            Circle()
                                .frame(width: 400)
                                .offset(x: 180, y: -10)
                                .opacity(0.05)
                                .rotationEffect(.degrees(-40))
                            CardPatternOneView()
                                .opacity(0.075)
                                .offset(x: -width * 0.3)
                                .scaleEffect(1.4)
                                .rotationEffect(.degrees(-27.5))
                        }
                    )
                    .animation(.easeOut(duration: 0.3), value: card.cardPalatte)

                VStack(alignment: .leading) {
                    HStack {
                        Text("\(card.cardType.rawValue) Card")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundStyle(.white)
                        Spacer()
                        Image("axis")
                            .resizable()
                            .frame(width: 34, height: 34)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Text(card.cardNumber)
                            .font(.system(size: width * 0.065, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                            .offset(y: 15)
                            .frame(minHeight: 29)
                            .animation(.default, value: card.cardNumber)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("VALID THRU")
                            .font(.system(size: 9, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.6))
                        Text(card.validity)
                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.white)
                    }
                    .offset(y: 8)
                    HStack {
                        Text(card.cardHolderName)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .textCase(.uppercase)
                            .foregroundStyle(.white)
                        Spacer()
                        Image("visa")
                            .resizable()
                            .frame(width: 72, height: 72 / visaRatio)
                    }
                }
                .padding()
                .shadow(radius: 5)
            }
        }
        .cornerRadius(20)
        .frame(width: width, height: width / ratioConstant)
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        CardFrontView(width: 370, card: AppConstants.cards[0])
    }
}
