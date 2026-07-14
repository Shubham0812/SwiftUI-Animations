//
//  CardsShuffleView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 31/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Model

/// A single card in the shuffle stack.
struct ShuffleCard: Identifiable {
    let id = UUID()

    /// The card's fill color.
    let color: Color

    /// Cumulative X-axis rotation in degrees, fed to the card's `rotation3DEffect`. It stays
    /// at 0 in the default stack (cards rest flat); it's kept as a per-card hook so a rotation
    /// can be animated per shuffle if desired.
    var flipRotation: Double = 0
}

// MARK: - Main View

/// An interactive stack of cards. Drag the front card up past a threshold and it shuffles to
/// the bottom of the stack; release short of the threshold and it springs back into place.
///
/// **How the stack is built:** cards are drawn back-to-front from `cards[0]` (deepest) to
/// `cards[last]` (front). Each card's `depthIndex` (0 for the front card, growing toward the
/// back) drives two cues that fake 3D depth:
/// - **scale** shrinks slightly the further back a card sits, and
/// - **offset** nudges deeper cards upward so their top edges peek out behind the front card.
struct CardsShuffleView: View {

    // MARK: - Variables

    /// The stack, ordered deepest-first. The last element is the interactive front card.
    @State private var cards: [ShuffleCard] = [
        ShuffleCard(color: Color(white: 0.9)),      // Light gray (back)
        ShuffleCard(color: .blue),                  // Blue
        ShuffleCard(color: .red),                   // Red
        ShuffleCard(color: Color(hex: "CCB333"))    // Yellow (front)
    ]

    /// Live translation of the front card while a drag is in progress.
    @State private var dragOffset: CGSize = .zero

    // Tuning constants for the depth illusion and the swipe.
    private let scaleStep: CGFloat = 0.05     // How much smaller each card behind the front is.
    private let depthSpacing: CGFloat = -16   // Upward offset applied per depth level.
    private let swipeThreshold: CGFloat = -60 // Upward drag distance that commits the shuffle.

    // MARK: - Views
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                let isTopCard = index == cards.count - 1
                let depthIndex = cards.count - 1 - index   // 0 = front, grows toward the back.

                ShuffleCardFace(color: card.color)
                    // Depth cues: shrink and lift cards that sit further back.
                    .scaleEffect(1.0 - CGFloat(depthIndex) * scaleStep)
                    .offset(y: CGFloat(depthIndex) * depthSpacing)

                    // Live drag, applied only to the front card.
                    .offset(x: isTopCard ? dragOffset.width : 0,
                            y: isTopCard ? dragOffset.height : 0)

                    // The backward flip: tilts the card on its X-axis with perspective.
                    .rotation3DEffect(.degrees(card.flipRotation), axis: (x: 1, y: 0, z: 0), perspective: 0.8)

                    .zIndex(Double(index))   // Preserve back-to-front draw order.
                    .gesture(dragGesture(isTopCard: isTopCard))
            }
        }
    }

    // MARK: - Functions

    /// Drag gesture for the front card: track the translation live, then either commit the
    /// shuffle or snap back on release depending on how far up the card was dragged.
    private func dragGesture(isTopCard: Bool) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard isTopCard else { return }
                dragOffset = value.translation
            }
            .onEnded { value in
                guard isTopCard else { return }

                if value.translation.height < swipeThreshold {
                    shuffleFrontCardToBack()
                } else {
                    // Threshold not met — spring back to the resting position.
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                        dragOffset = .zero
                    }
                }
            }
    }

    /// Moves the front card to the bottom of the stack.
    ///
    /// Popping the last element and re-inserting it at index 0 makes it the deepest card; the
    /// spring then animates it shrinking and sliding into the back slot while the cards ahead
    /// of it promote forward. The drag offset is reset in the same animation so the motion is
    /// continuous from where the finger left off.
    private func shuffleFrontCardToBack() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
            let swipedCard = cards.removeLast()
            cards.insert(swipedCard, at: 0)
            dragOffset = .zero
        }
    }
}

// MARK: - Card Face

/// The visual for a single card: a rounded rectangle with a placeholder avatar-and-text
/// mockup in the bottom-left corner.
struct ShuffleCardFace: View {
    let color: Color

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(color)
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)

            // Placeholder content: a circular avatar beside two text bars.
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.black.opacity(0.15))
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.15))
                        .frame(width: 100, height: 10)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.15))
                        .frame(width: 60, height: 10)
                }
            }
            .padding(24)
        }
        .frame(width: 320, height: 220)
    }
}

#Preview {
    CardsShuffleView()
}
