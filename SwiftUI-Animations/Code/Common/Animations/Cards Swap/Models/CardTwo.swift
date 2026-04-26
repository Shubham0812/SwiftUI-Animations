//
//  CardTwo.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 11/05/25.
//

import SwiftUI

// MARK: - Usage
// `CardTwo` is the data model for a single card in `CardSwapView`. It holds
// the card number, holder name, provider (used to look up the logo asset by
// raw value) and a `CardDesign` which selects the gradient palette in
// `CardTwoView.CardView(_:)`. Add new providers or designs by extending the
// nested `CardProvider` and `CardDesign` enums.

// Card Model for rendering the Card
struct CardTwo: Identifiable {
    enum CardProvider: String {
        case mastercard
        case masterCardLimited
    }
    
    let id: String = UUID().uuidString
    
    let cardNumber: String
    let cardHolderName: String
    
    let providerType: CardProvider
    
    // To provide Colors to the Card
    var cardDesign: CardDesign
}


enum CardDesign: CaseIterable, Identifiable {
    var id: Self { self }
    
    case black
    case orange
    case pink
}
