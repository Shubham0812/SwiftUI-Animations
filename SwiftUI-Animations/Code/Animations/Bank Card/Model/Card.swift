//
//  Card.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A model representing a single bank card in the carousel demo.
///
/// Used by `CardFrontView` (number, holder, validity, type) and
/// `CardBackView` (security code, number watermark). The `cardPalatte`
/// drives the gradient background of both faces.
struct Card: Identifiable, Hashable {
    /// Whether the card is a credit or debit card — displayed on the front face.
    enum CardType: String {
        case credit = "Credit"
        case debit = "Debit"
    }

    /// Unique identifier used for `ForEach` in the carousel.
    let id: Int
    /// 16-digit card number displayed on the front and watermarked on the back.
    let cardNumber: String
    /// Cardholder name displayed at the bottom of the front face.
    let cardHolderName: String
    /// 3-digit CVV/security code shown on the back face.
    let security: String

    /// Account balance (as a `String`) displayed in `CardView`'s balance header.
    let balance: String
    /// Expiry date in `MM/YY` format displayed on the front face.
    let validity: String
    /// Two-color gradient palette applied to the card's front and back backgrounds.
    var cardPalatte: CardPalatte
    /// Card category — rendered as "Credit Card" or "Debit Card" on the front face.
    let cardType: CardType

    /// Replaces the card's gradient palette — useful for theme switching demos.
    mutating func changePalatte(palatte: CardPalatte) {
        self.cardPalatte = palatte
    }
}


/// A two-color gradient scheme applied to a bank card's front and back faces.
struct CardPalatte: Hashable {
    /// Leading gradient color (top-left on the front face; trailing on the back).
    let colorOne: Color
    /// Trailing gradient color (bottom-right on the front face; leading on the back).
    let colorTwo: Color
}
