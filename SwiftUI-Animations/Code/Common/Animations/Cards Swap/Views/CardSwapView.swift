//
//  CardSwapView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 26/04/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Usage
// CardSwapView renders a stack of credit cards in a "wallet" layout. Drag the
// top card up or down past `dragOffset` and it cycles to the back of the
// stack via `CardSwapViewModel.shiftCard()`. Tap the toolbar button to toggle
// between the stacked and expanded ("fanned out") layouts.
//
// Layout idea: every card uses the same frame, then the visible stacking is
// produced by negative Y offsets that depend on the card's index. Only the
// last card in the array (the visually top-most one) accepts drag input.
//
// To customise: change the `cards` array on `CardSwapViewModel`, or add new
// `CardDesign` cases (and matching gradient in `CardTwoView.CardView(_:)`).
struct CardSwapView: View {
    
    // MARK: - Variables
    @State private var cardSwapViewModel: CardSwapViewModel = .init()
    @State private var viewAppeared = false
    
    @State private var stackCards = true // stacks the card on top of each other
    
    @State private var yOffset: CGFloat = 0 // Offset to move the card with the Gesture
    @State private var activeCardIndex = -1
    
    let animationDuration: TimeInterval = 0.35
    let width: CGFloat = UIScreen.main.bounds.width - 48 // You can use Geometry Reader as well
    
    let ratioConstant: CGFloat = 1.623
    
    let dragOffset: CGFloat = 120 // Make the card's Swap once it crosses this threshold
    
    // MARK: - Views
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(UIColor.systemBackground)
                .ignoresSafeArea() // By default SwiftUI uses the System Background
            // I added it so that you know how to pass different Colors easily
            
            VStack(alignment: .leading) {
                GenerateTopHeaderView()
                
                // Another VStack for the Cards
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(zip(cardSwapViewModel.cards.indices, cardSwapViewModel.cards)), id: \.1.id) { ix, card in
                        CardTwoView(card: card) // we need to set the frame for the logo
                        
                        // first we'll use the Offset modifer to stack the cards
                            .offset(y: stackCards && ix != 0 ? -((width / ratioConstant) - 16) * CGFloat(ix) : 0)
                        // next, we'll use another Offset modifier to apply the yOffset to the current dragging card
                            .offset(y: ix == activeCardIndex ? yOffset : 0)
                        
                        // we'll use a ZIndex to prioritise the visibility of the last card
                            .zIndex(10.0 + Double(ix))
                            .gesture(getDragGesture(ix))
                    }
                }
                
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
        }
    }
    
    // MARK: - Functions
    /// Function to Generate the Top Header View
    @ViewBuilder
    func GenerateTopHeaderView() -> some View {
        Text("Wallet")
            .font(ClashGrotestk.semibold.font(size: 26))
            .tracking(1.1)
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(alignment: .trailing) {
                Button {
                    withAnimation(.smooth) {
                        stackCards.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 21, weight: .medium))
                }
                .symbolEffect(.bounce.byLayer, options: .speed(1.2), value: stackCards)
            }
            .buttonStyle(.plain)
    }
    
    // Drag Gesture for the Card View
    func getDragGesture(_ ix: Int) -> some Gesture {
        DragGesture(minimumDistance: 32, coordinateSpace: .local)
            .onChanged { value in
                //  Only allow drag on the last card and if stackCards is enabled
                guard ix == cardSwapViewModel.cards.count - 1, stackCards else { return }
                
                //  Set the currently active card being interacted with
                activeCardIndex = ix
                
                let translationY = value.translation.height
                
                // Determine animation type based on drag direction
                let animation: Animation = translationY < 0 ? .smooth : .snappy
                
                // Only restrict downward drag if beyond offset threshold
                guard !(translationY > 0 && yOffset > dragOffset) else { return }
                
                // Animate yOffset update with selected animation
                withAnimation(animation) {
                    yOffset = Double(translationY)
                }
            }
            .onEnded { value in
                // If drag is significant in either direction, shift to next card
                if abs(yOffset) > dragOffset {
                    cardSwapViewModel.shiftCard()
                }
                
                //  Reset state after drag ends
                withAnimation(.snappy(duration: animationDuration)) {
                    activeCardIndex = -1
                    yOffset = 0
                }
            }
    }
}

#Preview {
    CardSwapView()
}
