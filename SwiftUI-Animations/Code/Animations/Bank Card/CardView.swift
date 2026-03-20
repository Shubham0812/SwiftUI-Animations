//
//  CardView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Top-level view for the Bank Card demo, combining a flip animation with a snap carousel.
///
/// Tapping a `CardFrontView` triggers an `easeInOut` flip to `CardBackView` via `rotation3DEffect`,
/// using two independent 4-tuple `CardState` values (degree, offset, anchor, y-axis) per face.
/// A 0.1 s polling timer syncs `cardBalance` to whichever card is active in the `UIStateModel`.
struct CardView: View {
    // MARK: - Constants
    let animationDuration: TimeInterval = 0.5
    let displayWidth: CGFloat = UIScreen.main.bounds.width * 0.85
    let perspective: CGFloat = 0.5 // Lower value = more dramatic 3D effect

    // MARK: - State
    @State var card: Card
    @State var cardFlipped: Bool = false
    @State var userCards: [Card] = []
    @State var UIState: UIStateModel
    @State var cardBalance: Double = 0
    @State var selectedIndex: Int = 0

    @State private var rotationDegree: Double = 0 // Start at 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Balance Header
                VStack {
                    Text("Balance")
                        .font(.system(size: 20, weight: .medium))
                    Text("₹\(cardBalance.clean(places: 2))")
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                        .shadow(radius: 4)
                }
                .padding(.top)
                .padding(.bottom, 24)

                Text(cardFlipped ? "Tap to flip back" : "Tap to view security code")
                    .font(.system(size: 14, weight: .medium))

                // Carousel Section
                Carousel(numberOfItems: CGFloat(userCards.count), spacing: 0, widthOfHiddenCards: 0) {
                    ForEach(userCards) { cardItem in
                        Item(_id: cardItem.id, spacing: 0, widthOfHiddenCards: 0, cardWidth: displayWidth, selectedIndex: .constant(1)) {
                            
                            // THE CORE FIX: Simplified Flip Logic
                            ZStack {
                                // BACK FACE
                                CardBackView(width: displayWidth, card: cardItem)
                                    // 1. Pre-rotate the back view itself so it isn't mirrored
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    // 2. Only show when the flip is past the halfway mark
                                    .opacity(cardFlipped ? 1 : 0)

                                // FRONT FACE
                                CardFrontView(width: displayWidth, card: cardItem)
                                    // 3. Hide when the flip is past the halfway mark
                                    .opacity(cardFlipped ? 0 : 1)
                            }
                            // 4. Apply the shared rotation to the container
                            .rotation3DEffect(
                                .degrees(rotationDegree),
                                axis: (x: 0, y: 1, z: 0),
                                perspective: perspective
                            )
                            .onTapGesture {
                                // 5. Use a spring for a more "physical" feel
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                                    cardFlipped.toggle()
                                    // Toggle specifically between 0 and 180
                                    rotationDegree = cardFlipped ? 180 : 0
                                }
                            }
                        }
                    }
                }
                .environment(UIState)
            }
        }
        .onAppear(perform: setupInitialData)
        // Sync balance when carousel moves
        .onChange(of: UIState.activeCard) { newValue in
            updateActiveCard(index: newValue)
        }
    }

    // MARK: - Helpers
    private func setupInitialData() {
        userCards = AppConstants.cards
        updateActiveCard(index: UIState.activeCard)
    }

    private func updateActiveCard(index: Int) {
        selectedIndex = index
        if let balance = Double(userCards[index].balance) {
            withAnimation { cardBalance = balance }
        }
        // Optional: Reset flip when swiping to a new card
        withAnimation {
            cardFlipped = false
            rotationDegree = 0
        }
    }
    
    /// Determines if the back of the card should be visible based on total rotation
    func isBackVisible(degree: Double) -> Bool {
        // Normalize degree to 0-359
        let normalized = abs(degree).truncatingRemainder(dividingBy: 360)
        // The back is visible when the rotation is between 90 and 270 degrees
        return normalized > 90 && normalized < 270
    }
}

#Preview {
    CardView(card: AppConstants.cards[0], UIState: UIStateModel())
}
