//
//  CardView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 26/04/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Usage
// `CardTwoView` composes a single styled card from a `CardTwo` model. It
// renders a `CardHolderView` (the gradient background + decorative strokes)
// and overlays the holder name, masked card number, and provider logo.
//
// The `CardView(_:)` view-builder maps each `CardDesign` enum case to a set
// of gradient colors — add a new case there to introduce a new card style.
struct CardTwoView: View {
    
    // MARK: - Variables
    var card: CardTwo
    
    // MARK: - Views
    var body: some View {
        // Let's use the ViewBuilder Function now
        CardView(card.cardDesign)
            .overlay(alignment: .bottom) {
                // Overlay to render the Card Information
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(card.cardHolderName)
                        // We added the Custom fonts to our Folder Directory, and to the Info Plist, but to use it with ease we'll declare a FontManager
                            .font(ClashGrotestk.semibold.font(size: 18))
                            .textCase(.uppercase)
                            .opacity(0.9)
                            .tracking(1.1) // Spaces out the Character
                        
                        Text("**** **** **** \(card.cardNumber.suffix(4))")
                            .font(ClashGrotestk.medium.font(size: 17))
                            .offset(x: 2)
                    }
                    
                    Spacer()
                    
                    Image(card.providerType.rawValue)
                        .resizable()
                        .frame(width: 64, height: 46)
                    // Use any Logo Asset or find these in the Tutorial's Description
                }
                .foregroundStyle(.white)
                .padding(.bottom, 24)
                .padding(.horizontal, 24)
            }
    }
    // Alright let's set up the Main View
    
    
    // MARK: - Functions
    /// A ViewBuilder function that returns a CardHolderView with a gradient based on the Card Design Enum
    @ViewBuilder
    func CardView(_ cardDesign: CardDesign) -> some View {
        switch cardDesign {
        case .black:
            CardHolderView(gradientColors: [Color.black, Color.black.opacity(0.85), Color.black], darkText: true)
            
        case .orange:
            CardHolderView(gradientColors: [Color.orange, Color.orange, Color.red], darkText: false)
            
        case .pink:
            CardHolderView(gradientColors: [Color.purple, Color.pink, Color.purple], darkText: false)
        }
    }
}

#Preview {
    CardTwoView(card: CardSwapViewModel().cards[2])
        .padding(24)
}
