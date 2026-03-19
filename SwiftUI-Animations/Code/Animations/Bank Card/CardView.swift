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

    // MARK: - Variables

    /// Duration of the flip animation when the user taps a card face.
    let animationDuration: TimeInterval = 0.3
    /// Card width — 85% of the screen width, matching the `Item` slot in the carousel.
    let displayWidth: CGFloat = UIScreen.main.bounds.width * 0.85

    /// The currently displayed card (used for initial state; full list is in `userCards`).
    @State var card: Card

    /// Tracks whether the active card is showing its back face.
    @State var cardFlipped: Bool = false
    /// Populated from `AppConstants.cards` on appear; drives the `ForEach` in the carousel.
    @State var userCards: [Card] = []

    /// Shared carousel state injected as an `@Environment` object into `Carousel`.
    @State var UIState: UIStateModel
    /// Formatted balance of the currently active card — updates via the polling timer.
    @State var cardBalance: Double = 0
    /// Mirrors `UIState.activeCard`; used to detect when the carousel swipes to a new card.
    @State var selectedIndex: Int = 0

    // Rotations
    /// Perspective divisor for `rotation3DEffect` — 1 gives a natural-looking perspective.
    let perspective: CGFloat = 1
    /// Current rotation degree for the front face (`CardFrontView`).
    @State var firstViewDegree: Double = CardState.initialTrailing.rotationValues.0
    /// Horizontal offset applied to the front face during the flip transition.
    @State var firstViewOffset: CGFloat = CardState.initialTrailing.rotationValues.1
    /// Rotation anchor for the front face (`.trailing` during front→back flip).
    @State var firstViewAnchor: UnitPoint = CardState.initialTrailing.rotationValues.2
    /// Y-axis sign for the front face rotation (`-1` = flip toward viewer).
    @State var firstViewYAxis: CGFloat = CardState.initialTrailing.rotationValues.3

    /// Current rotation degree for the back face (`CardBackView`).
    @State var secondViewDegree: Double = CardState.initialLeading.rotationValues.0
    /// Horizontal offset applied to the back face during the flip transition.
    @State var secondViewOffset: CGFloat = CardState.initialLeading.rotationValues.1
    /// Rotation anchor for the back face (`.leading` during front→back flip).
    @State var secondViewAnchor: UnitPoint = CardState.initialLeading.rotationValues.2
    /// Y-axis sign for the back face rotation.
    @State var secondViewYAxis: CGFloat = CardState.initialLeading.rotationValues.3

    // MARK: - Views

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            Color.black
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("Balance")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .foregroundStyle(.white)
                            .opacity(0.8)
                        Text("₹\(cardBalance.clean(places: 2))")
                            .font(.system(size: 24, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.white)
                            .shadow(radius: 4)
                            .animation(.spring(), value: cardBalance)
                    }
                    Spacer()
                }
                .padding()

                Text(cardFlipped ? "Tap on the card again to flip it back" : "Tap on the card to view the security code")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundStyle(.white)
                    .padding(32)
                    .animation(.default, value: cardFlipped)

                Canvas {
                    Carousel(numberOfItems: CGFloat(userCards.count), spacing: 0, widthOfHiddenCards: 0) {
                        ForEach(userCards) { card in
                            Item(_id: card.id, spacing: 0, widthOfHiddenCards: 0, cardWidth: displayWidth, selectedIndex: .constant(1)) {
                                ZStack {
                                    CardFrontView(width: displayWidth, card: card)
                                        .rotation3DEffect(.degrees(firstViewDegree), axis: (x: 0, y: firstViewYAxis, z: 0), anchor: firstViewAnchor, anchorZ: 0, perspective: perspective)
                                        .offset(x: firstViewOffset)
                                        .onTapGesture {
                                            cardFlipped.toggle()
                                            withAnimation(.easeInOut(duration: animationDuration)) {
                                                setValuesOnState(rotation1: .finalTrailing, rotation2: .finalLeading)
                                            }
                                        }
                                    CardBackView(width: displayWidth, card: card)
                                        .rotation3DEffect(.degrees(secondViewDegree), axis: (x: 0, y: secondViewYAxis, z: 0), anchor: secondViewAnchor, anchorZ: 0, perspective: perspective)
                                        .offset(x: secondViewOffset)
                                        .onTapGesture {
                                            cardFlipped.toggle()
                                            withAnimation(.easeInOut(duration: animationDuration)) {
                                                setValuesOnState(rotation1: .initialTrailing, rotation2: .initialLeading)
                                            }
                                        }
                                }
                                .padding(.top, 12)
                            }
                            .transition(.slide)
                            .animation(.spring(), value: UIState.activeCard)
                        }
                    }
                    .environment(UIState)
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("@Shubham_iosdev")
                            .foregroundStyle(.white)
                            .font(.system(size: 28, weight: .medium, design: .monospaced))
                            .opacity(0.3)
                    }
                    .padding(.trailing, 16)
                }
            }
            .padding()
            .onAppear {
                userCards = AppConstants.cards
                cardBalance = Double(userCards[selectedIndex].balance) ?? 0

                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    if UIState.activeCard != selectedIndex {
                        selectedIndex = UIState.activeCard
                        guard let balance = Double(userCards[selectedIndex].balance) else { return }
                        cardBalance = balance
                    }
                }
            }
        }
    }

    // MARK: - Functions

    /// Applies a `CardState` pair to both face layers, driving the flip animation.
    /// Called with `(.finalTrailing, .finalLeading)` on tap-front and the inverse on tap-back.
    func setValuesOnState(rotation1: CardState, rotation2: CardState) {
        firstViewDegree = rotation1.rotationValues.0
        firstViewOffset = rotation1.rotationValues.1
        firstViewAnchor = rotation1.rotationValues.2
        firstViewYAxis = rotation1.rotationValues.3

        secondViewDegree = rotation2.rotationValues.0
        secondViewOffset = rotation2.rotationValues.1
        secondViewAnchor = rotation2.rotationValues.2
        secondViewYAxis = rotation2.rotationValues.3
    }

    /// The four rotation configurations used to flip `CardFrontView` ↔ `CardBackView`.
    ///
    /// Each case encodes a 4-tuple `(degree, offset, anchor, yAxis)` consumed by
    /// `rotation3DEffect`. The front face transitions `.initialTrailing` → `.finalTrailing`
    /// while the back face transitions `.initialLeading` → `.finalLeading`.
    enum CardState: CaseIterable {
        case initialLeading
        case finalLeading
        case initialTrailing
        case finalTrailing

        // Degree, Offset, Anchor, Axis
        /// Returns `(rotationDegrees, horizontalOffset, anchorPoint, yAxisSign)`.
        var rotationValues: (Double, CGFloat, UnitPoint, CGFloat) {
            switch self {
            case .initialLeading:
                return (90, UIScreen.main.bounds.width * 0.85, UnitPoint.leading, 0.1)
            case .finalLeading:
                return (0, 0, UnitPoint.leading, 1)
            case .initialTrailing:
                return (0, 0, UnitPoint.trailing, -1)
            case .finalTrailing:
                return (180, -UIScreen.main.bounds.width * 0.85, UnitPoint.trailing, -1)
            }
        }
    }
}

#Preview {
    CardView(card: AppConstants.cards[0], UIState: UIStateModel())
}
