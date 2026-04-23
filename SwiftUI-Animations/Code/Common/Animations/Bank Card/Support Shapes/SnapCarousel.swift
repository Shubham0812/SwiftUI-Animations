//
//  SnapCarousel.swift
//  SwiftUI-Animations
//
//  Created by T. Abbas Khan
//  Modified by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Shared observable state for the bank-card snap carousel.
///
/// Injected as an `@Environment` object into `Carousel` and polled by `CardView`
/// to keep the displayed balance in sync with the active card.
@Observable
public class UIStateModel {
    /// Zero-based index of the card currently centered in the carousel.
    var activeCard: Int = 0
    /// Live translation of the in-flight drag gesture (resets to 0 on gesture end).
    var screenDrag: Float = 0.0
}

/// A full-screen container that expands its content to fill all available space.
///
/// Used in `CardView` to give the `Carousel` a black backdrop that stretches edge-to-edge.
struct Canvas<Content: View>: View {
    let content: Content

    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .background(
                Color.background
                    .ignoresSafeArea()
            )
    }
}

/// A horizontally scrolling snap carousel that advances `UIStateModel.activeCard` on swipes >50 pt.
///
/// Computes the total canvas width from `numberOfItems`, `spacing`, and `widthOfHiddenCards`,
/// then derives an `activeOffset` to center the active card. During a drag the offset is
/// augmented by `UIState.screenDrag` for live rubber-band feedback. A haptic impact fires
/// each time the active card changes. Originally by T. Abbas Khan; adapted for this project.
struct Carousel<Items: View>: View {

    // MARK: - Variables

    /// The card `Item` views built by the `@ViewBuilder` closure.
    let items: Items
    /// Total number of cards — used to compute `totalSpacing` and canvas width.
    let numberOfItems: CGFloat
    /// Gap between adjacent cards in points.
    let spacing: CGFloat
    /// Amount of the adjacent (non-active) card visible on each side.
    let widthOfHiddenCards: CGFloat
    /// Pre-computed total spacing: `(numberOfItems − 1) × spacing`.
    let totalSpacing: CGFloat
    /// Effective width of each card slot: screen width minus hidden card areas and spacing.
    let cardWidth: CGFloat

    /// Tracks whether a long press is in progress (used to gate gesture state updates).
    @GestureState var isDetectingLongPress = false
    /// Shared carousel state — provides `activeCard` index and `screenDrag` translation.
    @Environment(UIStateModel.self) var UIState

    // MARK: - Initializers

    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        @ViewBuilder _ items: () -> Items
    ) {
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2)
    }

    // MARK: - Views

    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing

        let activeOffset = xOffsetToShift + leftPadding - (totalMovement * CGFloat(UIState.activeCard))
        let nextOffset = xOffsetToShift + leftPadding - (totalMovement * CGFloat(UIState.activeCard) + 1)

        var calcOffset = Float(activeOffset)
        if calcOffset != Float(nextOffset) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }

        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.UIState.screenDrag = Float(currentState.translation.width)
        }.onEnded { value in
            self.UIState.screenDrag = 0
            if value.translation.width < -50 {
                let nextIndex = min(self.UIState.activeCard + 1, Int(self.numberOfItems) - 1)
                if nextIndex != self.UIState.activeCard {
                    self.UIState.activeCard = nextIndex
                    HapticManager().makeImpactFeedback(mode: .medium)
                }
            }
            if value.translation.width > 50 {
                let nextIndex = max(self.UIState.activeCard - 1, 0)
                if nextIndex != self.UIState.activeCard {
                    self.UIState.activeCard = nextIndex
                    HapticManager().makeImpactFeedback(mode: .medium)
                }
            }
        })
    }
}

/// A single slot in the snap carousel, sizing its content to `cardWidth × cardHeight`.
///
/// Height is derived from `cardWidth / 1.593` (ISO 7810 card ratio). The `_id` matches
/// the `Card.id` so the parent `CardView` can correlate swipe position to the data model.
struct Item<Content: View>: View {
    /// Effective card slot width (screen width minus hidden areas and spacing).
    let cardWidth: CGFloat
    /// Derived card height: `cardWidth / 1.593`.
    let cardHeight: CGFloat

    /// Card identifier matching `Card.id` — used to correlate position with data.
    var _id: Int
    /// The card face content (a `ZStack` of `CardFrontView` + `CardBackView`).
    var content: Content
    /// Binding to the parent's selected index (currently passed as `.constant(1)`).
    @Binding var selectedIndex: Int

    @inlinable public init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardWidth: CGFloat,
        selectedIndex: Binding<Int>,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2)
        self.cardHeight = cardWidth / 1.593
        self._id = _id
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        content
            .frame(width: cardWidth, height: cardHeight, alignment: .top)
    }
}
