//
//  CardSwapViewModel.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 26/04/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Usage
// `CardSwapViewModel` is the source of truth for `CardSwapView`. It owns the
// ordered list of cards (last element is rendered on top) and exposes
// `shiftCard()` which animates the top card to the bottom of the stack.
// Mutating `cards` inside `withAnimation` lets SwiftUI animate the reorder.
//
// We use the iOS 17+ `@Observable` macro here. If you need to support
// earlier iOS versions, switch to `ObservableObject` + `@Published` and use
// `@StateObject` in the view.

// We'll use the new Observable Macro
// You can set the iOS deployment target to < 17 if you want to and use ObservableObject

// You can only set Observable to classes
@Observable
class CardSwapViewModel {

    // MARK: - Variables
    
    // Cards Data set
    // Fill in any info you want
    var cards: [CardTwo] = [
        CardTwo(cardNumber: "9094 5242 1231 2324", cardHolderName: "Shubham Singh", providerType: .mastercard, cardDesign: .black),
        CardTwo(cardNumber: "4123 5952 3912 5978", cardHolderName: "Shubham Singh", providerType: .mastercard, cardDesign: .orange),
        CardTwo(cardNumber: "8923 2329 4023 4012", cardHolderName: "Shubham Singh", providerType: .masterCardLimited, cardDesign: .pink)
    ] // 3 Cards to Render
    
    
    let animationDuration: TimeInterval = 0.5
    
    
    // MARK: - Functions
    
    // Function to shift the last card, and insert it in the 0th index
    func shiftCard() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            let card = cards.removeLast()
            cards.insert(card, at: 0)
        }
    }
}
