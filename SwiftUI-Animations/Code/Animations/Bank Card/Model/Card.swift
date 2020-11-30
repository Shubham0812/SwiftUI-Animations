//
//  Card.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct Card: Identifiable, Hashable {
    enum CardType: String {
        case credit = "Credit"
        case debit = "Debit"
    }
    
    let id: Int
    let cardNumber: String
    let cardHolderName: String
    let security: String
    
    let balance: String
    let validity: String
    var cardPalatte: CardPalatte
    let cardType: CardType
    
    mutating func changePalatte(palatte: CardPalatte) {
        self.cardPalatte = palatte
    }
}


struct CardPalatte: Hashable {
    let colorOne: Color
    let colorTwo: Color
}
