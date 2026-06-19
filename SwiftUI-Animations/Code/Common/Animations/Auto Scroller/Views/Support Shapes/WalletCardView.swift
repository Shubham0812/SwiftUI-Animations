//
//  WalletCardView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Composes a single styled card: the design's face (`cardDesign.cardView()`)
/// overlaid with the holder name, masked card number, and provider logo.
struct WalletCardView: View {

    // MARK: - variables
    var card: WalletCard

    // MARK: - views
    var body: some View {
        card.cardDesign.cardView()
            .overlay(alignment: .bottom) {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(card.cardHolderName)
                            .font(ClashGrotestk.semibold.font(size: 18))
                            .textCase(.uppercase)
                            .opacity(0.9)
                            .tracking(1.1)

                        Text("**** **** **** \(card.lastFour)")
                            .font(ClashGrotestk.medium.font(size: 17))
                            .offset(x: 2)
                    }

                    Spacer()

                    Image(card.providerType.rawValue)
                        .resizable()
                        .frame(width: 64, height: 46)
                }
                .foregroundStyle(card.cardDesign.needsDarkText() ? .black : .white)
                .padding(.bottom, 24)
                .padding(.horizontal, 24)
            }
    }
}

#Preview {
    WalletCardView(card: AutoScrollerViewModel().cards[2])
        .padding(24)
}
